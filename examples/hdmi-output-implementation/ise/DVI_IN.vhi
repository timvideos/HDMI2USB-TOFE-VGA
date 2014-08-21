
-- VHDL Instantiation Created from source file DVI_IN.vhd -- 00:00:40 07/12/2014
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT DVI_IN
	PORT(
		DVI_CLK : IN std_logic;
		DVIIN_DE : IN std_logic;
		DVIIN_HS : IN std_logic;
		DVIIN_VS : IN std_logic;
		DVIIN_R : IN std_logic_vector(9 downto 0);
		DVIIN_G : IN std_logic_vector(9 downto 0);
		DVIIN_B : IN std_logic_vector(9 downto 0);
		USE_DE : IN std_logic;
		CROP_EN : IN std_logic;
		CROP_START_X : IN std_logic_vector(15 downto 0);
		CROP_WIDTH_X : IN std_logic_vector(15 downto 0);
		CROP_START_Y : IN std_logic_vector(15 downto 0);
		CROP_HEIGHT_Y : IN std_logic_vector(15 downto 0);          
		DE : OUT std_logic;
		HS : OUT std_logic;
		VS : OUT std_logic;
		R : OUT std_logic_vector(9 downto 0);
		G : OUT std_logic_vector(9 downto 0);
		B : OUT std_logic_vector(9 downto 0);
		DET_VS_POL : OUT std_logic;
		DET_HS_POL : OUT std_logic
		);
	END COMPONENT;

	Inst_DVI_IN: DVI_IN PORT MAP(
		DVI_CLK => ,
		DVIIN_DE => ,
		DVIIN_HS => ,
		DVIIN_VS => ,
		DVIIN_R => ,
		DVIIN_G => ,
		DVIIN_B => ,
		USE_DE => ,
		CROP_EN => ,
		CROP_START_X => ,
		CROP_WIDTH_X => ,
		CROP_START_Y => ,
		CROP_HEIGHT_Y => ,
		DE => ,
		HS => ,
		VS => ,
		R => ,
		G => ,
		B => ,
		DET_VS_POL => ,
		DET_HS_POL => 
	);


