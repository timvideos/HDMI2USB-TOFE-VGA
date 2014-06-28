library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;


entity HDMI_Test_v06 is
	generic (
		DCM_CLK_IN         : string    := "DATACK";
		DCM_CLKFX_DIVIDE	 : integer   := 2;--10;
		DCM_CLKFX_MULTIPLY : integer   := 2;--13;
		DCM_CLKIN_PERIOD   : real      := 15.384;--20.000;
		SAMPLING_MODE      : std_logic := '0'
);
   port ( 
      RSTBTN 		: in  STD_LOGIC;
      SYS_CLK 		: in  STD_LOGIC;
      
		-- HDMI Nets
      TMDS 			: out  STD_LOGIC_VECTOR (3 downto 0);
      TMDSB 		: out  STD_LOGIC_VECTOR (3 downto 0);
      
		-- Debugging
		LED 			: out  STD_LOGIC_VECTOR (3 downto 0);
      DEBUG 		: out  STD_LOGIC_VECTOR (1 downto 0);
		SW    		: in std_logic_vector(3 downto 0);  
      uart_tx 		: out std_logic;
		
		-- VGA Capture Input Nets
		R 				: in  STD_LOGIC_VECTOR (9 downto 0);
      G 				: in  STD_LOGIC_VECTOR (9 downto 0);
      B 				: in  STD_LOGIC_VECTOR (9 downto 0);
      DATACK 		: in  STD_LOGIC;
      HSOUT 		: in  STD_LOGIC;
      VSOUT 		: in  STD_LOGIC
);
end HDMI_Test_v06;


architecture Behavioral of HDMI_Test_v06 is

-- signals - Create global clock and synchronous system reset.
signal sysclk 							: std_logic;
signal clk50m, clk50m_bufg 		: std_logic;
signal pclk_lckd 						: std_logic;

-- signals - DCM_CLKGEN to generate a pixel clock with a variable frequency 
signal clkfx, pclk 					: std_logic;
signal dcm_clkin : std_logic;

-- signals - Pixel Rate clock buffer 
signal pllclk0, pllclk1, pllclk2 : std_logic;
signal pclkx2, pclkx10, pll_lckd : std_logic;
signal clkfbout 						: std_logic;
signal serdesstrobe 					: std_logic;
signal bufpll_lock 					: std_logic; 

-- signals - V/H SYNC and DE generator
signal hvsync_polarity				: std_logic; -- 1-Negative, 0-Positive
signal VGA_HSYNC_INT, VGA_VSYNC_INT: std_logic;
signal active_q						: std_logic;
signal vsync, hsync					: std_logic;
signal VGA_HSYNC, VGA_VSYNC		: std_logic;
signal de								: std_logic;
signal active							: std_logic; 
  
signal dataclk, dataclk_oversample : std_logic;  
signal red_data, green_data, blue_data : std_logic_vector(7 downto 0);

-- signals - DVI Encoder  
signal tmds_data0, tmds_data1, tmds_data2: std_logic_vector(4 downto 0);
signal tmdsint: std_logic_vector(2 downto 0);
signal serdes_rst: std_logic; 
signal tmdsclkint: std_logic_vector(4 downto 0) := "00000";
signal toggle: std_logic := '0';
signal tmdsclk: std_logic;
signal clk4xfbout : std_logic ; 
signal clk4x, pllclk4x : std_logic; 
signal reset : std_logic;


begin

DCM_sysclk_config: if (DCM_CLK_IN = "SYSCLK") generate
	dcm_clkin      <= clk50m;
end generate;
DCM_datack_config: if (DCM_CLK_IN = "DATACK") generate
	dcm_clkin      <= dataclk;
end generate;

hvsync_polarity <= '1';

datack_bufg : BUFG port map( I=>DATACK, O=>dataclk);
sysclk_buf : IBUF port map(I=>SYS_CLK, O=>sysclk);
clk50m_bufgbufg : BUFG port map (I=>clk50m, O=>clk50m_bufg);


sysclk_div : BUFIO2
	generic map (
		DIVIDE_BYPASS=>FALSE, 
		DIVIDE=>2)
	port map (
		DIVCLK=>clk50m,
		I=>sysclk);


PCLK_GEN_INST : DCM_CLKGEN
	generic map (
		CLKFX_DIVIDE   => DCM_CLKFX_DIVIDE,
		CLKFX_MULTIPLY => DCM_CLKFX_MULTIPLY,
		CLKIN_PERIOD   => DCM_CLKIN_PERIOD)
   port map (
		CLKFX     => clkfx,
		LOCKED    => pclk_lckd,
		CLKIN     => dcm_clkin,
		FREEZEDCM => '0',
		RST       => '0');
	

pclkbufg : BUFG port map (I=>pllclk1, O=>pclk);

-- 2x pclk is going to be used to drive OSERDES2 on the GCLK side
pclkx2bufg : BUFG port map (I=>pllclk2, O=>pclkx2);

--clk4xbufg : BUFG port map(I => pllclk4x, O => clk4x);


PLL_4x : PLL_BASE
	generic map(
		CLKIN_PERIOD   => 15.384,
		CLKFBOUT_MULT  => 8, 			--set VCO to 10x of CLKIN
		CLKOUT0_DIVIDE => 2,
		COMPENSATION   => "INTERNAL")  
	port map (
		CLKFBOUT => clk4xfbout,
		CLKOUT0  => pllclk4x, 			--dataclk_oversample,
		CLKFBIN  => clk4xfbout,
		CLKIN    => pclk,
		RST      => not pclk_lckd);	


-- 10x pclk is used to drive IOCLK network so a bit rate reference
-- can be used by OSERDES2
PLL_OSERDES : PLL_BASE
	generic map (
		CLKIN_PERIOD   =>15.384,
		CLKFBOUT_MULT  =>10, 	--set VCO to 10x of CLKIN
		CLKOUT0_DIVIDE =>1,
		CLKOUT1_DIVIDE =>10,
		CLKOUT2_DIVIDE =>5,
		COMPENSATION   =>"INTERNAL")  
	port map (
		CLKFBOUT =>clkfbout,
		CLKOUT0  =>pllclk0,
		CLKOUT1  =>pllclk1,
		CLKOUT2  =>pllclk2,
		LOCKED   =>pll_lckd,
		CLKFBIN  =>clkfbout,
		CLKIN    =>clkfx,
		RST      =>not pclk_lckd);


ioclk_buf: BUFPLL 
	generic map (DIVIDE=>5) 
	port map (PLLIN=>pllclk0, GCLK=>pclkx2, LOCKED=>pll_lckd,
      IOCLK=>pclkx10, SERDESSTROBE=>serdesstrobe, LOCK=>bufpll_lock);


synchro_reset : entity work.synchroType2 
   port map (async => not pll_lckd, sync => reset, clk => pclk);
  
  
Inst_VGA_Capture: entity work.VGA_Capture 
	PORT MAP(
		Reset       => '0',
		DATACK      => dataclk,
		HSOUT       => HSOUT,
		VSOUT       => VSOUT,
		R_in        => R,
		G_in 			=> G,
		B_in 			=> B,
		pclk_in 		=> pclk,
		pclkx_in    => pllclk4x,
		clk50m 		=> clk50m_bufg,
		uart_tx     => uart_tx,
		debug_sw    => SW,
		de          => active,
		HSYNC       => VGA_HSYNC_INT,
		VSYNC       => VGA_VSYNC_INT,
		Red_out     => red_data,
		Green_out   => green_data,
		Blue_out    => blue_data);

--process (pclk)
--begin
--	if rising_edge (pclk) then
		hsync <= VGA_HSYNC_INT xor hvsync_polarity;
		vsync <= VGA_VSYNC_INT xor hvsync_polarity;
		VGA_HSYNC <= hsync;
		VGA_VSYNC <= vsync;
		active_q <= active;
		de <= active_q;
--	end if;
--end process;

enc0 : entity work.dvi_encoder  port map (
	clkin      => pclk,
	clkx2in    => pclkx2,
	rstin      => reset,
	blue_din   => blue_data,
	green_din  => green_data,
	red_din    => red_data,
	hsync      => VGA_HSYNC,
	vsync      => VGA_VSYNC,
	de         => de,
	tmds_data0 => tmds_data0,
	tmds_data1 => tmds_data1,
	tmds_data2 => tmds_data2);

serdes_rst <= RSTBTN or not(bufpll_lock);

oserdes0 : entity work.serdes_n_to_1 
	port map(
		ioclk        => pclkx10,
		serdesstrobe => serdesstrobe,
		reset        => serdes_rst,
		gclk         => pclkx2,
		datain       => tmds_data0,
		iob_data_out => tmdsint(0));
		
oserdes1 : entity work.serdes_n_to_1 
	port map(
		ioclk        => pclkx10,
		serdesstrobe => serdesstrobe,
		reset        => serdes_rst,
		gclk         => pclkx2,
		datain       => tmds_data1,
		iob_data_out => tmdsint(1));
		
oserdes2 : entity work.serdes_n_to_1 
	port map(
		ioclk        => pclkx10,
		serdesstrobe => serdesstrobe,
		reset        => serdes_rst,
		gclk         => pclkx2,
		datain       => tmds_data2,
		iob_data_out => tmdsint(2));		

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

clkout : entity work.serdes_n_to_1 port map (
	iob_data_out => tmdsclk,
	ioclk        => pclkx10,
	serdesstrobe => serdesstrobe,
	gclk         => pclkx2,
	reset        => serdes_rst,
	datain       => tmdsclkint);

TMDS3 : OBUFDS port map (I=>tmdsclk, O=>TMDS(3), OB=>TMDSB(3)); -- clock

-- Debug Ports 
DEBUG(0) <= VGA_HSYNC;
DEBUG(1) <= VGA_VSYNC;

-- LEDs
LED <= bufpll_lock & RSTBTN & VGA_HSYNC & VGA_VSYNC;

end Behavioral;
