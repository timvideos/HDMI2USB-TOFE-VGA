library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library I2CLib;
use I2CLib.I2CPkg.all;

entity I2CController_TB is
end I2CController_TB;

architecture TestBench of I2CController_TB is

	component I2CController is
		generic (CLK_FREQ       : integer;
					I2C_TICK_NUM   : integer;
					PROGRAM		   : I2C_CONTROLLER_PROG);
		port (   clk            : in  std_logic;
					reset          : in  std_logic;
					sclOut         : out std_logic;
					sdaIn          : in  std_logic;
					sdaOut         : out std_logic;
					held				: out	std_logic;
					notify			: in	std_logic;
					dOutAdd        : out std_logic_vector(3 downto 0);
					dOut           : out std_logic_vector(7 downto 0);
					newData        : out std_logic;
					ackErrors		: out	std_logic_vector(7 downto 0));
	end component;

	constant CLK_FREQ			: integer := 50_000_000;
	constant I2C_TICK_NUM	: integer := 123;

	constant I2C_PROG : I2C_CONTROLLER_PROG(0 to 17) := (
--		(op => DELAY,              arg => b"011",    data => x"E8"),  -- 0:  Startup Delay (1s)
		(op => DELAY,              arg => b"000",    data => x"01"),  -- 0:  Short Delay (For Simuation)

		(op => LOAD,               arg => R0,        data => x"00"),   -- 1:  Initialise Module Number
		(op => LOAD,               arg => R1,        data => x"C1"),   -- 2:  Initialise Address

		(op => I2C_START,          arg => VOID,      data => x"00"),   -- 3:  Start
		(op => I2C_WRITE_REG,      arg => R1,        data => x"00"),   -- 4:   Control Byte (Read)
		(op => I2C_READ_DATA_ACK,  arg => R2,        data => x"00"),   -- 5:   Read ultrasound range
		(op => I2C_READ_DATA_NACK, arg => R3,        data => x"00"),   -- 6:   Read infrared range
		(op => I2C_STOP,           arg => VOID,      data => x"00"),   -- 7:  Stop

		(op => OUTPUT,             arg => R0,        data => x"00"),   -- 8:  Output Module Number
		(op => OUTPUT,             arg => R2,        data => x"01"),   -- 9:  Output ultrasound
		(op => OUTPUT,             arg => R3,        data => x"02"),   -- 10: Output infrared range

--		(op => DELAY,              arg => b"000",    data => x"18"),   -- 11: Delay (Approx 30 ms between pings)
		(op => DELAY,              arg => b"000",    data => x"01"),   -- 11: Short Delay (For Simuation)

		(op => ADD,                arg => R0,        data => x"01"),   -- 12: Compute next module number
		(op => ADD,                arg => R1,        data => x"02"),   -- 13: Compute next device address

		(op => COMP,               arg => R0,        data => x"06"),   -- 14: Test Module Number
		(op => JUMP,               arg => NOT_EQUAL, data => addr(3)), -- 15: Jump to next sonar read

		(op => HOLD,               arg => VOID,      data => x"00"),   -- 16: Wait for signal from host
		(op => JUMP,               arg => ALWAYS,    data => addr(1))  -- 17: Jump to initialise Address
	);


	signal clk			: std_logic;
	signal reset		: std_logic;
	signal sclOut		: std_logic;
	signal sdaIn		: std_logic;
	signal sdaOut		: std_logic;

	signal held			: std_logic;
	signal notify		: std_logic;
	signal dOutAdd		: std_logic_vector(3 downto 0);
	signal dOut			: std_logic_vector(7 downto 0);
	signal newData		: std_logic;
	signal ackErrors	: std_logic_vector(7 downto 0);

	signal scl			: std_logic;
	signal sda			: std_logic;

begin

scl <= '0' when sclOut='0' else 'H';
sda <= '0' when sdaOut='0' else 'H';

UUT : I2CController
generic map(CLK_FREQ			=> CLK_FREQ,
				I2C_TICK_NUM	=> I2C_TICK_NUM,
				PROGRAM			=> I2C_PROG)
port map (	clk				=> clk,
				reset				=> reset,
				sclOut			=> sclOut,
				sdaIn				=> sda,
				sdaOut			=> sdaOut,
				held				=> held,
				notify			=> notify,
				dOutAdd			=> dOutAdd,
				dOut				=> dOut,
				newData			=> newData,
				ackErrors		=> ackErrors);

Clock : process
begin
	clk <= '0';
	wait for 50 ns;
	clk <= '1';
	wait for 50 ns;
end process;

TB : process
	procedure doClocks( num : integer ) is
	begin
		for bitCount in 0 to num loop
			wait until (clk'event and clk='1');
		end loop;
	end procedure doClocks;
begin
	reset <= '1';
	notify <= '0';

	doClocks(2);
	reset <= '0';

	loop
		wait until (held='1');

		wait for 2.5 ms;

		wait until (clk'event and clk='1');
		notify <= '1';
		wait until (clk'event and clk='1');
		notify <= '0';
	end loop;

end process;

end TestBench;
