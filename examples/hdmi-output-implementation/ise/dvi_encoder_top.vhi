
-- VHDL Instantiation Created from source file dvi_encoder_top.vhd -- 17:52:13 07/07/2014
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT dvi_encoder_top
	PORT(
		pclk : IN std_logic;
		pclkx2 : IN std_logic;
		pclkx10 : IN std_logic;
		serdesstrobe : IN std_logic;
		rstin : IN std_logic;
		blue_din : IN std_logic_vector(7 downto 0);
		green_din : IN std_logic_vector(7 downto 0);
		red_din : IN std_logic_vector(7 downto 0);
		hsync : IN std_logic;
		vsync : IN std_logic;
		de : IN std_logic;          
		TMDS : OUT std_logic_vector(3 downto 0);
		TMDSB : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;

	Inst_dvi_encoder_top: dvi_encoder_top PORT MAP(
		pclk => ,
		pclkx2 => ,
		pclkx10 => ,
		serdesstrobe => ,
		rstin => ,
		blue_din => ,
		green_din => ,
		red_din => ,
		hsync => ,
		vsync => ,
		de => ,
		TMDS => ,
		TMDSB => 
	);


