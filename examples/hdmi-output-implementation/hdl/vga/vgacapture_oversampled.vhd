--CHANGES:
--	1. Swapped Red and Blue in 
--				Red 	<= B_in;
--				Green <= G_in;
--				Blue 	<= R_in;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity VGA_Capture_OS is
	Port(
		Reset 		: in std_logic;
		
		DATACK		: in std_logic;	-- 65MHz Pixel clock from AD9984A
		HSOUT			: in std_logic;
		VSOUT			: in std_logic;
		
		R_in			: in std_logic_vector(9 downto 0);
		G_in			: in std_logic_vector(9 downto 0);
		B_in			: in std_logic_vector(9 downto 0);
		
		pclk_in		: in std_logic;	-- Oversampling clock
		
		de				: out std_logic;
		HSYNC			: out std_logic;
		VSYNC			: out std_logic;
			
		Red_out		: out std_logic_vector(7 downto 0) ;
		Green_out	: out std_logic_vector(7 downto 0);
		Blue_out		: out std_logic_vector(7 downto 0) 
		
		);
		
end VGA_Capture_OS;

architecture Behavioral of VGA_Capture_OS is

signal HSOUT_delayed, VSOUT_delayed : std_logic;
signal Red, Green, Blue : std_logic_vector(9 downto 0);
signal r_o, g_o, b_o : std_logic_vector(7 downto 0) := (others => '0');

signal counterX : integer range 0 to 1345  := 0;
signal counterY : integer range 0 to 807   := 0;
signal counter  : integer;
signal resX_i : std_logic_vector(15 downto 0) := X"0400";
signal resY_i : std_logic_vector(15 downto 0) := X"0300";
signal counterX_enable : std_logic := '1';

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
signal data : std_logic_vector(23 downto 0);


COMPONENT rising_edge_detector
	PORT(
		CLK			: IN 	STD_LOGIC;
		SIGNAL_IN	: IN 	STD_LOGIC;
		OUTPUT		: OUT	STD_LOGIC
		);
END COMPONENT;

begin

de <= vActive and hActive;

--VSYNC	<=  vsync_i;
--HSYNC	<=  hsync_i;
VSYNC	<=  not vsync_i;
HSYNC	<=  not hsync_i;

Red 	<= B_in;
Green <= G_in;
Blue 	<= R_in;

--Red_out 	 <= r_o;
--Green_out <= g_o;
--Blue_out  <= b_o;
Red_out 	 <= data(23 downto 16);
Green_out <= data(15 downto 8);
Blue_out  <= data(7 downto 0);

de <= vActive and hActive;


process(pclk_in)
begin
	if rising_edge(pclk_in) then
	
		--counterX <= counterX + 1;
		
		if counter = 9 then
			counter <= 0;
			counterX <= counterX + 1;
		else 
			counter <= counter + 1;
		end if;
		
		if counterY = 0 then 
			vsync_i <= '0';
			vActive <= '0';		
		elsif counterY = spY then
			vsync_i <= '1';
		elsif counterY = (spY+bpY) then
			vActive <= '1';		
		elsif counterY = (spY+bpY+resY) then
			vActive <= '0';		
		elsif counterY = (spY+bpY+resY+fpY) then
			counterY <= 0;
			data <= (others => '0');
		end if;
	

		if counterX = 0 then 
			hsync_i <= '0';
			hActive <= '0';		
		elsif counterX = spX then
			hsync_i <= '1';
		elsif counterX = (spX+bpX) then
			hActive <= '1';		
		elsif counterX = (spX+bpX+resX) then
			hActive <= '0';		
		elsif counterX = (spX+bpX+resX+fpX) then
			counterX <= 0;
			counterY <= counterY +1;
			counterX <= 0;			
		end if;
	
		if vActive = '1' and hActive = '1' then	
			data <= data +1;
		end if;

		
	end if;

end process;
end Behavioral;






--process(pclk_in)
--begin
--	if rising_edge(pclk_in) then
----		if DATACK = '1' then
----			r_o <= Red(9 downto 2);
----			g_o <= Green(9 downto 2);
----			b_o <= Blue(9 downto 2);
----		end if;
--		
----		if counter = 9 then
----			counter <= 0;
--			counterX <= counterX + 1;
----		else 
----			counter <= counter + 1;
----		end if;
--		
----		if hsync_edge = '1' then
----			counterX <= 0;
----			--counterY <= counterY + 1;  --this may be uncommented?
--		
----		
----		if vsync_edge = '1' then
----			counterY <= 0;
----		end if;
----		
----		if counterY = 0 then 
----			vsync_i <= '1';
----			vActive <= '0';		
----		elsif counterY = spY then
----			vsync_i <= '0';
----		elsif counterY = ( spY + bpY ) then
----			vActive <= '1';		
----		elsif counterY = ( spY + bpY + resY ) then
----			vActive <= '0';		
----		elsif counterY = ( spY + bpY + resY + fpY - 1) then
----			counterY  <= 0;
----		end if;
----		
----		if counterX = 0 then 
----			hsync_i <= '1';
----			hActive <= '0';		
----		elsif counterX = spX then
----			hsync_i <= '0';
----		elsif counterX = ( spX + bpX ) then
----			hActive <= '1';		
----		elsif counterX = ( spX + bpX + resX ) then
----			hActive <= '0';		
----		elsif counterX = ( spX + bpX + resX + fpX - 1) then
----			counterY <= counterY + 1; --this maybe commented?
----			counterX <= 0;			
----		end if;
--		if counterY = 0 then 
--			vsync_i <= '0';
--			vActive <= '0';		
--		elsif counterY = spY then
--			vsync_i <= '1';
--		elsif counterY = (spY+bpY) then
--			vActive <= '1';		
--		elsif counterY = (spY+bpY+resY_i) then
--			vActive <= '0';		
--		elsif counterY = (spY+bpY+resY+fpY-1) then
--			counterY <= 0;
--			data <= (others => '0');
--		end if;
--	
--
--		if counterX = 0 then 
--			hsync_i <= '0';
--			hActive <= '0';		
--		elsif counterX = spX then
--			hsync_i <= '1';
--		elsif counterX = (spX+bpX) then
--			hActive <= '1';		
--		elsif counterX = (spX+bpX+resX) then
--			hActive <= '0';		
--		elsif counterX = (spX+bpX+resX+fpX-1) then
--			counterX <= 0;
--			--counterY <= counterY +1;
--			counterX <= 0;			
--		end if;
--	
--		if vActive = '1' and hActive = '1' then	
--			data <= data +1;
--		end if;
--	end if;
--end process;
--
----process(DATACK)
----begin
----	if rising_edge(DATACK) then
----		r_o <= Red(9 downto 2);
----		g_o <= Green(9 downto 2);
----		b_o <= Blue(9 downto 2);
----	end if;
----end process;
----
----
----vsout_edge_detect_inst: rising_edge_detector 
----	PORT MAP( CLK => pclk_in, SIGNAL_IN => VSOUT, OUTPUT => vsync_edge);
----
----hsout_edge_detect_inst: rising_edge_detector
----	PORT MAP( CLK => pclk_in, SIGNAL_IN => HSOUT, OUTPUT => hsync_edge);
--	
--end Behavioral;
