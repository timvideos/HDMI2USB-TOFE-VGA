-- A.Greensted
-- Sept 2009
-- For full details see http://amtmcbk02/fpgas/modules/i2cController.html
-- See I2CSimpleMaster for an explanation of I2C_TICK_NUM

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package I2CPkg is

	constant VOID			: std_logic_vector(2 downto 0) := b"000";

	constant R0				: std_logic_vector(2 downto 0) := b"000";
	constant R1				: std_logic_vector(2 downto 0) := b"001";
	constant R2				: std_logic_vector(2 downto 0) := b"010";
	constant R3				: std_logic_vector(2 downto 0) := b"011";
	constant R4				: std_logic_vector(2 downto 0) := b"100";
	constant R5				: std_logic_vector(2 downto 0) := b"101";
	constant R6				: std_logic_vector(2 downto 0) := b"110";
	constant R7				: std_logic_vector(2 downto 0) := b"111";

	constant ALWAYS		: std_logic_vector(2 downto 0) := b"000";
	constant EQUAL			: std_logic_vector(2 downto 0) := b"001";
	constant NOT_EQUAL	: std_logic_vector(2 downto 0) := b"010";

	type I2C_CONTROLLER_OP is (	I2C_START,
											I2C_RESTART,
											I2C_STOP,
											I2C_WRITE_REG,
											I2C_WRITE_IMM,
											I2C_READ_DATA_ACK,
											I2C_READ_DATA_NACK,
											LOAD,
											
											------------------
											--Added LOAD_DATA Instruction to LOAD data from dIn to a specified Register
											LOAD_DATA,
											------------------
											
											ADD,
											COMP,
											OUTPUT,
											DELAY,
											JUMP,
											HOLD);

	type I2C_CONTROLLER_INSN is record
		op			: I2C_CONTROLLER_OP;
		arg		: std_logic_vector(2 downto 0);
		data		: std_logic_vector(7 downto 0);
	end record I2C_CONTROLLER_INSN;

	type I2C_CONTROLLER_PROG is array (natural range <>) of I2C_CONTROLLER_INSN;

	type I2C_MASTER_OP is (	I2C_START,
									I2C_RESTART,
									I2C_STOP,
									I2C_WRITE_DATA,
									I2C_READ_DATA_ACK,
									I2C_READ_DATA_NACK);

	component I2CSimpleMaster is
		generic(	TICK_NUM			: integer);
		port (	clk				: in	std_logic;
					reset				: in	std_logic;
					sclOut			: out	std_logic;
					sdaIn				: in	std_logic;
					sdaOut			: out	std_logic;
					enable			: in	std_logic;								-- Start an operation
					operation		: in	I2C_MASTER_OP;							-- Operation required
					done				: out std_logic;								-- Indicates Master si done (not busy)
					dataMstr2Bus	: in	std_logic_vector(7 downto 0);		-- Data from Master to I2C Bus
					dataBus2Mstr	: out	std_logic_vector(7 downto 0);		-- Data from I2C Bus (slave) to Master
					slaveAck			: out	std_logic);								-- Acknowledge level from slave (on write)
	end component;

	component I2CController is
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
					ackErrors		: out std_logic_vector(7 downto 0));
	end component;

	function addr( address : integer range 0 to 255 ) return std_logic_vector;

	function to_I2C_MASTER_OP( value : std_logic_vector(2 downto 0) ) return I2C_MASTER_OP;
	function to_std_logic_vector( value : I2C_MASTER_OP ) return std_logic_vector;


end I2CPkg;

package body I2CPkg is


function addr( address : integer range 0 to 255 ) return std_logic_vector is
begin
	return std_logic_vector(to_unsigned(address, 8));
end function addr;


function to_I2C_MASTER_OP( value : std_logic_vector(2 downto 0) ) return I2C_MASTER_OP is
	variable result : I2C_MASTER_OP;
begin

	case value is
		when b"000"	=> result := I2C_START;						-- 0
		when b"001"	=> result := I2C_RESTART;					-- 1
		when b"010"	=> result := I2C_STOP;						-- 2
		when b"011"	=> result := I2C_WRITE_DATA;				-- 3
		when b"100"	=> result := I2C_READ_DATA_ACK;			-- 4
--		when b"101"	=> result := I2C_READ_DATA_NACK;			-- 5
		when others	=> result := I2C_READ_DATA_NACK;			-- 5
	end case;

	return result;

end function to_I2C_MASTER_OP;


function to_std_logic_vector( value : I2C_MASTER_OP ) return std_logic_vector is
	variable result : std_logic_vector(2 downto 0);
begin

	case value is
		when I2C_START				=> result := b"000";			-- 0
		when I2C_RESTART			=> result := b"001";			-- 1
		when I2C_STOP				=> result := b"010";			-- 2
		when I2C_WRITE_DATA		=> result := b"011";			-- 3
		when I2C_READ_DATA_ACK	=> result := b"100";			-- 4
		when I2C_READ_DATA_NACK	=> result := b"101";			-- 5
	end case;

	return result;

end function to_std_logic_vector;

end I2CPkg;
