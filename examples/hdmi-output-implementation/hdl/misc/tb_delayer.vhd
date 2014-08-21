--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:50:14 06/29/2014
-- Design Name:   
-- Module Name:   G:/Rohit/Rohit/Projects/TI_ADC_2014/GSoC/HDL/HDMI_Test_v06/hdl/misc/tb_delayer.vhd
-- Project Name:  HDMI_Test_v06
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: delayer
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
 
ENTITY tb_delayer IS
END tb_delayer;
 
ARCHITECTURE behavior OF tb_delayer IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT delayer
    PORT(
         input : IN  std_logic;
         output : OUT  std_logic;
         clk : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal input : std_logic := '0';
   signal output : std_logic := '0';
   signal clk : std_logic := '0';

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.delayer PORT MAP (
          input => input,
          output => output,
          clk => clk
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '1';
		wait for clk_period/2;
		clk <= '0';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		input <= '0';
      wait for clk_period*10;	
		input <= '1';
		wait for clk_period*30;
		input <= '0';
		wait for clk_period*1500;
		input <= '1';
		wait for clk_period*1;
		input <= '0';
		
      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
