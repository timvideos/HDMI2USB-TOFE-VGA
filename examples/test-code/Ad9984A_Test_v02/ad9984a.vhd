----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    03:45:35 06/06/2014 
-- Design Name: 
-- Module Name:    ad9984a - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- STATUS: WORKING! Getting correct HSYNC (LED1), VSYNC(LED0) and the PixelCLK(LED7 downto 2) HURRAY!
--
----------------------------------------------------------------------------------
library IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;		 
USE ieee.std_logic_unsigned.all;

--library UNISIM;
--use UNISIM.VComponents.all;

entity ad9984a_v02 is
    Port ( R : in  STD_LOGIC_VECTOR (9 downto 0);
           G : in  STD_LOGIC_VECTOR (9 downto 0);
           B : in  STD_LOGIC_VECTOR (9 downto 0);
           DATACK : in  STD_LOGIC;
           HSOUT : in  STD_LOGIC;
           VSOUT : in  STD_LOGIC;
           --SOGOUT : in  STD_LOGIC;
           --OE_FIELD : in  STD_LOGIC;
           --COAST : out  STD_LOGIC;
           --CLAMP : out  STD_LOGIC;
           --PWRDWN : out  STD_LOGIC)
			  LED : out STD_LOGIC_VECTOR (7 downto 0));
end ad9984a_v02;

architecture Behavioral of ad9984a_v02 is

signal vcounter : std_logic_vector (7 downto 0) := (others => '0');
signal hcounter : integer := 0;
signal pixcounter : std_logic_vector (28 downto 0) := (others => '0');


signal v_led : std_logic;
signal h_led: std_logic;
--signal pix_led: std_logic_vector (5 downto 0) := (others => '0');
begin

LED(0) <= v_led;
LED(1) <= h_led;
LED(7 downto 2) <= pixcounter(28 downto 23);

process(VSOUT)
begin
	if rising_edge(VSOUT) then
		if vcounter = "00111011" then
			v_led <= not v_led;
			vcounter <= "00000000"; 
		else
			vcounter <= vcounter + 1;
		end if;
	end if;
end process;

process(HSOUT)
begin
	if rising_edge(HSOUT) then
		if hcounter = 48400 then
			h_led <= not h_led;
			hcounter <= 0;
		else
			hcounter <= hcounter + 1;
		end if;
	end if;
end process;

process(DATACK)
begin
	if rising_edge(DATACK) then
		pixcounter <= pixcounter + 1;
	end if;
end process;	
	
	
end Behavioral;

