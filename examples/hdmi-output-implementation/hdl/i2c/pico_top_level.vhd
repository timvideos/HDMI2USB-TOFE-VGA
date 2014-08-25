library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library unisim;
use unisim.vcomponents.all;

entity pico_i2c is
   port(
      clk, cpu_rst: in std_logic;
      sda	: inout std_logic;
		scl   : inout std_logic
   );
end pico_i2c;

architecture behavioral of pico_i2c is
   
   -- register signals
   signal led_reg: std_logic_vector(7 downto 0);
	
	-- KCPSM6/ROM signals
	signal              address : std_logic_vector(11 downto 0);
	signal          instruction : std_logic_vector(17 downto 0);
	signal          bram_enable : std_logic;
	signal              in_port : std_logic_vector(7 downto 0);
	signal             out_port : std_logic_vector(7 downto 0);
	signal              port_id : std_logic_vector(7 downto 0);
	signal         write_strobe : std_logic;
	signal       k_write_strobe : std_logic;
	signal          read_strobe : std_logic;
	signal            interrupt : std_logic;
	signal        interrupt_ack : std_logic;
	signal         kcpsm6_sleep : std_logic;
	signal         kcpsm6_reset : std_logic;
	signal                  rdl : std_logic;	

-- Signals for IIC Bus 
--
--   Internal signals are required to implement bi-directional pins.
--
--
	signal        drive_i2c_clk : std_logic;
	signal       drive_i2c_data : std_logic;
	
begin

   -- =====================================================
   --  KCPSM and ROM instantiation
   -- =====================================================
  processor: entity work.kcpsm6
    generic map (                 hwbuild => X"42",    -- 42 hex is ASCII character "B"
                         interrupt_vector => X"7F0",   
                  scratch_pad_memory_size => 256)
    
	 port map(      address => address,
               instruction => instruction,
               bram_enable => bram_enable,
                   port_id => port_id,
              write_strobe => write_strobe,
            k_write_strobe => k_write_strobe,
                  out_port => out_port,
               read_strobe => read_strobe,
                   in_port => in_port,
                 interrupt => interrupt,
             interrupt_ack => interrupt_ack,
                     sleep => kcpsm6_sleep,
                     reset => kcpsm6_reset,
                       clk => clk);
	
  --
  -- Reset by press button (active Low) or JTAG Loader enabled Program Memory 
  --

	kcpsm6_reset <= rdl or cpu_rst;
  --
  -- Unused signals tied off until required.
  -- Tying to other signals used to minimise warning messages.
  --

  kcpsm6_sleep <= '0';   -- Always '0'
  interrupt <= interrupt_ack;  

	proc_rom: entity work.ad9984a_init                    --Name to match your PSM file
		generic map(             
			C_FAMILY             => "S6",   --Family 'S6', 'V6' or '7S'
         C_RAM_SIZE_KWORDS    => 1,      --Program size '1', '2' or '4'
         C_JTAG_LOADER_ENABLE => 1)      --Include JTAG Loader when set to '1' 
		port map(      
			address     => address,      
         instruction => instruction,
         enable      => bram_enable,
         rdl         => rdl,
         clk         => clk);
	

  --
  -----------------------------------------------------------------------------------------
  -- I2C Bus Interface
  -----------------------------------------------------------------------------------------
  --
  -- 'scl' and 'sda' are open collector bidirectional pins.
  -- 
  -- When KCPSM6 presents a '0' to either of the 'drive' signals the corresponding pin 
  -- will be forced Low.
  -- 
  -- When KCPSM6 presents a '1' to either of the 'drive' signals the corresponding pin 
  -- will become high impedance ('Z') allowing the signal to be pulled High by the 
  -- external pull-up or driven Low by a Slave device.
  --

  scl <= '0' when drive_i2c_clk = '0' else 'Z';
  sda <= '0' when drive_i2c_data = '0' else 'Z';
  
input_ports: process(clk)
  begin
    if clk'event and clk = '1' then
      case port_id(1 downto 0) is

       
        -- Read I2C Bus at port address 02 hex
        when "10" =>   in_port(0) <= scl;
                       in_port(1) <= sda;
       
        -- Don't Care for unsued case(s) ensures minimum logic implementation  

        when others =>    in_port <= "XXXXXXXX";  

      end case;
      
    end if;
  end process input_ports;
	
  --
  -----------------------------------------------------------------------------------------
  -- General Purpose Output Ports 
  -----------------------------------------------------------------------------------------
  --
  -- In this design there are two output ports. 
  --   A simple output port used to control the I2C bus pins.
  --   A port used to write data directly to the FIFO buffer within 'uart_tx6' macro.
  --

  output_ports: process(clk)
  begin
    if clk'event and clk = '1' then
      -- 'write_strobe' is used to qualify all writes to general output ports.
      if write_strobe = '1' then

        -- Write to I2C Bus at port port address 08 hex
        if port_id(3) = '1' then
          drive_i2c_clk <= out_port(0);
          drive_i2c_data <= out_port(1);
        end if;

      end if;
    end if; 
  end process output_ports;
	
end behavioral;