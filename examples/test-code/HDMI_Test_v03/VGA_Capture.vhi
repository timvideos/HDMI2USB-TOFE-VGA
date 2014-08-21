
-- VHDL Instantiation Created from source file VGA_Capture.vhd -- 21:51:52 06/17/2014
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT VGA_Capture
	PORT(
		DATACK : IN std_logic;
		HSOUT : IN std_logic;
		VSOUT : IN std_logic;
		R_in : IN std_logic_vector(9 downto 0);
		G_in : IN std_logic_vector(9 downto 0);
		B_in : IN std_logic_vector(9 downto 0);
		pclk_in : IN std_logic;          
		de : OUT std_logic;
		HSYNC : OUT std_logic;
		VSYNC : OUT std_logic;
		Red_out : OUT std_logic_vector(7 downto 0);
		Green_out : OUT std_logic_vector(7 downto 0);
		Blue_out : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	Inst_VGA_Capture: VGA_Capture PORT MAP(
		DATACK => ,
		HSOUT => ,
		VSOUT => ,
		R_in => ,
		G_in => ,
		B_in => ,
		pclk_in => ,
		de => ,
		HSYNC => ,
		VSYNC => ,
		Red_out => ,
		Green_out => ,
		Blue_out => 
	);


