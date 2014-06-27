--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:13:41 06/21/2014
-- Design Name:   
-- Module Name:   G:/Rohit/Rohit/Projects/TI_ADC_2014/GSoC/HDL/HDMI_Test_patternvga_v01/tb_rising_edge_detector.vhd
-- Project Name:  HDMI_Test_patternvga_v01
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: rising_edge_detector
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_rising_edge_detector IS
END tb_rising_edge_detector;
 
ARCHITECTURE behavior OF tb_rising_edge_detector IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT rising_edge_detector
	 GENERIC( VECTOR_LEN : integer);
    PORT(
         CLK : IN  std_logic;
         SIGNAL_IN : IN  std_logic_vector;
         OUTPUT : OUT  std_logic_vector
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal SIGNAL_IN : std_logic_vector(0 downto 0) := "0";

 	--Outputs
   signal OUTPUT : std_logic_vector(0 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: rising_edge_detector 
			generic map(VECTOR_LEN => 1)
			PORT MAP (
          CLK => CLK,
          SIGNAL_IN => SIGNAL_IN,
          OUTPUT => OUTPUT
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		SIGNAL_IN <= "0";
      wait for 100 ns;	
		SIGNAL_IN <= "1";

      wait for CLK_period*10;
		
		SIGNAL_IN <= "0";
		wait for 56 ns;
		SIGNAL_IN <= "1";
		wait for 37 ns;
		SIGNAL_IN <= "0";

      -- insert stimulus here 

      wait;
   end process;

END;
