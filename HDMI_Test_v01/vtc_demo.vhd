-- CopyLeft :-) Cristinel Ababei (cababei@buffalo.edu), October 2012
-- this is the VHDL porting of the file vtc_demo.v that is
-- part of the popular xapp495 of Xilinx; this file represents
-- the top level entity of a design that drives an HDMI/DVI
-- monitor with a hardware generated pattern;
-- note that only this file is converted to VHDL; all other
-- files necessary for this project are kept as Verilog files;	
-- (actually there are two small changes in synchro.v and
-- serdes_n_to_1.v; read the lab document for details)
-- therefore, this serves also nicely the purpose of illustrating
-- the mix of Verilog and VHDL files within the same ISE WebPack project.
-- disclaimer: this may contain errors and may not be always the
-- best VHDL code; it works though; I tested it on two different
-- monitors (HDMI and DVI); if you find errors or have improvements
-- (such as re-writing the code to use fewer libraries) please send me
-- an e-mail.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
-- library declaration if instantiating any Xilinx primitives
library UNISIM;
use UNISIM.VComponents.all;


entity vtc_demo_top_level is
    Port ( RSTBTN : in  STD_LOGIC;
           SYS_CLK : in  STD_LOGIC;
           SW : in  STD_LOGIC_VECTOR (3 downto 0);
           TMDS : out  STD_LOGIC_VECTOR (3 downto 0);
           TMDSB : out  STD_LOGIC_VECTOR (3 downto 0);
           LED : out  STD_LOGIC_VECTOR (3 downto 0);
           DEBUG : out  STD_LOGIC_VECTOR (1 downto 0));
end vtc_demo_top_level;


architecture Behavioral of vtc_demo_top_level is

-- signals - Create global clock and synchronous system reset.
signal sysclk : std_logic;
signal clk50m, clk50m_bufg : std_logic;
signal pclk_lckd : std_logic;
signal pwrup : std_logic;

-- signal - Switching screen formats 
signal busy : std_logic;
signal sws_sync : std_logic_vector(3 downto 0); -- synchronous output
signal sws_sync_q : std_logic_vector(3 downto 0); -- register
signal sw0_rdy, sw1_rdy, sw2_rdy, sw3_rdy : std_logic; -- debouncing
signal switch : std_logic; -- register
signal gopclk : std_logic;
constant SW_VGA      : std_logic_vector(3 downto 0) := "0000";
constant SW_SVGA     : std_logic_vector(3 downto 0) := "0001";
constant SW_XGA      : std_logic_vector(3 downto 0) := "0011";
constant SW_HDTV720P : std_logic_vector(3 downto 0) := "0010";
constant SW_SXGA     : std_logic_vector(3 downto 0) := "1000";
signal pclk_M, pclk_D : std_logic_vector(7 downto 0);

-- signals - DCM_CLKGEN SPI controller 
signal progdone, progen, progdata : std_logic;

-- signals - DCM_CLKGEN to generate a pixel clock with a variable frequency 
signal clkfx, pclk : std_logic;

-- signals - Pixel Rate clock buffer 
signal pllclk0, pllclk1, pllclk2 : std_logic;
signal pclkx2, pclkx10, pll_lckd : std_logic;
signal clkfbout : std_logic;
signal serdesstrobe : std_logic;
signal bufpll_lock : std_logic; 

-- Video Timing Parameters
-- 1280x1024@60HZ
constant HPIXELS_SXGA : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(1280, 11)); --Horizontal Live Pixels
constant VLINES_SXGA : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(1024, 11));  --Vertical Live ines
constant HSYNCPW_SXGA : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(112, 11));  --HSYNC Pulse Width
constant VSYNCPW_SXGA : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(3, 11));    --VSYNC Pulse Width
constant HFNPRCH_SXGA : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(48, 11));   --Horizontal Front Portch
constant VFNPRCH_SXGA : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(1, 11));    --Vertical Front Portch
constant HBKPRCH_SXGA : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(248, 11));  --Horizontal Front Portch
constant VBKPRCH_SXGA : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(38, 11));   --Vertical Front Portch

--1280x720@60HZ
constant HPIXELS_HDTV720P : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(1280, 11)); --Horizontal Live Pixels
constant VLINES_HDTV720P  : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(720, 11));  --Vertical Live ines
constant HSYNCPW_HDTV720P : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(80, 11));  --HSYNC Pulse Width
constant VSYNCPW_HDTV720P : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(5, 11));    --VSYNC Pulse Width
constant HFNPRCH_HDTV720P : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(72, 11));   --Horizontal Front Portch
constant VFNPRCH_HDTV720P : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(3, 11));    --Vertical Front Portch
constant HBKPRCH_HDTV720P : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(216, 11));  --Horizontal Front Portch
constant VBKPRCH_HDTV720P : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(22, 11));   --Vertical Front Portch

--1024x768@60HZ
constant HPIXELS_XGA : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(1024, 11)); --Horizontal Live Pixels
constant VLINES_XGA  : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(768, 11));  --Vertical Live ines
constant HSYNCPW_XGA : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(136, 11));  --HSYNC Pulse Width
constant VSYNCPW_XGA : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(6, 11));    --VSYNC Pulse Width
constant HFNPRCH_XGA : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(24, 11));   --Horizontal Front Portch
constant VFNPRCH_XGA : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(3, 11));    --Vertical Front Portch
constant HBKPRCH_XGA : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(160, 11));  --Horizontal Front Portch
constant VBKPRCH_XGA : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(29, 11));   --Vertical Front Portch

--800x600@60HZ
constant HPIXELS_SVGA : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(800, 11)); --Horizontal Live Pixels
constant VLINES_SVGA  : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(600, 11)); --Vertical Live ines
constant HSYNCPW_SVGA : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(128, 11)); --HSYNC Pulse Width
constant VSYNCPW_SVGA : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(4, 11));   --VSYNC Pulse Width
constant HFNPRCH_SVGA : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(40, 11));  --Horizontal Front Portch
constant VFNPRCH_SVGA : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(1, 11));   --Vertical Front Portch
constant HBKPRCH_SVGA : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(88, 11));  --Horizontal Front Portch
constant VBKPRCH_SVGA : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(23, 11));  --Vertical Front Portch

--640x480@60HZ
constant HPIXELS_VGA : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(640, 11)); --Horizontal Live Pixels
constant VLINES_VGA  : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(480, 11)); --Vertical Live ines
constant HSYNCPW_VGA : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(96, 11));  --HSYNC Pulse Width
constant VSYNCPW_VGA : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(2, 11));   --VSYNC Pulse Width
constant HFNPRCH_VGA : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(16, 11));  --Horizontal Front Portch
constant VFNPRCH_VGA : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(11, 11));  --Vertical Front Portch
constant HBKPRCH_VGA : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(48, 11));  --Horizontal Front Portch
constant VBKPRCH_VGA : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(31, 11));  --Vertical Front Portch

signal tc_hsblnk: std_logic_vector(10 downto 0);
signal tc_hssync: std_logic_vector(10 downto 0);
signal tc_hesync: std_logic_vector(10 downto 0);
signal tc_heblnk: std_logic_vector(10 downto 0);
signal tc_vsblnk: std_logic_vector(10 downto 0);
signal tc_vssync: std_logic_vector(10 downto 0);
signal tc_vesync: std_logic_vector(10 downto 0);
signal tc_veblnk: std_logic_vector(10 downto 0);
signal sws_clk: std_logic_vector(3 downto 0); --clk synchronous output
signal sws_clk_sync: std_logic_vector(3 downto 0); --clk synchronous output
signal hvsync_polarity: std_logic; -- 1-Negative, 0-Positive

signal VGA_HSYNC_INT, VGA_VSYNC_INT: std_logic;
signal bgnd_hcount: std_logic_vector(10 downto 0);
signal bgnd_hsync: std_logic;
signal bgnd_hblnk: std_logic;
signal bgnd_vcount: std_logic_vector(10 downto 0);
signal bgnd_vsync: std_logic;
signal bgnd_vblnk: std_logic;

-- signals - V/H SYNC and DE generator 
signal active_q: std_logic;
signal vsync, hsync: std_logic;
signal VGA_HSYNC, VGA_VSYNC: std_logic;
signal de: std_logic;
signal active: std_logic; 
  
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

-- this is a component described in Verilog and added as a source
-- file to this project; the Verilog description is in syncro.v;
-- to be able to instantiate it in a VHDL file one follow the steps:
-- The simplest way is using the ISE NAvigator GUI. Add the verilog source 
-- file to the project. Then highlight the file in the Hierarchy window
-- (clik once) and in the design process window you should see "View HDL
-- instantiation template" (expand + if necessary).
	COMPONENT synchro
	PORT(
		async : IN std_logic;
		clk : IN std_logic;          
		sync : OUT std_logic
		);
	END COMPONENT;
	COMPONENT synchroType2
	PORT(
		async : IN std_logic;
		clk : IN std_logic;          
		sync : OUT std_logic
		);
	END COMPONENT;
-- described in Verilog in debnce.v;
	COMPONENT debnce
	PORT(
		sync : IN std_logic;
		clk : IN std_logic;          
		debnced : OUT std_logic
		);
	END COMPONENT;
-- described in Verilog in dcmspi.v;
	COMPONENT dcmspi
	PORT(
		RST : IN std_logic;
		PROGCLK : IN std_logic;
		PROGDONE : IN std_logic;
		DFSLCKD : IN std_logic;
		M : IN std_logic_vector(7 downto 0);
		D : IN std_logic_vector(7 downto 0);
		GO : IN std_logic;          
		BUSY : OUT std_logic;
		PROGEN : OUT std_logic;
		PROGDATA : OUT std_logic
		);
	END COMPONENT;	
-- described in Verilog in timing.v;
	COMPONENT timing
	PORT(
		tc_hsblnk : IN std_logic_vector(10 downto 0);
		tc_hssync : IN std_logic_vector(10 downto 0);
		tc_hesync : IN std_logic_vector(10 downto 0);
		tc_heblnk : IN std_logic_vector(10 downto 0);
		tc_vsblnk : IN std_logic_vector(10 downto 0);
		tc_vssync : IN std_logic_vector(10 downto 0);
		tc_vesync : IN std_logic_vector(10 downto 0);
		tc_veblnk : IN std_logic_vector(10 downto 0);
		restart : IN std_logic;
		clk : IN std_logic;          
		hcount : OUT std_logic_vector(10 downto 0);
		hsync : OUT std_logic;
		hblnk : OUT std_logic;
		vcount : OUT std_logic_vector(10 downto 0);
		vsync : OUT std_logic;
		vblnk : OUT std_logic
		);
	END COMPONENT;	
-- described in Verilog in hdclrbar.v;
	COMPONENT hdcolorbar
	PORT(
		i_clk_74M : IN std_logic;
		i_rst : IN std_logic;
		baronly : IN std_logic;
		i_format : IN std_logic_vector(1 downto 0);
		i_vcnt : IN std_logic_vector(11 downto 0);
		i_hcnt : IN std_logic_vector(11 downto 0);          
		o_r : OUT std_logic_vector(7 downto 0);
		o_g : OUT std_logic_vector(7 downto 0);
		o_b : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
-- described in Verilog in dvi_encoder.v;
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
-- described in Verilog in serdes_n_to_1.v;
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
	
begin

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
clk50m_bufgbufg : BUFG port map (I=>clk50m, O=>clk50m_bufg);

--16 bit Shift Register LUT with Clock Enable
--more info: read 4_SRL16E_wp271.pdf from the archive of this lab
pwrup_0 : SRL16E 
	generic map (
		INIT => X"1111")
	port map(
		Q=>pwrup,
		A0=>'1',
		A1=>'1',
		A2=>'1',
		A3=>'1',
		CE=>pclk_lckd,
		CLK=>clk50m_bufg,
		D=>'0');

--******************************************************************
-- Switching screen formats               
--******************************************************************

-- four instances of syncro
synchro_sws_3: synchro port map (async=>SW(3), sync=>sws_sync(3), clk=>clk50m_bufg);
synchro_sws_2: synchro port map (async=>SW(2), sync=>sws_sync(2), clk=>clk50m_bufg);
synchro_sws_1: synchro port map (async=>SW(1), sync=>sws_sync(1), clk=>clk50m_bufg);
synchro_sws_0: synchro port map (async=>SW(0), sync=>sws_sync(0), clk=>clk50m_bufg);

-- advance state machine
process (clk50m_bufg)
begin
	if rising_edge (clk50m_bufg) then
		sws_sync_q <= sws_sync;
	end if;
end process;

-- 4 instances of debouncing circuits
debsw0 : debnce port map (
   sync=>sws_sync_q(0),
   debnced=>sw0_rdy,
   clk=>clk50m_bufg);
	
debsw1 : debnce port map (
   sync=>sws_sync_q(1),
   debnced=>sw1_rdy,
   clk=>clk50m_bufg);
	
debsw2 : debnce port map (
   sync=>sws_sync_q(2),
   debnced=>sw2_rdy,
   clk=>clk50m_bufg);
	
debsw3 : debnce port map (
   sync=>sws_sync_q(3),
   debnced=>sw3_rdy,
   clk=>clk50m_bufg);

process (clk50m_bufg)
begin
	if rising_edge (clk50m_bufg) then
		switch <= (pwrup or sw0_rdy) or (sw1_rdy or sw2_rdy) or sw3_rdy;
	end if;
end process;
  
SRL16E_0 : SRL16E port map (
	Q=>gopclk,
	A0=>'1',
	A1=>'1',
	A2=>'1',
	A3=>'1',
	CE=>'1',
	CLK=>clk50m_bufg,
	D=>switch);

process (clk50m_bufg)
begin
	if (switch = '1') then
		case sws_sync_q is
			when SW_VGA => -- 25 MHz pixel clock
				pclk_M <= std_logic_vector(to_unsigned(1, 8)); -- 8'd2 - 8'd1;
				pclk_D <= std_logic_vector(to_unsigned(3, 8)); -- 8'd4 - 8'd1;
			when SW_SVGA => -- 40 MHz pixel clock
				pclk_M <= std_logic_vector(to_unsigned(3, 8)); -- 8'd4 - 8'd1;
				pclk_D <= std_logic_vector(to_unsigned(4, 8)); -- 8'd5 - 8'd1;
			when SW_XGA => -- 65 MHz pixel clock
				pclk_M <= std_logic_vector(to_unsigned(12, 8)); -- 8'd13 - 8'd1;
				pclk_D <= std_logic_vector(to_unsigned(9, 8)); -- 8'd10 - 8'd1;
			when SW_SXGA => -- 108 MHz pixel clock
				pclk_M <= std_logic_vector(to_unsigned(53, 8)); -- 8'd54 - 8'd1;
				pclk_D <= std_logic_vector(to_unsigned(24, 8)); -- 8'd25 - 8'd1;
			when others => -- 74.25 MHz pixel clock
				pclk_M <= std_logic_vector(to_unsigned(36, 8)); -- 8'd37 - 8'd1;
				pclk_D <= std_logic_vector(to_unsigned(24, 8)); -- 8'd25 - 8'd1;
		end case;
	end if;
end process;

--******************************************************************
-- DCM_CLKGEN SPI controller              
--******************************************************************
  
dcmspi_0 : dcmspi port map (
	RST=>switch,          --Synchronous Reset
	PROGCLK=>clk50m_bufg, --SPI clock
	PROGDONE=>progdone,   --DCM is ready to take next command
	DFSLCKD=>pclk_lckd,
	M=>pclk_M,            --DCM M value
	D=>pclk_D,            --DCM D value
	GO=>gopclk,           --Go programme the M and D value into DCM(1 cycle pulse)
	BUSY=>busy,
	PROGEN=>progen,       --SlaveSelect,
	PROGDATA=>progdata    --CommandData
);

--******************************************************************
-- DCM_CLKGEN to generate a pixel clock with a variable frequency     
--******************************************************************

PCLK_GEN_INST : DCM_CLKGEN 
	generic map (
		CLKFX_DIVIDE=>21,
		CLKFX_MULTIPLY=>31,
		CLKIN_PERIOD=>20.000)
   port map (
		CLKFX=>clkfx,
		--CLKFX180=>,
		--CLKFXDV=>,
		LOCKED=>pclk_lckd,
		PROGDONE=>progdone,
		--STATUS=>,
		CLKIN=>clk50m,
		FREEZEDCM=>'0',
		PROGCLK=>clk50m_bufg,
		PROGDATA=>progdata,
		PROGEN=>progen,
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
		CLKIN_PERIOD=>13.0,
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
		--CLKOUT3=>,
		--CLKOUT4=>,
		--CLKOUT5=>,
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

clk_sws_3 : synchro port map (async=>SW(3), sync=>sws_clk(3), clk=>pclk);
clk_sws_2 : synchro port map (async=>SW(2), sync=>sws_clk(2), clk=>pclk);
clk_sws_1 : synchro port map (async=>SW(1), sync=>sws_clk(1), clk=>pclk);
clk_sws_0 : synchro port map (async=>SW(0), sync=>sws_clk(0), clk=>pclk);

-- advance state machine
process (pclk)
begin
	if rising_edge (pclk) then
		sws_clk_sync <= sws_clk;
	end if;
end process;
  
process
begin
	case sws_clk_sync is
		when SW_VGA =>
			hvsync_polarity <= '1';
         tc_hsblnk <= HPIXELS_VGA - 1;
         tc_hssync <= HPIXELS_VGA - 1 + HFNPRCH_VGA;
         tc_hesync <= HPIXELS_VGA - 1 + HFNPRCH_VGA + HSYNCPW_VGA;
         tc_heblnk <= HPIXELS_VGA - 1 + HFNPRCH_VGA + HSYNCPW_VGA + HBKPRCH_VGA;
         tc_vsblnk <=  VLINES_VGA - 1;
         tc_vssync <=  VLINES_VGA - 1 + VFNPRCH_VGA;
         tc_vesync <=  VLINES_VGA - 1 + VFNPRCH_VGA + VSYNCPW_VGA;
         tc_veblnk <=  VLINES_VGA - 1 + VFNPRCH_VGA + VSYNCPW_VGA + VBKPRCH_VGA;
		when SW_SVGA =>
			hvsync_polarity <= '0';
         tc_hsblnk <= HPIXELS_SVGA - 1;
         tc_hssync <= HPIXELS_SVGA - 1 + HFNPRCH_SVGA;
         tc_hesync <= HPIXELS_SVGA - 1 + HFNPRCH_SVGA + HSYNCPW_SVGA;
         tc_heblnk <= HPIXELS_SVGA - 1 + HFNPRCH_SVGA + HSYNCPW_SVGA + HBKPRCH_SVGA;
         tc_vsblnk <=  VLINES_SVGA - 1;
         tc_vssync <=  VLINES_SVGA - 1 + VFNPRCH_SVGA;
         tc_vesync <=  VLINES_SVGA - 1 + VFNPRCH_SVGA + VSYNCPW_SVGA;
         tc_veblnk <=  VLINES_SVGA - 1 + VFNPRCH_SVGA + VSYNCPW_SVGA + VBKPRCH_SVGA;			
		when SW_XGA =>
			hvsync_polarity <= '1';
         tc_hsblnk <= HPIXELS_XGA - 1;
         tc_hssync <= HPIXELS_XGA - 1 + HFNPRCH_XGA;
         tc_hesync <= HPIXELS_XGA - 1 + HFNPRCH_XGA + HSYNCPW_XGA;
         tc_heblnk <= HPIXELS_XGA - 1 + HFNPRCH_XGA + HSYNCPW_XGA + HBKPRCH_XGA;
         tc_vsblnk <=  VLINES_XGA - 1;
         tc_vssync <=  VLINES_XGA - 1 + VFNPRCH_XGA;
         tc_vesync <=  VLINES_XGA - 1 + VFNPRCH_XGA + VSYNCPW_XGA;
         tc_veblnk <=  VLINES_XGA - 1 + VFNPRCH_XGA + VSYNCPW_XGA + VBKPRCH_XGA;		
		when SW_SXGA =>
			hvsync_polarity <= '0'; --positive polarity
         tc_hsblnk <= HPIXELS_SXGA - 1;
         tc_hssync <= HPIXELS_SXGA - 1 + HFNPRCH_SXGA;
         tc_hesync <= HPIXELS_SXGA - 1 + HFNPRCH_SXGA + HSYNCPW_SXGA;
         tc_heblnk <= HPIXELS_SXGA - 1 + HFNPRCH_SXGA + HSYNCPW_SXGA + HBKPRCH_SXGA;
         tc_vsblnk <=  VLINES_SXGA - 1;
         tc_vssync <=  VLINES_SXGA - 1 + VFNPRCH_SXGA;
         tc_vesync <=  VLINES_SXGA - 1 + VFNPRCH_SXGA + VSYNCPW_SXGA;
         tc_veblnk <=  VLINES_SXGA - 1 + VFNPRCH_SXGA + VSYNCPW_SXGA + VBKPRCH_SXGA;
		when others => --SW_HDTV720P
			hvsync_polarity <= '0';
         tc_hsblnk <= HPIXELS_HDTV720P - 1;
         tc_hssync <= HPIXELS_HDTV720P - 1 + HFNPRCH_HDTV720P;
         tc_hesync <= HPIXELS_HDTV720P - 1 + HFNPRCH_HDTV720P + HSYNCPW_HDTV720P;
         tc_heblnk <= HPIXELS_HDTV720P - 1 + HFNPRCH_HDTV720P + HSYNCPW_HDTV720P + HBKPRCH_HDTV720P;
         tc_vsblnk <=  VLINES_HDTV720P - 1;
         tc_vssync <=  VLINES_HDTV720P - 1 + VFNPRCH_HDTV720P;
         tc_vesync <=  VLINES_HDTV720P - 1 + VFNPRCH_HDTV720P + VSYNCPW_HDTV720P;
         tc_veblnk <=  VLINES_HDTV720P - 1 + VFNPRCH_HDTV720P + VSYNCPW_HDTV720P + VBKPRCH_HDTV720P;
	end case;
end process;

timing_inst : timing port map (
	tc_hsblnk=>tc_hsblnk, --input
	tc_hssync=>tc_hssync, --input
	tc_hesync=>tc_hesync, --input
	tc_heblnk=>tc_heblnk, --input
	hcount=>bgnd_hcount, --output
	hsync=>VGA_HSYNC_INT, --output
	hblnk=>bgnd_hblnk, --output
	tc_vsblnk=>tc_vsblnk, --input
	tc_vssync=>tc_vssync, --input
	tc_vesync=>tc_vesync, --input
	tc_veblnk=>tc_veblnk, --input
	vcount=>bgnd_vcount, --output
	vsync=>VGA_VSYNC_INT, --output
	vblnk=>bgnd_vblnk, --output
	restart=>reset,
	clk=>pclk);

--******************************************************************
-- V/H SYNC and DE generator   
--******************************************************************

active <= not(bgnd_hblnk) and not(bgnd_vblnk);

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

clrbar : hdcolorbar port map (
	i_clk_74M=>pclk,
	i_rst=>reset,
	i_hcnt=>'0' & bgnd_hcount, -- Note: Verilog code gave only 11 bits directly to
	i_vcnt=>'0' & bgnd_vcount, -- i_hcnt, which requires 12 bits however;
	baronly=>'0',
	i_format=>"00",
	o_r=>red_data,
	o_g=>green_data,
	o_b=>blue_data);

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
