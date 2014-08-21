--Updated: Added synchronizer then level to pulse detector from PDF L07.pdf

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

signal d1, q1, d2, q2, d3, q3, d4, q4, d5, q5: std_logic := '0';

begin
d1 <= signal_in;
d2 <= q1;
d3 <= q2;
--Added Later
d4 <= q3;
d5 <= q4;

--OUTPUT <= (not q3) and d3;
--Added Later
OUTPUT <= (not q5) and d5;

	process(CLK)
	begin
		if rising_edge(CLK) then
			q1 <= d1;
			q2 <= d2;
			q3 <= d3;
			
			--Added Later
			q4 <= d4;
			q5 <= d5;
			
		end if;
	end process;
	
end Behavioral;

