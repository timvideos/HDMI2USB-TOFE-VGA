-- A.Greensted
-- Sept 2009
-- For full details see http://amtmcbk02/fpgas/modules/i2cController.html
-- See I2CSimpleMaster for an explanation of I2C_TICK_NUM

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library I2CLib;
use I2CLib.I2CPkg.all;

-- TICK_NUM controls the I2C bus timing. 

--	TICKNUM = (fClk / (4 * speed)) - 2
-- where,  fClk:  Frequency of clk input (Hz)
--         speed: I2C Bus speed (bits/second)

-- Examples:
-- fClk:  10 MHz Clock
-- speed: 10 kbit/s (Low-speed mode)
-- TICK_NUM = (10000000 / (4 * 10000)) - 2
--          = 248

-- fClk:  50 MHz Clock
-- speed: 100 kbit/s (Standard mode)
-- TICK_NUM = (50000000 / (4 * 100000)) - 2
--          = 123

entity I2CSimpleMaster is
	generic(	TICK_NUM			: integer);
	port (	clk				: in	std_logic;
				reset				: in	std_logic;

				sclOut			: out	std_logic;
				sdaIn				: in	std_logic;
				sdaOut			: out	std_logic;

				enable			: in	std_logic;								-- Start an operation
				operation		: in	I2C_MASTER_OP;							-- Operation required
				done				: out std_logic;								-- Indicates Master is done (not busy)

				dataMstr2Bus	: in	std_logic_vector(7 downto 0);		-- Data from Master to I2C Bus
				dataBus2Mstr	: out	std_logic_vector(7 downto 0);		-- Data from I2C Bus (slave) to Master
				slaveAck			: out	std_logic);								-- Acknowledge level from slave (on write)
end I2CSimpleMaster;

architecture Arch of I2CSimpleMaster is

	type STATES is (A, B, C, D, IDLE);

	signal bitCount		: integer range 0 to 8;
	signal timer			: integer range 0 to TICK_NUM;
	signal busy				: std_logic;

	signal state			: STATES;
	signal delayEnable	: std_logic;

	signal op				: I2C_MASTER_OP;
	signal dataIn			: std_logic_vector(8 downto 0);	-- dataIn is 1 bit longer to allow for ack bit
	signal dataOut			: std_logic_vector(7 downto 0);
	signal ack				: std_logic;

begin

done <= not busy;

Controller : process(clk)
begin
	if (clk'event and clk='1') then
		if (reset='1') then
			bitCount			<= 0;
			timer				<= 0;
			busy				<= '0';

			state				<= A;
			delayEnable		<= '0';

			op					<= I2C_START;
			dataIn			<= (others => '0');
			dataOut			<= (others => '0');
			ack				<= '0';

			dataBus2Mstr	<= (others => '0');
			slaveAck			<= '0';

			sclOut			<= '1';	-- SCL pulled high
			sdaOut			<= '1';	-- SDA pulled high

		else
			if (busy='0') then
				if (enable='1') then
					busy		<= '1';
					state		<= A;
					op			<= operation;
					dataOut	<= dataMstr2Bus;
					bitCount	<= 0;
				end if;

			elsif (delayEnable='1') then
				if (timer=TICK_NUM) then
					timer			<= 0;
					delayEnable	<= '0';
				else
					timer			<= timer + 1;
				end if;

			else
				case state is
					when A =>
						state <= B;
						delayEnable <= '1';

						case op is
							when I2C_START =>
								sclOut	<= '1';	-- SCL pulled high
								sdaOut	<= '1';	-- SDA pulled high

							when I2C_RESTART =>
								sclOut	<= '0';	-- SCL driven low
								sdaOut	<= '1';	-- SDA pulled high

							when I2C_STOP =>
								sclOut	<= '0';	-- SCL driven low
								sdaOut	<= '0';	-- SDA driven low

							when I2C_WRITE_DATA =>
								sclOut	<= '0';	-- SCL driven low

								if (bitCount=8) then
									sdaOut	<= '1';			-- SDA pulled high (Allow slave ack)
								else
									sdaOut	<= dataOut(7);	-- SDA set by data bit
								end if;

							when I2C_READ_DATA_ACK =>
								sclOut	<= '0';	-- SCL driven low
								if (bitCount=8) then
									sdaOut	<= '0';	-- SDA driven low (Set Ack bit)
								else
									sdaOut	<= '1';	-- SDA pulled high (Allow slave write)
								end if;

							when I2C_READ_DATA_NACK =>
								sclOut	<= '0';	-- SCL driven low
								sdaOut	<= '1';	-- SDA pulled high (Set Nack bit or allow slave write)

						end case;

						dataOut <= dataOut(6 downto 0) & '0';

					when B =>
						state <= C;
						delayEnable <= '1';

						case op is
							when I2C_START =>
								sclOut	<= '1';	-- SCL pulled high
								sdaOut	<= '1';	-- SDA pulled high

							when I2C_RESTART =>
								sclOut	<= '1';	-- SCL pulled high
								sdaOut	<= '1';	-- SDA pulled high

							when I2C_STOP =>
								sclOut	<= '1';	-- SCL pulled high
								sdaOut	<= '0';	-- SDA driven low

							when I2C_WRITE_DATA =>
								sclOut	<= '1';	-- SCL pulled high

							when I2C_READ_DATA_ACK =>
								sclOut	<= '1';	-- SCL pulled high

							when I2C_READ_DATA_NACK =>
								sclOut	<= '1';	-- SCL pulled high

						end case;

					when C =>
						state <= D;
						delayEnable <= '1';

						case op is
							when I2C_START =>
								sclOut	<= '1';	-- SCL pulled high
								sdaOut	<= '0';	-- SDA driven low

							when I2C_RESTART =>
								sclOut	<= '1';	-- SCL pulled high
								sdaOut	<= '0';	-- SDA driven low

							when I2C_STOP =>
								sclOut	<= '1';	-- SCL pulled high
								sdaOut	<= '1';	-- SDA pulled high

							when I2C_WRITE_DATA =>
								sclOut	<= '1';	-- SCL pulled high

								if (bitCount=8) then
									ack	<= sdaIn;	-- Read Slave Acknowledge
								end if;

							when I2C_READ_DATA_ACK =>
								sclOut	<= '1';	-- SCL pulled high
								dataIn <= dataIn(7 downto 0) & sdaIn;

							when I2C_READ_DATA_NACK =>
								sclOut	<= '1';	-- SCL pulled high
								dataIn <= dataIn(7 downto 0) & sdaIn;

						end case;

					when D =>
						delayEnable <= '1';

						case op is
							when I2C_START =>
								sclOut	<= '0';	-- SCL driven low
								sdaOut	<= '0';	-- SDA driven low

							when I2C_RESTART =>
								sclOut	<= '0';	-- SCL driven low
								sdaOut	<= '0';	-- SDA driven low

							when I2C_STOP =>
								sclOut	<= '1';	-- SCL pulled high
								sdaOut	<= '1';	-- SDA pulled high

							when I2C_WRITE_DATA =>
								sclOut	<= '0';	-- SCL driven low
							when I2C_READ_DATA_ACK =>
								sclOut	<= '0';	-- SCL driven low
							when I2C_READ_DATA_NACK =>
								sclOut	<= '0';	-- SCL driven low

						end case;

						case op is
							when I2C_START | I2C_RESTART | I2C_STOP =>
								state <= IDLE;
							when I2C_WRITE_DATA | I2C_READ_DATA_ACK | I2C_READ_DATA_NACK =>
								if (bitCount=8) then
									state <= IDLE;
								else
									bitCount <= bitCount + 1;
									state <= A;
								end if;

						end case;

					when IDLE =>
						busy <= '0';

						if (op=I2C_READ_DATA_ACK or op=I2C_READ_DATA_NACK) then
							dataBus2Mstr <= dataIn(8 downto 1);
						end if;

						if (op=I2C_WRITE_DATA) then
							slaveAck <= ack;
						end if;

				end case;

			end if;
		end if;
	end if;
end process;

end Arch;
