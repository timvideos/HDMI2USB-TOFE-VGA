library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
library I2CLib;
use I2CLib.I2CPkg.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity i2c_toplevel is
    Port ( sda : inout  STD_LOGIC;
           scl : out  STD_LOGIC;
			  
--			  LED : out std_logic_vector(7 downto 0);
--			  sw  : in std_logic_vector(7 downto 0);
--			  uart_tx : out std_logic;
--			  uart_rx : in std_logic;
			  rst_n : in std_logic;
--			  btnc 		: in std_logic;
--			  btnu		: in std_logic; 
--			  btnl		: in std_logic;
--			  btnr		: in std_logic; 
--			  btnd		: in std_logic;
           done      : out std_logic;
			  clk : in  STD_LOGIC);
end i2c_toplevel;

architecture Behavioral of i2c_toplevel is

constant I2C_PROG : I2C_CONTROLLER_PROG(0 to 169) := (
 (op => DELAY,              arg => b"011",    data => x"E8"),   -- 0:  Startup Delay (1s)

------------------------------
-- START OF I2C CONFIGURATION
------------------------------

 (op => LOAD,               arg => R0,        data => x"98"),   -- Load AD9984A's address into R2    
 (op => LOAD,               arg => R1,        data => x"98"),   -- Load AD9984A's address into R2 
 (op => LOAD,               arg => R0,        data => x"98"),   -- Load AD9984A's address into R2 
 
 --------------------------------
 -- Input & Output Configuration
 --------------------------------
 
  -- 0x1E: Input select=0, PWRDWN Polarity to 1 (+) instead of (-) hence B4 instead of B0
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"1E"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"B4"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop
  
  -- 0x1F: Output Sel 1
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"98"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"1F"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"94"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop

  -- 0x20: Output Sel 2 #Enabled Filter with 0x07 [alt: 0x05]
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"20"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"07"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop

-------------------
-- Analog settings
-------------------

  -- 0x05: red gain[8:2]
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"05"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"40"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop

  -- 0x06: red gain[1:0]
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"06"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"00"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop

  -- 0x07: grn gain[8:2]
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"07"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"40"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop

  -- 0x08: grn gain[1:0]
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"08"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"00"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop

  -- 0x09: blu gain[8:2]
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"09"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"40"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop

  -- 0x0A: blu gain[1:0]
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"0A"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"00"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop

  -- 0x0B: red offset[10:3] #[Alt: 0x00]
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"0B"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"FF"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop

  -- 0x0C: red offset[2:0] #[Alt: 0x80]
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"0C"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"FF"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop

  -- 0x0D: grn offset[10:3] #[Alt: 0x00]
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"0D"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"FF"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop

  -- 0x0E: grn offset[2:0] #[Alt: 0x80]
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"0E"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"FF"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop

  -- 0x0F: blu offset[10:3] #[Alt: 0x00]
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"0F"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"FF"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop

  -- 0x10: blu offset[2:0] #[Alt: 0x80]
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"10"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"FF"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop

  -- 0x1B: Clamp and offset, Turn on auto offset with 0x3B #Disable auto-offset with 0x1B [alt:0x2B]
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"1B"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"1B"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop

  -- 0x3C: Auto Gain, Enable auto gain matching
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"3C"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"0E"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop

---------------------------------
-- Required Test Register Writes
---------------------------------

  -- 0x2D: 
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"2D"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"E8"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop
  
  -- 0x2E: 
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"2E"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"E0"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop

  -- 0x28:
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"28"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"BF"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop

  -- 0x29:
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"29"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"02"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop

-------------------
-- Timing Settings
-------------------
  
  -- 0x01: PLLDIV[11:4]
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"01"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"54"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop

  -- 0x02: PLLDIV[3:0] 
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"02"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"00"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop

  -- 0x03: VCO Ctrl
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"03"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"A0"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop

  -- 0x04: Phase adjust
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"04"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"80"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop

  -- 0x13: HS width = 136 pixel clks = 0x88
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"13"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"88"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop

  -- 0x19: Clamp Placement [alt: 0x04]
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"19"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"01"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop

  -- 0x1A: Clamp duration [alt: 0x82]
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"1A"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"8C"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop
  
-----------------
-- VSYNC Control
-----------------

  -- 0x14: Enable VSYNC Filter
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"14"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"1C"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop

  -- 0x15: Set VSYNC duration to 6 HSYNCs
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"15"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"06"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop

  -- 0x16: Precoast
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"16"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"03"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop

  -- 0x17: Postcoast
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"17"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"06"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop

---------------
-- SOG Control
---------------

  -- 0x1D: Enable Raw HSYNCs on SOGOUT 
 (op => I2C_START,          arg => VOID,      data => x"00"),   -- 1:  Start
 (op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 2:  Write AD9984A's address to bus
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"1D"),   -- 3:  Write regAddress 
 (op => I2C_WRITE_IMM,      arg => VOID,      data => x"7D"),   -- 3:  Write regValue 
 (op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 4:  Stop

-----------------------------------------
-------- END OF I2C CONFIGURATION -------
-----------------------------------------

 (op => HOLD,               arg => VOID,      data => x"00")    -- Hold the State Machine after initialization
);

component I2CController 
generic (	CLK_FREQ			: integer;
				I2C_TICK_NUM	: integer;
				PROGRAM        : I2C_CONTROLLER_PROG);
port (		clk				: in	std_logic;
				reset				: in	std_logic;

				sclOut			: out	std_logic;
				sdaIn				: in	std_logic;
				sdaOut			: out	std_logic;

				held				: out	std_logic;
				notify			: in	std_logic;
				dOutAdd			: out	std_logic_vector(3 downto 0);
				dOut				: out	std_logic_vector(7 downto 0);
				newData			: out std_logic;

				--My Addition: Add parallel Data input lines
				--             so that, we can LOAD_DATA, ie load dynamic data
				dIn		      : in std_logic_vector(7 downto 0);
				-- Enable dIn, so that valid data is present
				dIn_en         : in std_logic; 
				
				ackErrors		: out std_logic_vector(7 downto 0));				
end component;

signal sdaIn : std_logic;
signal sdaOut: std_logic;
signal sclOut: std_logic;
signal held	 : std_logic;	
signal notify : std_logic;		
signal dOutAdd :	std_logic_vector(3 downto  0);	
signal dOut		:	std_logic_vector(7 downto 0);
signal newData	:	std_logic;
signal ackErrors :	std_logic_vector(7 downto 0);
signal reset : std_logic;
signal dIn_to_controller : std_logic_vector(7 downto 0);
signal dIn_en : std_logic;


--signal insnAdd		: integer range 0 to regData'high;

begin

sdaIn <= sda;
sda <= '0' when sdaOut='0' else 'Z';
scl <= '0' when sclOut='0' else 'Z';
reset <= not rst_n;
done <= held;

i3c2_controller: I2CController 
generic map(
	CLK_FREQ		 => 100000000,
	I2C_TICK_NUM => 248, -- 100KHz, 100MHZ clock
	PROGRAM => I2C_PROG)
port map(
	clk 			=> clk,
	reset			=> reset,
	sclOut		=> sclOut,
	sdaIn			=> sdaIn,	
	sdaOut		=> sdaOut,	
	held			=> held,	
	notify		=> notify,	
	dOutAdd		=> dOutAdd,	
	dOut			=> dOut,	
	newData		=> newData,	
	dIn         => dIn_to_controller,
	dIn_en      => dIn_en,
	ackErrors	=> ackErrors
);



end Behavioral;

