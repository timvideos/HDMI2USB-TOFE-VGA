-- A.Greensted
-- Sept 2009
-- For full details see http://amtmcbk02/fpgas/modules/i2cController.html
-- See I2CSimpleMaster for an explanation of I2C_TICK_NUM

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library I2CLib;
use I2CLib.I2CPkg.all;

entity I2CController is
	generic (CLK_FREQ			: integer;
				I2C_TICK_NUM	: integer;
				PROGRAM			: I2C_CONTROLLER_PROG);
	port (	clk				: in	std_logic;
				reset				: in	std_logic;

				sclOut			: out	std_logic;
				sdaIn				: in	std_logic;
				sdaOut			: out	std_logic;

				held				: out	std_logic;
				notify			: in	std_logic;
				dOutAdd			: out	std_logic_vector(3 downto 0);
				dOut				: out	std_logic_vector(7 downto 0);
				newData			: out std_logic;

				----------------------------------------------------------------------
				--My Addition: Add parallel Data input lines
				--             so that, we can LOAD_DATA, ie load dynamic data
				dIn		      : in std_logic_vector(7 downto 0);
				-- Enable dIn, so that valid data is present
				dIn_en         : in std_logic; 
				----------------------------------------------------------------------
				
				ackErrors		: out std_logic_vector(7 downto 0));
end I2CController;

architecture Arch of I2CController is

	type REG_FILE_RAM is array (natural range <>) of std_logic_vector(7 downto 0);
	signal regFile					: REG_FILE_RAM(7 downto 0);				-- 8 x 8bit Register File

	signal insnAdd					: integer range 0 to PROGRAM'high;		-- Insn Address
	signal currentInsn			: I2C_CONTROLLER_INSN;						-- Current Instruction
	signal matchFlag				: std_logic;									--	Results of a COMP Instruction

	constant DELAY_TIMER_MAX	: integer := (CLK_FREQ/1000);				-- Timer for 1ms
	signal delayCount				: unsigned(10 downto 0);					-- The number of ms counts
	signal delayTimer				: integer range 0 to DELAY_TIMER_MAX;

	signal slaveAckErrors		: unsigned(7 downto 0);						-- Count of unexpected Slave Acks

	signal i2c_enable				: std_logic;									-- Start an operation
	signal i2c_operation			: I2C_MASTER_OP;								-- Operation required
	signal i2c_done				: std_logic;									-- Indicates Master is done (not busy)
	signal i2c_dataMstr2Bus		: std_logic_vector(7 downto 0);			-- Data from Master to I2C Bus
	signal i2c_dataBus2Mstr		: std_logic_vector(7 downto 0);			-- Data from I2C Bus (slave) to Master
	signal i2c_slaveAck			: std_logic;									-- Acknowledge level from slave (on write)

	type CONTROLLER_STATES is (FETCH, EXECUTE, WAIT_FOR_DONE, DELAY, TIMER);
	signal state					: CONTROLLER_STATES;

begin

ackErrors <= std_logic_vector(slaveAckErrors);

Master : I2CSimpleMaster
generic map(TICK_NUM			=> I2C_TICK_NUM)
port map (  clk				=> clk,
				reset				=> reset,
				sclOut			=> sclOut,
				sdaIn				=> sdaIn,
				sdaOut			=> sdaOut,
				enable			=> i2c_enable,
				operation		=> i2c_operation,
				done				=> i2c_done,
				dataMstr2Bus	=> i2c_dataMstr2Bus,
				dataBus2Mstr	=> i2c_dataBus2Mstr,
				slaveAck			=> i2c_slaveAck);

Controller : process (clk)
	variable fullCount : std_logic_vector(10 downto 0);
begin
	if (clk'event and clk='1') then

		newData <= '0';

		if (reset='1') then
			insnAdd				<= 0;
			state					<= FETCH;

			dOutAdd				<= (others =>'0');
			dOut					<= (others =>'0');
			i2c_enable			<= '0';
			i2c_operation		<= I2C_START;
			i2c_dataMstr2Bus	<= (others => '0');

			matchFlag 			<= '0';
			held		 			<= '0';
			delayTimer			<= 0;
			delayCount			<= (others => '0');

			slaveAckErrors		<= (others => '0');

		else
			case state is
				when FETCH =>
					currentInsn	<= PROGRAM(insnAdd);
					state			<= EXECUTE;
					if (insnAdd = PROGRAM'high) then
						insnAdd <= 0;
					else
						insnAdd <= insnAdd + 1;
					end if;

				when EXECUTE =>
					case currentInsn.op is
						when I2C_START =>
							i2c_operation		<= I2C_START;
							i2c_enable			<= '1';
							state					<= WAIT_FOR_DONE;

						when I2C_RESTART =>
							i2c_operation		<= I2C_RESTART;
							i2c_enable			<= '1';
							state					<= WAIT_FOR_DONE;

						when I2C_STOP =>
							i2c_operation		<= I2C_STOP;
							i2c_enable			<= '1';
							state					<= WAIT_FOR_DONE;

						when I2C_WRITE_REG =>
							i2c_operation		<= I2C_WRITE_DATA;
							i2c_dataMstr2Bus	<= regFile(to_integer(unsigned(currentInsn.arg)));
							i2c_enable			<= '1';
							state					<= WAIT_FOR_DONE;

						when I2C_WRITE_IMM =>
							i2c_operation		<= I2C_WRITE_DATA;
							i2c_dataMstr2Bus	<= currentInsn.data;
							i2c_enable			<= '1';
							state					<= WAIT_FOR_DONE;

						when I2C_READ_DATA_ACK =>
							i2c_operation		<= I2C_READ_DATA_ACK;
							i2c_enable			<= '1';
							state					<= WAIT_FOR_DONE;

						when I2C_READ_DATA_NACK =>
							i2c_operation		<= I2C_READ_DATA_NACK;
							i2c_enable			<= '1';
							state					<= WAIT_FOR_DONE;

						when ADD =>
							regFile(to_integer(unsigned(currentInsn.arg))) <=
								std_logic_vector( unsigned(regFile(to_integer(unsigned(currentInsn.arg)))) +
														unsigned(currentInsn.data));
							state <= FETCH;

						when COMP =>
							if (regFile(to_integer(unsigned(currentInsn.arg))) = currentInsn.data) then
								matchFlag <= '1';
							else
								matchFlag <= '0';
							end if;
							state <= FETCH;

						when LOAD =>
							regFile(to_integer(unsigned(currentInsn.arg))) <= currentInsn.data;
							state <= FETCH;

						when LOAD_DATA =>
							if (dIn_en = '1') then 
								regFile(to_integer(unsigned(currentInsn.arg))) <= dIn;
								state <= FETCH;
							end if;

						when DELAY =>
							fullCount	:= currentInsn.arg & currentInsn.data;
							delayCount	<= unsigned(fullCount);
							state			<= DELAY;

						when OUTPUT =>
							newData	<= '1';
							dOutAdd	<=  currentInsn.data(3 downto 0);
							dOut		<=  regFile(to_integer(unsigned(currentInsn.arg)));
							state		<= FETCH;

						when JUMP =>
							if (currentInsn.arg = ALWAYS) then
								insnAdd	<= to_integer(unsigned(currentInsn.data));

							elsif (currentInsn.arg = EQUAL and matchFlag = '1') then
								insnAdd	<= to_integer(unsigned(currentInsn.data));

							elsif (currentInsn.arg = NOT_EQUAL and matchFlag = '0') then
								insnAdd	<= to_integer(unsigned(currentInsn.data));

							end if;

							state		<= FETCH;

						when HOLD =>
							if (notify = '1') then
								state		<= FETCH;
								held		<= '0';
							else
								held		<= '1';
							end if;

					end case;

				when WAIT_FOR_DONE =>
					if (i2c_enable='1') then
						i2c_enable <= '0';

					elsif (i2c_done='1') then
						state <= FETCH;

						case (currentInsn.op) is
							when  I2C_READ_DATA_ACK | I2C_READ_DATA_NACK =>
								regFile(to_integer(unsigned(currentInsn.arg))) <= i2c_dataBus2Mstr;

							when I2C_WRITE_REG | I2C_WRITE_IMM =>
								if (i2c_slaveAck /= '0') then
									slaveAckErrors <= slaveAckErrors + 1;
								end if;

							when others =>
								null;

						end case;
					end if;

				when DELAY =>
					if (delayCount = b"000_0000_0000") then
						-- If number of ms delays has reached 0, return to FETCH
						state			<= FETCH;
					else
						-- Start another ms delay
						delayTimer	<= DELAY_TIMER_MAX;
						delayCount	<= delayCount - 1;
						state			<= TIMER;
					end if;

				when TIMER =>
					if (delayTimer = 0) then
						state <= DELAY;
					else
						delayTimer <= delayTimer - 1;
					end if;

			end case;

		end if;
	end if;

end process;

end Arch;
