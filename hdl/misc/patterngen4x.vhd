--STATUS: 1X or 2X clock....uart debug
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.VComponents.all;

entity VGA_TestPattern4x is
	Port(
		Reset 		: in std_logic;
		
		DATACK		: in std_logic;	-- 65MHz Pixel clock from AD9984A
		HSOUT			: in std_logic;
		VSOUT			: in std_logic;
		
		R_in			: in std_logic_vector(9 downto 0);
		G_in			: in std_logic_vector(9 downto 0);
		B_in			: in std_logic_vector(9 downto 0);
		
		pclk_in		: in std_logic;	--65MHz Pixel clock from DCM and PLL, different from DATACK
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
		
end VGA_TestPattern4x;

architecture Behavioral of VGA_TestPattern4x is

signal HSOUT_delayed, VSOUT_delayed : std_logic;
signal Red, Green, Blue : std_logic_vector(9 downto 0);
signal r_o, g_o, b_o : std_logic_vector(7 downto 0) := (others => '0');

signal counterX, counterY 	: integer	:= 0;
signal counterX_unsigned, counterY_unsigned : std_logic_vector(15 downto 0);
signal vsync_edge, hsync_edge, vsync_edge1, hsync_edge1 	: std_logic	:= '0';

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

COMPONENT rising_edge_detector
	PORT(
		CLK			: IN 	STD_LOGIC;
		SIGNAL_IN	: IN 	STD_LOGIC;
		OUTPUT		: OUT	STD_LOGIC
		);
END COMPONENT;
COMPONENT uart
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		rd_uart : IN std_logic;
		wr_uart : IN std_logic;
		rx : IN std_logic;
		w_data : IN std_logic_vector(7 downto 0);          
		tx_full : OUT std_logic;
		rx_empty : OUT std_logic;
		tx : OUT std_logic;
		r_data : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
begin

de <= vActive and hActive;

VSYNC	<= vsync_i;
HSYNC	<= hsync_i;
--VSYNC	<= VSOUT;
--HSYNC	<= HSOUT;

Red 	<= B_in;
Green <= G_in;
Blue 	<= R_in;

--Red_out 	 <= r_o;
--Green_out <= g_o;
--Blue_out  <= b_o;


Red_out 	 <= data(23 downto 16);
Green_out <= data(15 downto 8);
Blue_out  <= data(7 downto 0);
--counterX_unsigned <= conv_std_logic_vector(counterX, 16);
--counterY_unsigned <= conv_std_logic_vector(counterY, 16);

vsout_edge_detect_inst: rising_edge_detector 
	PORT MAP( CLK => DATACK, SIGNAL_IN => VSOUT, OUTPUT => vsync_edge1);--_edge);

hsout_edge_detect_inst: rising_edge_detector
	PORT MAP( CLK => DATACK, SIGNAL_IN => HSOUT, OUTPUT => hsync_edge1);--_edge);


process(reset, DATACK)
begin

	if rising_edge(DATACK) then
	
--		r_o 	<= Red(9 downto 2);
--		g_o 	<= Green(9 downto 2);
--		b_o 	<= Blue(9 downto 2);
		counterX_unsigned <= conv_std_logic_vector(counterX, 16);
		counterY_unsigned <= conv_std_logic_vector(counterY, 16);
		counterX <= counterX + 1;  
		
		--counterX <= counterX + 1;		moved this to else condition of rising_edge.
		
--		if hsync_edge1 = '1' then
--			counterY <= counterY + 1;
--			if (tx_full = '0') and (debug_sw = "0101") then
--				uart_data <= counterX_unsigned(15 downto 8);
--				wr_uart <= '1';
--			elsif (tx_full = '0') and (debug_sw = "0110") then
--				uart_data <= counterX_unsigned(7 downto 0);
--				wr_uart <= '1';
--			else
--				wr_uart <= '0';
--			end if;
--			counterX <= 0;
--		else  --uncommented this else condition
--			counterX <= counterX + 1;  --this statement moved in from above
--			
--		end if;
--		
--		
--		if vsync_edge1 = '1' then
--			if (tx_full = '0') and (debug_sw = "0001") then
--				uart_data <= counterX_unsigned(15 downto 8);
--				wr_uart <= '1';
--			elsif (tx_full = '0') and (debug_sw = "0010") then
--				uart_data <= counterX_unsigned(7 downto 0);
--				wr_uart <= '1';
--				
--			elsif (tx_full = '0') and (debug_sw = "0011") then
--				uart_data <= counterY_unsigned(15 downto 8);
--				wr_uart <= '1';
--			
--			elsif (tx_full = '0') and (debug_sw = "0100") then
--				uart_data <= counterY_unsigned(7 downto 0);
--				wr_uart <= '1';
--			else
--				wr_uart <= '0';
--			end if;
--			counterY <= 0;
--			data <= (others => '0');
			
--		end if;
		
		if (counterY >=0) and (counterY < spY) then 
			vsync_i <= '1';
			vActive <= '0';		
		elsif (counterY >= spY) and (counterY < (spY + bpY))then
			vsync_i <= '0';
		elsif (counterY >= (spY + bpY)) and (counterY < ( spY + bpY + resY)) then
			vActive <= '1';		
		elsif (counterY >= (spY + bpY + resY)) and (counterY < ( spY + bpY + resY + fpY)) then
			vActive <= '0';		
		elsif counterY = ( spY + bpY + resY + fpY ) then
			data <= (others => '0');
			counterY  <= 0;
			vActive <= '0';
		end if;
		
		if (counterX >= 0) and (counterX < 4*spX) then 
			hsync_i <= '1';
			hActive <= '0';		
		elsif (counterX >= 4*spX) and (counterX < 4*(spX + bpX)) then
			hsync_i <= '0';
		elsif (counterX >= 4*( spX + bpX )) and (counterX < 4*(spX + bpX + resX)) then
			hActive <= '1';		
		elsif (counterX >= 4*( spX + bpX + resX )) and (counterX < 4*(spX + bpX + resX + fpX)) then
			hActive <= '0';		
		elsif counterX = 4*( spX + bpX + resX + fpX ) then
			counterY <= counterY + 1;
			counterX <= 0;			
		end if;
		
		if vActive = '1' and hActive = '1' then
			data <= data + 1;
			r_o 	<= Red(9 downto 2);
			g_o 	<= Green(9 downto 2);
			b_o 	<= Blue(9 downto 2);
		else
			data <= (others => '0');
		r_o 	<= (others => '0');
		g_o 	<= (others => '0');
		b_o 	<= (others => '0');
		end if;
	end if;
	
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
HSOUT_Align : SRL16E 
	generic map (
		INIT => X"0000")
	port map(
		Q=>hsync_edge,
		A0=>'1',					-- A3:A2:A1:A0 = 0b(0101) = 5 = 6 clock cycles delay
		A1=>'0',
		A2=>'1',
		A3=>'0',
		CE=>'1',
		CLK=>DATACK,
		D=>hsync_edge1);
VSOUT_Align : SRL16E 
	generic map (
		INIT => X"0000")
	port map(
		Q=>vsync_edge,
		A0=>'1',					-- A3:A2:A1:A0 = 0b(0111) = 7 = 8 clock cycles delay
		A1=>'0',
		A2=>'0',
		A3=>'0',
		CE=>'1',
		CLK=>DATACK,
		D=>vsync_edge1);
inst_uart: uart PORT MAP(
		clk => clk50m,
		reset => '0',
		rd_uart => rd_uart,
		wr_uart => wr_uart,
		rx => rx,
		w_data => uart_data,
		tx_full => tx_full,
		rx_empty => rx_empty,
		tx => uart_tx,
		r_data => r_data
	);
end Behavioral;

