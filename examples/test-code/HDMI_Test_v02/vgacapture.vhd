----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:29:18 06/16/2014 
-- Design Name: 
-- Module Name:    VGA_Capture - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity VGA_Capture is
	Port(
		DATACK		: in std_logic;
		HSOUT			: in std_logic;
		VSOUT			: in std_logic;
		
		R_in			: in std_logic_vector(9 downto 0);
		G_in			: in std_logic_vector(9 downto 0);
		B_in			: in std_logic_vector(9 downto 0);
		
		pclk_in		: in std_logic;
		
		de				: out std_logic;
		VGA_HSYNC	: out std_logic;
		VGS_VSYNC	: out std_logic;
		
		Red_out		: out std_logic_vector(7 downto 0);
		Green_out	: out std_logic_vector(7 downto 0);
		Blue_out		: out std_logic_vector(7 downto 0)
		
		);
		
end VGA_Capture;

architecture Behavioral of VGA_Capture is

begin


end Behavioral;

