--STATUS: 1X or 2X clock....uart debug

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

library UNISIM;
use UNISIM.VComponents.all;


entity VGA_Capture is
	generic(
		USE_CLOCK     : string    := "SYSCLK"; -- Use eihter SYSCLK or DATACK
		SAMPLING_MODE : string    := "ON";      -- Oversampling? 1-Yes or 0-No
		OVERSAMPLING  : integer   := 6;        -- Oversampling factor
		DATACK_FREQ	  : integer   := 1;        -- DATACK Freq is 1x or 2x pixel clock
		PATTERN		  : string    := "OFF"		-- Whether to use test pattern or instead vga capture
);
	port(
		Reset 		: in std_logic;
		
		DATACK		: in std_logic;	-- 65MHz Pixel clock from AD9984A
		HSOUT			: in std_logic;
		VSOUT			: in std_logic;
		SOGOUT      : in std_logic;
		
		R_in			: in std_logic_vector(9 downto 0);
		G_in			: in std_logic_vector(9 downto 0);
		B_in			: in std_logic_vector(9 downto 0);
		
		pclk_in		: in std_logic;	--65MHz Pixel clock from DCM and PLL, different from DATACK
		pclkx_in		: in std_logic; 	-- pclk_in x N oversampling clock
		clk50m		: in std_logic;	--50 MHz clock
		uart_tx		: out std_logic;
		debug_sw    : in std_logic_vector ( 3 downto 0);
		de				: out std_logic;
		HSYNC			: out std_logic;
		VSYNC			: out std_logic;
			
		Red_out		: out std_logic_vector(7 downto 0) ;
		Green_out	: out std_logic_vector(7 downto 0);
		Blue_out		: out std_logic_vector(7 downto 0) 
		
		);
		
end VGA_Capture;

architecture Behavioral of VGA_Capture is

signal HSOUT_delayed, VSOUT_delayed : std_logic;
signal Red, Green, Blue : std_logic_vector(9 downto 0);
signal r_o, g_o, b_o : std_logic_vector(7 downto 0) := (others => '0');

signal counterX, counterY 	: integer	:= 0;
signal counterX_unsigned, counterY_unsigned : std_logic_vector(15 downto 0);
signal vsync_edge, hsync_edge, vsync_edge1, hsync_edge1,hsync_edge_temp 	: std_logic	:= '0';

constant resX	: integer	:= 1024;
constant resY	: integer 	:= 768;
constant spY 	: integer	:= 6;
constant bpY 	: integer	:= 29;
constant fpY 	: integer	:= 3;
constant spX 	: integer	:= 136;
constant bpX 	: integer	:= 160;
constant fpX 	: integer	:= 24;

signal vActive, hActive : std_logic := '0' ;
signal vsync_i, hsync_i : std_logic;
signal data : std_logic_vector(23 downto 0) := (others => '0');
signal wr_uart, tx_full, rd_uart, rx, rx_empty : std_logic;
   
signal uart_data, r_data : std_logic_vector( 7 downto 0);

signal num_columns	: integer; 
signal num_rows	: integer; 
signal MULTIPLIER  : integer;
-- Configured clock as per generic's parameter. See generate statements
signal CONF_CLK : std_logic; 


begin

CLK_Cfg_sysclk: if (USE_CLOCK = "SYSCLK" and SAMPLING_MODE = "OFF") generate
	CONF_CLK   <= pclk_in;
	MULTIPLIER <= 1;
end generate;

CLK_Cfg_sysclk_oversampling: if (USE_CLOCK = "SYSCLK" and SAMPLING_MODE = "ON") generate
	CONF_CLK   <= pclkx_in;
	MULTIPLIER <= OVERSAMPLING;
end generate;

CLK_Config_datack: if (USE_CLOCK = "DATACK") generate
	CONF_CLK   <= DATACK;
	MULTIPLIER <= DATACK_FREQ;
end generate;

pattern_on: if (PATTERN = "ON") generate
--	Red_out 	 <= data(23 downto 16);
--   Green_out <= data(15 downto 8);
--   Blue_out  <= data(7 downto 0);
end generate;

capture_on: if (PATTERN = "OFF") generate
--	Red_out 	 <= r_o;
--   Green_out <= g_o;
--   Blue_out  <= b_o;
end generate;

de <= vActive and hActive;

VSYNC	<= vsync_i;
HSYNC	<= hsync_i;
--VSYNC	<= VSOUT;
--HSYNC	<= SOGOUT;

Red 	<= B_in;
Green <= G_in;
Blue 	<= R_in;

Red_out 	 <= r_o when (debug_sw(3)='1') else data(23 downto 16);
Green_out <= g_o when (debug_sw(3)='1') else data(15 downto 8);
Blue_out  <= b_o when (debug_sw(3)='1') else data(7 downto 0);



--counterX_unsigned <= conv_std_logic_vector(counterX, 16);
--counterY_unsigned <= conv_std_logic_vector(counterY, 16);

vsout_edge_detect_inst: entity work.rising_edge_detector 
	PORT MAP( CLK => CONF_CLK, SIGNAL_IN => VSOUT, OUTPUT => vsync_edge1);--_edge);

hsout_edge_detect_inst: entity work.rising_edge_detector
	PORT MAP( CLK => CONF_CLK, SIGNAL_IN => HSOUT, OUTPUT => hsync_edge1);--_edge);

-- Capture Data on rising edge of DATACK
process(DATACK)
begin
	if rising_edge(DATACK) then
		r_o 	<= Red(9 downto 2);
		g_o 	<= Green(9 downto 2);
		b_o 	<= Blue(9 downto 2);
	end if;
end process;

--process(reset, CONF_CLK)
process(reset, CONF_CLK, HSOUT, VSOUT)

begin

	if rising_edge(CONF_CLK) then
	
--		r_o 	<= Red(9 downto 2);
--		g_o 	<= Green(9 downto 2);
--		b_o 	<= Blue(9 downto 2);
		counterX_unsigned <= conv_std_logic_vector(counterX, 16);
		counterY_unsigned <= conv_std_logic_vector(counterY, 16);
		--counterX <= counterX + 1;  
		
		--counterX <= counterX + 1;		moved this to else condition of rising_edge.
		
		if hsync_edge = '1' then
			counterY <= counterY + 1;
			if (tx_full = '0') and (debug_sw = "0101") then
				uart_data <= counterX_unsigned(15 downto 8);
				wr_uart <= '1';
			elsif (tx_full = '0') and (debug_sw = "0110") then
				uart_data <= counterX_unsigned(7 downto 0);
				wr_uart <= '1';
			else
				wr_uart <= '0';
			end if;
			counterX <= 0;
		else  --uncommented this else condition
			counterX <= counterX + 1;  --this statement moved in from above
			
		end if;
		
		
		if vsync_edge = '1' then
			if (tx_full = '0') and (debug_sw = "0001") then
				uart_data <= counterX_unsigned(15 downto 8);
				wr_uart <= '1';
			elsif (tx_full = '0') and (debug_sw = "0010") then
				uart_data <= counterX_unsigned(7 downto 0);
				wr_uart <= '1';
				
			elsif (tx_full = '0') and (debug_sw = "0011") then
				uart_data <= counterY_unsigned(15 downto 8);
				wr_uart <= '1';
			
			elsif (tx_full = '0') and (debug_sw = "0100") then
				uart_data <= counterY_unsigned(7 downto 0);
				wr_uart <= '1';
			else
				wr_uart <= '0';
			end if;
			counterY <= 0;
			data <= (others => '0');
			
		end if;
		
		if (counterY >=0) and (counterY < spY) then 
			vsync_i <= '1';
			vActive <= '0';		
		elsif (counterY >= spY) and (counterY < (spY + bpY))then
			vsync_i <= '0';
		elsif (counterY >= (spY + bpY)) and (counterY < ( spY + bpY + resY)) then
			vActive <= '1';		
		elsif (counterY >= (spY + bpY + resY)) and (counterY < ( spY + bpY + resY + fpY)) then
			vActive <= '0';		
		else--if counterY = ( spY + bpY + resY + fpY ) then
			data <= (others => '0');
			--counterY  <= 0;
			vActive <= '0';
		end if;
		
		if (counterX >= 0) and (counterX < MULTIPLIER*spX) then 
			hsync_i <= '1';
			hActive <= '0';		
		elsif (counterX >= MULTIPLIER*spX) and (counterX < MULTIPLIER*(spX + bpX)) then
			hsync_i <= '0';
		elsif (counterX >= MULTIPLIER*( spX + bpX )) and (counterX < MULTIPLIER*(spX + bpX + resX)) then
			hActive <= '1';		
		elsif (counterX >= MULTIPLIER*( spX + bpX + resX )) and (counterX < MULTIPLIER*(spX + bpX + resX + fpX)) then
			hActive <= '0';		
		elsif counterX = MULTIPLIER*( spX + bpX + resX + fpX ) then
			--counterY <= counterY + 1;
			--counterX <= 0;			
		end if;
		
		if vActive = '1' and hActive = '1' then
			data <= data + 1;
--			r_o 	<= Red(9 downto 2);
--			g_o 	<= Green(9 downto 2);
--			b_o 	<= Blue(9 downto 2);
		else
			--data <= (others => '0');
--		r_o 	<= (others => '0');
--		g_o 	<= (others => '0');
--		b_o 	<= (others => '0');
		end if;
	end if;
	
--	-- Below part added on 11th July 2014
--	if rising_edge(HSOUT) then
--		counterY <= counterY + 1;
--		counterX <= 0;
--	end if;
--	
--	if rising_edge(VSOUT) then
--		counterY <= 0;
--		data <= (others => '0');
--		counterX <= 0;
--	end if;
	
end process;

--process (counterX, counterY)
--begin
--		
--		
--		--if vActive = '1' and hActive='1' then
--			
--		--end if;
--		
--end process;



-- HSOUT is 2 clock cycles delayed from HSYNC and Data is 8 clock cycles delayed from HSYNC
-- So to align HSOUT and Data, we need to delay HSOUT by 6 clock cycles
HSOUT_Align : entity work.delayer
	generic map (
		DELAY_AMOUNT => 6 * 1)
	port map (
		input  => hsync_edge1,
		output => hsync_edge,
		clk    => CONF_CLK );


VSOUT_Align : entity work.delayer
	generic map (
		DELAY_AMOUNT => 7 * 1)
	port map (
		input  => vsync_edge1,
		output => vsync_edge,
		clk    => CONF_CLK );
		

inst_uart: entity work.uart PORT MAP(
		clk      => clk50m,
		reset    => '0',
		rd_uart  => rd_uart,
		wr_uart  => wr_uart,
		rx       => rx,
		w_data   => uart_data,
		tx_full  => tx_full,
		rx_empty => rx_empty,
		tx       => uart_tx,
		r_data   => r_data);
		
end Behavioral;

