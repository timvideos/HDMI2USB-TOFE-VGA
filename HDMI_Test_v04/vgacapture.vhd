----STATUS: On Date 19th June 2014. 
--				Current VGA_Capture module is capturing nicely but with some flickering!
--				STATUS: WoW! WORKING 80-90% successfully!

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
signal Red, Green, Blue : std_logic_vector(9 downto 0);

signal counterX, counterY 	: integer	:= 0;

signal vsync_edge, hsync_edge	: std_logic	:= '0';

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

signal r_o, g_o, b_o : std_logic_vector(7 downto 0) := (others => '0');

	COMPONENT rising_edge_detector
		PORT(
			CLK			: IN 	STD_LOGIC;
			SIGNAL_IN	: IN 	STD_LOGIC;
			OUTPUT		: OUT	STD_LOGIC
		);
	END COMPONENT;

begin

de <= vActive and hActive;

VSYNC	<= vsync_i;
HSYNC	<= hsync_i;

Red 	<= R_in;
Green <= G_in;
Blue 	<= B_in;

Red_out 	 <= r_o;
Green_out <= g_o;
Blue_out  <= b_o;

vsout_edge_detect_inst: rising_edge_detector 
	PORT MAP( CLK => DATACK, SIGNAL_IN => VSOUT, OUTPUT => vsync_edge);

hsout_edge_detect_inst: rising_edge_detector
	PORT MAP( CLK => DATACK, SIGNAL_IN => HSOUT_delayed, OUTPUT => hsync_edge);


process(reset, DATACK)
begin

	if rising_edge(DATACK) then
	
		r_o 	<= Red(9 downto 2);
		g_o 	<= Green(9 downto 2);
		b_o 	<= Blue(9 downto 2);
		
		if hsync_edge = '1' then
			counterX <= 0;
			counterY <= counterY + 1;
		else
			counterX <= counterX + 1;
		end if;
		
		if vsync_edge = '1' then
			counterY <= 0;
		end if;
		
		if counterY = 0 then 
			vsync_i <= '1';
			vActive <= '0';		
		elsif counterY = spY then
			vsync_i <= '0';
		elsif counterY = ( spY + bpY ) then
			vActive <= '1';		
		elsif counterY = ( spY + bpY + resY ) then
			vActive <= '0';		
		elsif counterY = ( spY + bpY + resY + fpY ) then
			counterY  <= 0;
		end if;
		
		if counterX = 0 then 
			hsync_i <= '1';
			hActive <= '0';		
		elsif counterX = spX then
			hsync_i <= '0';
		elsif counterX = ( spX + bpX ) then
			hActive <= '1';		
		elsif counterX = ( spX + bpX + resX ) then
			hActive <= '0';		
		elsif counterX = ( spX + bpX + resX + fpX ) then
			--counterY <= counterY + 1;
			counterX <= 0;			
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
		D=>HSOUT);

end Behavioral;

