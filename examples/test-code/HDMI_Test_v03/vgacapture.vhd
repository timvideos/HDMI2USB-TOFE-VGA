--STATUS: On Date 18th June 2014:
--		    Something is displayed on the screen, very rough. for detailed info check the daily log fot his day
--		    PARTIALLY WORKING. PROBLEM maybe with Sync/Clock

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity VGA_Capture is
	Port(
		Reset 		: in std_logic;
		
		DATACK		: in std_logic;	-- 65MHz Pixel clock from AD9984A
		HSOUT			: in std_logic;
		VSOUT			: in std_logic;
		
		R_in			: in std_logic_vector(9 downto 0);
		G_in			: in std_logic_vector(9 downto 0);
		B_in			: in std_logic_vector(9 downto 0);
		
		pclk_in		: in std_logic;	--65MHz Pixel clock from DCM and PLL, different from DATACK
		
		de				: out std_logic;
		HSYNC			: out std_logic;
		VSYNC			: out std_logic;
			
		Red_out		: out std_logic_vector(7 downto 0) ;
		Green_out	: out std_logic_vector(7 downto 0);
		Blue_out		: out std_logic_vector(7 downto 0) 
		
		);
		
end VGA_Capture;

architecture Behavioral of VGA_Capture is

signal HSOUT_delayed : std_logic;
signal hsout_in, vsout_in : std_logic;
signal pixel_clk		: std_logic;
signal Red, Green, Blue : std_logic_vector(9 downto 0);

signal counterX 	: integer	:= 0;
--signal counterX1  : integer;
--signal counterXReset  : std_logic;
signal counterY 	: integer	:= 0;

signal resX		: integer	:= 1024;
signal resY		: integer 	:= 768;

signal spY : integer	:= 6;
signal bpY : integer	:= 29;
signal fpY : integer	:= 3;

signal spX : integer	:= 136;
signal bpX : integer	:= 160;
signal fpX : integer	:= 24;

signal vActive : std_logic := '0' ;
signal hActive : std_logic	:= '0' ;
signal vsync_i : std_logic;
signal hsync_i : std_logic;

signal r_o, g_o, b_o : std_logic_vector(7 downto 0) := (others => '0');
begin

--pixel_clk <= DATACK;
de <= vActive and hActive;

VSYNC	<=  not vsync_i;
HSYNC	<=  not hsync_i;

Red 	<= R_in;
Green <= G_in;
Blue 	<= B_in;
hsout_in <= HSOUT;
--vsout_in <= VSOUT;

Red_out <= r_o;
Green_out <= g_o;
Blue_out <= b_o;

--counterX <= counterX when counterXReset = '0' else 0;

--process(HSOUT_delayed)
--begin
--	if rising_edge(HSOUT_delayed) then
--		counterXReset <= '1';
--	else
--		counterXReset <= '0';
--	end if;
--end process;



process(reset, DATACK)
begin

	if reset = '1' then
	
		r_o 	 <= (others => '0');
		g_o 	 <= (others => '0');
		b_o 	 <= (others => '0');
		counterX <= 0;
		counterY <= 0;
		vsync_i <= '0';
		vActive <= '0';
		hsync_i <= '0';
		hActive <= '0';
	
	elsif rising_edge(DATACK) then
	
--	Red 	<= R_in;
--	Green <= G_in;
--	Blue 	<= B_in;
	
		if HSOUT_delayed = '1' and hsync_i = '0' then  -- necessary to check hsync_i too since HSOUT is high for several clocks
			counterX <= 0;
		else
			counterX <= counterX + 1;
		end if;
				
		if counterY = 0 then 
			vsync_i <= '0';
			vActive <= '0';		
		elsif counterY = spY then
			vsync_i <= '1';
		elsif counterY = ( spY + bpY ) then
			vActive <= '1';		
		elsif counterY = ( spY + bpY + resY ) then
			vActive <= '0';		
		elsif counterY = ( spY + bpY + resY + fpY ) then
			counterY  <= 0;
		end if;
		
		if counterX = 0 then 
			hsync_i <= '0';
			hActive <= '0';		
		elsif counterX = spX then
			hsync_i <= '1';
		elsif counterX = ( spX + bpX ) then
			hActive <= '1';		
		elsif counterX = ( spX + bpX + resX ) then
			hActive <= '0';		
		elsif counterX = ( spX + bpX + resX + fpX ) then
			counterY <= counterY + 1;
			counterX <= 0;			
		end if;
	
		if vActive = '1' and hActive = '1' then	
			r_o 		<= Red(9 downto 2);
			g_o 	<= Green(9 downto 2);
			b_o 	<= Blue(9 downto 2);
		else 
		   r_o 		<= (others => '0') ;
			g_o 	<= (others => '0') ;
			b_o 	<= (others => '0') ;
		end if;
			
	end if;
	
end process;


-- HSOUT is 2 clock cycles delayed from HSYNC and Data is 8 clock cycles delayed from HSYNC
-- So to align HSOUT and Data, we need to delay HSOUT by 6 clock cycles
HSOUT_Align : SRL16E 
	generic map (
		INIT => X"0000")
	port map(
		Q=>HSOUT_delayed,
		A0=>'1',					-- A3:A2:A1:A0 = 0b(0101) = 5 = 6 clock cycles delay
		A1=>'0',
		A2=>'1',
		A3=>'0',
		CE=>'1',
		CLK=>DATACK,
		D=>hsout_in);

end Behavioral;

