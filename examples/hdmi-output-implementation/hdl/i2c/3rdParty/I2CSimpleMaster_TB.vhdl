library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library I2CLib;
use I2CLib.I2CPkg.all;

entity I2CSimpleMaster_TB is
end I2CSimpleMaster_TB;

architecture TestBench of I2CSimpleMaster_TB is

	signal clk				: std_logic;
	signal reset			: std_logic;

	signal sclOut			: std_logic;
	signal sdaIn			: std_logic;
	signal sdaOut			: std_logic;

	signal enable			: std_logic;
	signal operation		: I2C_MASTER_OP;
	signal done				: std_logic;

	signal dataMstr2Bus	: std_logic_vector(7 downto 0);
	signal dataBus2Mstr	: std_logic_vector(7 downto 0);
	signal slaveAck		: std_logic;

	signal scl				: std_logic;
	signal sda				: std_logic;

begin

scl <= '0' when sclOut='0' else 'H';
sda <= '0' when sdaOut='0' else 'H';

Clock : process -- 50 MHz
begin
	clk <= '0';
	wait for 10 ns;
	clk <= '1';
	wait for 10 ns;
end process;

UUT : I2CSimpleMaster
generic map(TICK_NUM			=> 123)
port map (	clk				=> clk,
				reset				=> reset,

				sclOut         => sclOut,
				sdaIn          => sda,
				sdaOut         => sdaOut,

				enable			=> enable,
				operation		=> operation,
				done				=> done,

				dataMstr2Bus	=> dataMstr2Bus,
				dataBus2Mstr	=> dataBus2Mstr,
				slaveAck			=> slaveAck);

TB : process

	procedure doClocks( num : integer ) is
	begin
		for bitCount in 0 to num loop
			wait until (clk'event and clk='1');
		end loop;
	end procedure doClocks;

	procedure toggleEnable is
	begin
		wait until (clk'event and clk='1');
		enable <= '1';
		wait until (clk'event and clk='1');
		enable <= '0';
	end procedure toggleEnable;

	procedure waitForDone is
	begin
		wait until (done='1');
		wait until (clk'event and clk='1');
	end procedure waitForDone;

begin
	reset <= '1';
	enable <= '0';
	operation <= I2C_START;
	dataMstr2Bus <= x"00";

	wait for 10 us;
	doClocks(2);
	reset <= '0';

	wait for 10 us;
	doClocks(2);

	operation <= I2C_START;
	toggleEnable;

	waitForDone;
	operation <= I2C_WRITE_DATA;
	dataMstr2Bus <= x"93";
	toggleEnable;

	waitForDone;
	operation <= I2C_RESTART;
	toggleEnable;

	waitForDone;
	operation <= I2C_WRITE_DATA;
	dataMstr2Bus <= x"11";
	toggleEnable;

	waitForDone;
	operation <= I2C_READ_DATA_ACK;
	dataMstr2Bus <= x"11";
	toggleEnable;

	waitForDone;
	operation <= I2C_STOP;
	toggleEnable;

	wait;
end process;

end TestBench;
