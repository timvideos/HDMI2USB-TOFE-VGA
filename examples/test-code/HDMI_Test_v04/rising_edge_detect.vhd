library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rising_edge_detector is
	PORT(
		CLK			: IN 	STD_LOGIC;
		SIGNAL_IN	: IN 	STD_LOGIC;
		OUTPUT		: OUT	STD_LOGIC
	);
end rising_edge_detector;

architecture Behavioral of rising_edge_detector is

signal signal_d : std_logic;

begin

	process(CLK)
	begin
		if rising_edge(CLK) then
			OUTPUT <= (not signal_d) and SIGNAL_IN;
			signal_d <= SIGNAL_IN;
		end if;
	end process;
	
end Behavioral;

