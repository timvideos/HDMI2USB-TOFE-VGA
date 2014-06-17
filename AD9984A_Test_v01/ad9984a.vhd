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
-- STATUS: WORKING! Getting correct VSYNC and the LEDS are UPDATED every second! HURRAY!
--
----------------------------------------------------------------------------------
library IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;		 
USE ieee.std_logic_unsigned.all;

--library UNISIM;
--use UNISIM.VComponents.all;

entity ad9984a is
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
end ad9984a;

architecture Behavioral of ad9984a is

signal counter : std_logic_vector (7 downto 0) := (others => '0');
signal leds : std_logic_vector(7 downto 0) := (others => '0');
begin

LED <= leds;

process(VSOUT)
begin
	if rising_edge(VSOUT) then
		if counter = "00111011" then
			leds <= leds + 1;
			counter <= "00000000"; 
		else
			counter <= counter + 1;
		end if;
	end if;
end process;

end Behavioral;

