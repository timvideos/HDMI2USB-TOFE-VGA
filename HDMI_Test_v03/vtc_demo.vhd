-- WORK IN PROGRESS

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.VComponents.all;


entity vtc_demo_top_level_v03 is
    Port ( RSTBTN : in  STD_LOGIC;
           SYS_CLK : in  STD_LOGIC;
           --SW : in  STD_LOGIC_VECTOR (3 downto 0);
           TMDS : out  STD_LOGIC_VECTOR (3 downto 0);
           TMDSB : out  STD_LOGIC_VECTOR (3 downto 0);
           LED : out  STD_LOGIC_VECTOR (3 downto 0);
           DEBUG : out  STD_LOGIC_VECTOR (1 downto 0);
			  
			  R : in  STD_LOGIC_VECTOR (9 downto 0);
           G : in  STD_LOGIC_VECTOR (9 downto 0);
           B : in  STD_LOGIC_VECTOR (9 downto 0);
           DATACK : in  STD_LOGIC;
           HSOUT : in  STD_LOGIC;
           VSOUT : in  STD_LOGIC
			  
			  );
end vtc_demo_top_level_v03;


architecture Behavioral of vtc_demo_top_level_v03 is

-- signals - Create global clock and synchronous system reset.
signal sysclk : std_logic;
signal clk50m : std_logic;
signal pclk_lckd : std_logic;

constant SW_XGA      : std_logic_vector(3 downto 0) := "0011";

-- signals - DCM_CLKGEN to generate a pixel clock with a variable frequency 
signal clkfx, pclk : std_logic;

-- signals - Pixel Rate clock buffer 
signal pllclk0, pllclk1, pllclk2 : std_logic;
signal pclkx2, pclkx10, pll_lckd : std_logic;
signal clkfbout : std_logic;
signal serdesstrobe : std_logic;
signal bufpll_lock : std_logic; 

signal hvsync_polarity: std_logic; -- 1-Negative, 0-Positive

signal VGA_HSYNC_INT, VGA_VSYNC_INT: std_logic;


-- signals - V/H SYNC and DE generator 
signal active_q: std_logic;
signal vsync, hsync: std_logic;
signal VGA_HSYNC, VGA_VSYNC: std_logic;
signal de: std_logic;
signal active: std_logic; 
  
signal red_in, green_in, blue_in : std_logic_vector(9 downto 0);
signal dataclk, hsout_in, vsout_in : std_logic;  
  
-- signals - Video pattern generator: SMPTE HD Color Bar 
signal red_data, green_data, blue_data : std_logic_vector(7 downto 0);

-- signals - DVI Encoder  
signal tmds_data0, tmds_data1, tmds_data2: std_logic_vector(4 downto 0);
signal tmdsint: std_logic_vector(2 downto 0);
signal serdes_rst: std_logic; 
signal tmdsclkint: std_logic_vector(4 downto 0) := "00000";
signal toggle: std_logic := '0';
signal tmdsclk: std_logic;
  
signal reset : std_logic;

	COMPONENT synchroType2
	PORT(
		async : IN std_logic;
		clk : IN std_logic;          
		sync : OUT std_logic
		);
	END COMPONENT;

	COMPONENT dvi_encoder
	PORT(
		clkin : IN std_logic;
		clkx2in : IN std_logic;
		rstin : IN std_logic;
		blue_din : IN std_logic_vector(7 downto 0);
		green_din : IN std_logic_vector(7 downto 0);
		red_din : IN std_logic_vector(7 downto 0);
		hsync : IN std_logic;
		vsync : IN std_logic;
		de : IN std_logic;          
		tmds_data0 : OUT std_logic_vector(4 downto 0);
		tmds_data1 : OUT std_logic_vector(4 downto 0);
		tmds_data2 : OUT std_logic_vector(4 downto 0)
		);
	END COMPONENT;

	COMPONENT serdes_n_to_1
	PORT(
		ioclk : IN std_logic;
		serdesstrobe : IN std_logic;
		reset : IN std_logic;
		gclk : IN std_logic;
		datain : IN std_logic_vector(4 downto 0);          
		iob_data_out : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT VGA_Capture
	PORT(
		Reset	 : IN std_logic;
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
	
begin

--dataclk <= DATACK;
hsout_in <= HSOUT;
vsout_in <= VSOUT;
red_in(9 downto 0) <= R(9 downto 0);
green_in(9 downto 0) <= G(9 downto 0);
blue_in(9 downto 0) <= B(9 downto 0);

datack_bufg : BUFG port map ( I=> DATACK, O=> dataclk);

--******************************************************************
-- Create global clock and synchronous system reset.                
--******************************************************************

-- off-chip clock signal > IBUF > BUFIO2 > BUFG on-chip clock signal
-- instance of IBUF
sysclk_buf : IBUF port map(I=>SYS_CLK, O=>sysclk);

-- instance of I/O Clock Buffer used as divider
sysclk_div : BUFIO2
	generic map (
		DIVIDE_BYPASS=>FALSE, 
		DIVIDE=>2)
	port map (
		DIVCLK=>clk50m,
		I=>sysclk);
	
-- instance of BUFG
--clk50m_bufgbufg : BUFG port map (I => clk50m, O => clk50m_bufg );


--******************************************************************
-- DCM_CLKGEN to generate a pixel clock with a variable frequency     
--******************************************************************

PCLK_GEN_INST : DCM_CLKGEN
	generic map (
		CLKFX_DIVIDE=>10,
		CLKFX_MULTIPLY=>13,
		CLKIN_PERIOD=>20.000)
   port map (
		CLKFX=>clkfx,
		LOCKED=>pclk_lckd,
		CLKIN=>clk50m,
		FREEZEDCM=>'0',
		RST=>'0');
		
--******************************************************************
-- Pixel Rate clock buffer     
--******************************************************************

pclkbufg : BUFG port map (I=>pllclk1, O=>pclk);

-- 2x pclk is going to be used to drive OSERDES2
-- on the GCLK side
pclkx2bufg : BUFG port map (I=>pllclk2, O=>pclkx2);

-- 10x pclk is used to drive IOCLK network so a bit rate reference
-- can be used by OSERDES2
PLL_OSERDES : PLL_BASE
	generic map (
		CLKIN_PERIOD=>15.384,
		CLKFBOUT_MULT=>10, --set VCO to 10x of CLKIN
		CLKOUT0_DIVIDE=>1,
		CLKOUT1_DIVIDE=>10,
		CLKOUT2_DIVIDE=>5,
		COMPENSATION=>"INTERNAL")  
	port map (
		CLKFBOUT=>clkfbout,
		CLKOUT0=>pllclk0,
		CLKOUT1=>pllclk1,
		CLKOUT2=>pllclk2,
		LOCKED=>pll_lckd,
		CLKFBIN=>clkfbout,
		CLKIN=>clkfx,
		RST=>not pclk_lckd);

ioclk_buf: BUFPLL 
	generic map (DIVIDE=>5) 
	port map (PLLIN=>pllclk0, GCLK=>pclkx2, LOCKED=>pll_lckd,
      IOCLK=>pclkx10, SERDESSTROBE=>serdesstrobe, LOCK=>bufpll_lock);

synchro_reset : synchroType2 
   port map (async=>not pll_lckd, sync=>reset, clk=>pclk);
  
--******************************************************************
-- Video Timing Parameters    
--******************************************************************


	hvsync_polarity <= '1';
--   tc_hsblnk <= HPIXELS_XGA - 1;
--   tc_hssync <= HPIXELS_XGA - 1 + HFNPRCH_XGA;
--   tc_hesync <= HPIXELS_XGA - 1 + HFNPRCH_XGA + HSYNCPW_XGA;
--   tc_heblnk <= HPIXELS_XGA - 1 + HFNPRCH_XGA + HSYNCPW_XGA + HBKPRCH_XGA;
--   tc_vsblnk <=  VLINES_XGA - 1;
--   tc_vssync <=  VLINES_XGA - 1 + VFNPRCH_XGA;
--   tc_vesync <=  VLINES_XGA - 1 + VFNPRCH_XGA + VSYNCPW_XGA;
--   tc_veblnk <=  VLINES_XGA - 1 + VFNPRCH_XGA + VSYNCPW_XGA + VBKPRCH_XGA;		
		

Inst_VGA_Capture: VGA_Capture PORT MAP(
		Reset  => '0',
		DATACK => dataclk,
		HSOUT => hsout_in,
		VSOUT => vsout_in,
		R_in => red_in,
		G_in => green_in,
		B_in => blue_in,
		pclk_in => pclk,
		de => active,
		HSYNC => VGA_HSYNC_INT,
		VSYNC => VGA_VSYNC_INT,
		Red_out => red_data,
		Green_out => green_data,
		Blue_out => blue_data
	);

--timing_inst : timing port map (
--	tc_hsblnk=>tc_hsblnk, --input
--	tc_hssync=>tc_hssync, --input
--	tc_hesync=>tc_hesync, --input
--	tc_heblnk=>tc_heblnk, --input
--	hcount=>bgnd_hcount, --output
--	hsync=>VGA_HSYNC_INT, --output
--	hblnk=>bgnd_hblnk, --output
--	tc_vsblnk=>tc_vsblnk, --input
--	tc_vssync=>tc_vssync, --input
--	tc_vesync=>tc_vesync, --input
--	tc_veblnk=>tc_veblnk, --input
--	vcount=>bgnd_vcount, --output
--	vsync=>VGA_VSYNC_INT, --output
--	vblnk=>bgnd_vblnk, --output
--	restart=>reset,
--	clk=>pclk);

--******************************************************************
-- V/H SYNC and DE generator   
--******************************************************************

--active <= not(bgnd_hblnk) and not(bgnd_vblnk);

process (pclk)
begin
	if rising_edge (pclk) then
		hsync <= VGA_HSYNC_INT xor hvsync_polarity;
		vsync <= VGA_VSYNC_INT xor hvsync_polarity;
		VGA_HSYNC <= hsync;
		VGA_VSYNC <= vsync;
		active_q <= active;
		de <= active_q;
	end if;
end process;

--******************************************************************
-- Video pattern generator:
--   SMPTE HD Color Bar  
--******************************************************************

-- NOTE: the original Verilog files had here an if statement
-- which would select VHDL code meant for Simulation or VHDL
-- meant for Implementation; here I kept only the Implementation
-- code as I do not do simulation at this time;

--clrbar : hdcolorbar port map (
--	i_clk_74M=>pclk,
--	i_rst=>reset,
--	i_hcnt=>'0' & bgnd_hcount, -- Note: Verilog code gave only 11 bits directly to
--	i_vcnt=>'0' & bgnd_vcount, -- i_hcnt, which requires 12 bits however;
--	baronly=>'0',
--	i_format=>"00",
--	o_r=>red_data,
--	o_g=>green_data,
--	o_b=>blue_data);

--******************************************************************
-- DVI Encoder  
--******************************************************************

enc0 : dvi_encoder port map (
	clkin      =>pclk,
	clkx2in    =>pclkx2,
	rstin      =>reset,
	blue_din   =>blue_data,
	green_din  =>green_data,
	red_din    =>red_data,
	hsync      =>VGA_HSYNC,
	vsync      =>VGA_VSYNC,
	de         =>de,
	tmds_data0 =>tmds_data0,
	tmds_data1 =>tmds_data1,
	tmds_data2 =>tmds_data2);

serdes_rst <= RSTBTN or not(bufpll_lock);

-- NOTE: the original Verilog files had here an if statement
-- which would select between DEBUG code or this;

oserdes0 : serdes_n_to_1 
	port map(
		ioclk=>pclkx10,
		serdesstrobe=>serdesstrobe,
		reset=>serdes_rst,
		gclk=>pclkx2,
		datain=>tmds_data0,
		iob_data_out=>tmdsint(0));
		
oserdes1 : serdes_n_to_1 
	port map(
		ioclk=>pclkx10,
		serdesstrobe=>serdesstrobe,
		reset=>serdes_rst,
		gclk=>pclkx2,
		datain=>tmds_data1,
		iob_data_out=>tmdsint(1));
		
oserdes2 : serdes_n_to_1 
	port map(
		ioclk=>pclkx10,
		serdesstrobe=>serdesstrobe,
		reset=>serdes_rst,
		gclk=>pclkx2,
		datain=>tmds_data2,
		iob_data_out=>tmdsint(2));		

TMDS0 : OBUFDS port map (I=>tmdsint(0), O=>TMDS(0), OB=>TMDSB(0));
TMDS1 : OBUFDS port map (I=>tmdsint(1), O=>TMDS(1), OB=>TMDSB(1));
TMDS2 : OBUFDS port map (I=>tmdsint(2), O=>TMDS(2), OB=>TMDSB(2));
  
process (pclkx2, serdes_rst)
begin
	if serdes_rst = '1' then
		toggle <= '0';
	elsif rising_edge(pclkx2) then
		toggle <= not(toggle);	
	end if;
end process;

process (pclkx2)
begin
	if rising_edge(pclkx2) then
		if (toggle = '1') then
			tmdsclkint <= "11111";
		else
			tmdsclkint <= "00000";
		end if;
	end if;
end process;

clkout : serdes_n_to_1 port map (
	iob_data_out =>tmdsclk,
	ioclk        =>pclkx10,
	serdesstrobe =>serdesstrobe,
	gclk         =>pclkx2,
	reset        =>serdes_rst,
	datain       =>tmdsclkint);

TMDS3 : OBUFDS port map (I=>tmdsclk, O=>TMDS(3), OB=>TMDSB(3)); -- clock

--******************************************************************
-- Debug Ports 
--******************************************************************

DEBUG(0) <= VGA_HSYNC;
DEBUG(1) <= VGA_VSYNC;

--******************************************************************
-- LEDs
--******************************************************************

LED <= bufpll_lock & RSTBTN & VGA_HSYNC & VGA_VSYNC;

end Behavioral;
