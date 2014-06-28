library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity delayer is
	generic( 
		DELAY_AMOUNT : integer := 12
);
	port(
		input  : in  std_logic;
		output : out std_logic;
		clk    : in  std_logic
);
end delayer;
architecture behavioral of delayer is

signal a_store : std_logic_vector(DELAY_AMOUNT-1 downto 0) := (others => '0');

begin
process(clk)
begin
if rising_edge(clk) then
  a_store <= a_store(a_store'high-1 downto 0) & input;
  output  <= a_store(a_store'high);
end if;
end process;
end behavioral;



