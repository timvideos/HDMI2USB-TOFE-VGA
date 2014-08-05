library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;


entity HDMI_Test_v06 is
	generic (
		DCM_CLK_IN         : string    := "DATACK";
		DCM_CLKFX_DIVIDE	 : integer   := 2;--10;--2;--10;
		DCM_CLKFX_MULTIPLY : integer   := 2;--13;--2;--13;
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
		LED 			: out  STD_LOGIC_VECTOR (7 downto 0);
      DEBUG 		: out  STD_LOGIC_VECTOR (1 downto 0);
		SW    		: in std_logic_vector(3 downto 0);  
      uart_tx 		: out std_logic;
		
		-- I2C 
		SDA         : inout std_logic;
		SCL		   : inout std_logic;
		--SCL       : out std_logic;
		
		-- VGA Capture Input Nets
		R 				: in  STD_LOGIC_VECTOR (9 downto 0);
      G 				: in  STD_LOGIC_VECTOR (9 downto 0);
      B 				: in  STD_LOGIC_VECTOR (9 downto 0);
      DATACK 		: in  STD_LOGIC;
      HSOUT 		: in  STD_LOGIC;
		SOGOUT      : in STD_LOGIC;
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
signal clkfbout,clkfbin 						: std_logic;
signal serdesstrobe 					: std_logic;
signal bufpll_lock 					: std_logic; 

-- signals - V/H SYNC and DE generator
signal hvsync_polarity				: std_logic; -- 1-Negative, 0-Positive
signal VGA_HSYNC_INT, VGA_VSYNC_INT: std_logic;
signal active_q						: std_logic;
signal vsync, hsync					: std_logic;
signal VGA_HSYNC, VGA_VSYNC		: std_logic;
signal de								: std_logic;
signal active, uart_tx_int							: std_logic; 
  
signal dataclk, dataclk_oversample : std_logic;  
signal red_data, green_data, blue_data : std_logic_vector(7 downto 0); -- 9 downto 0);

-- signals - DVI Encoder  
signal clk4xfbout : std_logic ; 
signal clk4x, pllclk4x : std_logic; 
signal reset : std_logic;
signal i2c_clk, i2c_clk_buf, i2c_reset : std_logic;
-- signals i2c

--signal datack_pll
signal done : std_logic;
signal pll_dataclk_out2, out3, out4, out5, out6 : std_logic;
signal DET_VS_POL, DET_HS_POL : std_logic;
begin

DCM_sysclk_config: if (DCM_CLK_IN = "SYSCLK") generate
	dcm_clkin      <= clk50m;
end generate;
DCM_datack_config: if (DCM_CLK_IN = "DATACK") generate
	dcm_clkin      <= dataclk;
end generate;

hvsync_polarity <= '1';
--uart_tx <= uart_tx_int;
datack_bufg : BUFG port map( I=>DATACK, O=>dataclk);
sysclk_buf : IBUF port map(I=>SYS_CLK, O=>sysclk);
clk50m_bufgbufg : BUFG port map (I=>clk50m, O=>clk50m_bufg);
i2c_clk_bufg : BUFG port map (I=>sysclk, O=>i2c_clk_buf);



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
		--DFS_OSCILLATOR_MODE => "PHASE_FREQ_LOCK",
		CLKIN_PERIOD   => DCM_CLKIN_PERIOD)--20.000)--DCM_CLKIN_PERIOD)
   port map (
		CLKFX     => clkfx,
		LOCKED    => pclk_lckd,
		CLKIN     => dcm_clkin,
		RST       => '0');



	

		
pclkbufg : BUFG port map (I=>pllclk1, O=>pclk);

-- 2x pclk is going to be used to drive OSERDES2 on the GCLK side
pclkx2bufg : BUFG port map (I=>pllclk2, O=>pclkx2);

--clk4xbufg : BUFG port map(I => pllclk4x, O => clk4x);

--DataCk_pll : PLL_BASE
--	generic map(
--		

PLL_4x : PLL_BASE
	generic map(
		CLKIN_PERIOD   => 15.384,
		CLKFBOUT_MULT  => 12, 			--set VCO to 10x of CLKIN
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
		CLKIN_PERIOD   => 10.000, --15.384,
		CLKFBOUT_MULT  => 10, 	--set VCO to 10x of CLKIN
		CLKOUT0_DIVIDE => 1,
		CLKOUT1_DIVIDE => 10,
		CLKOUT2_DIVIDE => 5,
		COMPENSATION   => "DCM2PLL" )--"SYSTEM_SYNCHRONOUS")--"SOURCE_SYNCHRONOUS") --"DCM2PLL" )--"INTERNAL")  
	port map (
		CLKFBOUT => clkfbout,
		CLKOUT0  => pllclk0,
		CLKOUT1  => pllclk1,
		CLKOUT2  => pllclk2,
		LOCKED   => pll_lckd,
		CLKFBIN  => clkfbin,
		CLKIN    => clkfx, --DATACK, --dataclk,--clkfx,
		RST      => RSTBTN );--'pclk_lckd);

clkfb : BUFG port map( I=> clkfbout, O=> clkfbin);

ioclk_buf: BUFPLL 
	generic map (DIVIDE=>5) 
	port map (PLLIN=>pllclk0, GCLK=>pclkx2, LOCKED=>pll_lckd,
      IOCLK=>pclkx10, SERDESSTROBE=>serdesstrobe, LOCK=>bufpll_lock);


--synchro_reset : entity work.synchroType2 
--   port map (async => not pll_lckd, sync => reset, clk => pclk);
reset <= RSTBTN;
  
Inst_VGA_Capture: entity work.VGA_Capture 
	PORT MAP(
		Reset       => '0',
		DATACK      => dataclk,
		HSOUT       => HSOUT,
		VSOUT       => VSOUT,
		SOGOUT      => SOGOUT,
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

--Inst_DVI_IN: entity work.DVI_IN PORT MAP(
--		DVI_CLK       => DATACK,
--		DVIIN_DE      => '0',
--		DVIIN_HS      => HSOUT,
--		DVIIN_VS      => VSOUT,
--		DVIIN_R       => B,
--		DVIIN_G       => G,
--		DVIIN_B       => R,
--		USE_DE        => '0',
--		CROP_EN       => '1',
--		CROP_START_X  => X"00a1",  -- 161
--		CROP_WIDTH_X  => X"0400", -- 0x400 = 1024
--		CROP_START_Y  => X"001d",  -- 29
--		CROP_HEIGHT_Y => X"0300", -- 0x300 = 768
--		DE            => active,
--		HS            => VGA_HSYNC_INT,
--		VS            => VGA_VSYNC_INT,
--		R             => red_data,
--		G             => green_data,
--		B             => blue_data,
--		DET_VS_POL    => DET_VS_POL,
--		DET_HS_POL    => DET_HS_POL
--	);

dvi_tx: entity work.dvi_encoder_top PORT MAP(
		pclk         => pclk,
		pclkx2       => pclkx2,
		pclkx10      => pclkx10,
		serdesstrobe => serdesstrobe,
		rstin        => reset,
		blue_din     => blue_data,--(9 downto 2),
		green_din    => green_data,--(9 downto 2),
		red_din      => red_data,--(9 downto 2),
		hsync        => VGA_HSYNC,
		vsync        => VGA_VSYNC,
		de           => de,
		TMDS         => TMDS,
		TMDSB        => TMDSB 
	);

--process (pclk)
--begin
--	if rising_edge (pclk) then
		hsync <= VGA_HSYNC_INT xor hvsync_polarity;
		vsync <= VGA_VSYNC_INT xor hvsync_polarity;
--		hsync <= VGA_HSYNC_INT xnor DET_HS_POL;
--		vsync <= VGA_VSYNC_INT xnor DET_VS_POL;
		VGA_HSYNC <= hsync;
		VGA_VSYNC <= vsync;
		active_q <= active;
		de <= active_q;
--	end if;
--end process;


--
--serdes_rst <= RSTBTN or not(bufpll_lock);


-- Debug Ports 
DEBUG(0) <= VGA_HSYNC;
DEBUG(1) <= VGA_VSYNC;

-- LEDs
LED <= pll_lckd & done & '0' & '0' & bufpll_lock & RSTBTN & VGA_HSYNC & VGA_VSYNC;
	
--AD9984A_I2C: entity work.i2c_toplevel PORT MAP(
--		sda   => SDA,
--		scl   => SCL,
--		rst_n => not RSTBTN,
--		done  => done,
--		clk   => i2c_clk_buf
--	);

picoblaze: entity work.pico_i2c port map(
		sda     => SDA,
		scl     => SCL,
		cpu_rst => RSTBTN,
		clk     => i2c_clk_buf
	);

end Behavioral;
