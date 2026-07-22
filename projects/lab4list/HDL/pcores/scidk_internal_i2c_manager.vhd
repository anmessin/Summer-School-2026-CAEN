

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity scidk_internal_i2c_manager is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           offset : in STD_LOGIC_VECTOR (15 downto 0);
		   w_offset : in STD_LOGIC;
           sda : inout STD_LOGIC;
           scl : inout STD_LOGIC
           );
end scidk_internal_i2c_manager;

architecture Behavioral of scidk_internal_i2c_manager is

COMPONENT i2c_master_scidk_config IS
  GENERIC(
    input_clk : INTEGER := 50_000_000; --input clock speed from user logic in Hz
    bus_clk   : INTEGER := 400_000);   --speed the i2c bus (scl) will run at in Hz
  PORT(
    clk       : IN     STD_LOGIC;                    --system clock
    reset_n   : IN     STD_LOGIC;                    --active low reset
    ena       : IN     STD_LOGIC;                    --latch in command
    addr      : IN     STD_LOGIC_VECTOR(6 DOWNTO 0); --address of target slave
    rw        : IN     STD_LOGIC;                    --'0' is write, '1' is read
    data_wr   : IN     STD_LOGIC_VECTOR(7 DOWNTO 0); --data to write to slave
    busy      : OUT    STD_LOGIC;                    --indicates transaction in progress
    data_rd   : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0); --data read from slave
    ack_error : BUFFER STD_LOGIC;                    --flag if improper acknowledge from slave
    sda       : INOUT  STD_LOGIC;                    --serial data output of i2c bus
    scl       : INOUT  STD_LOGIC);                   --serial clock output of i2c bus
END COMPONENT;

signal IIC_exec : std_logic := '0';
signal IIC_devaddress : STD_LOGIC_VECTOR(7 DOWNTO 0); 
signal IIC_rw        : STD_LOGIC;                    --'0' is write, '1' is read
signal IIC_data_wr   : STD_LOGIC_VECTOR(7 DOWNTO 0); --data to write to slave
signal IIC_busy      : STD_LOGIC;                    --indicates transaction in progress
signal IIC_data_rd   : STD_LOGIC_VECTOR(7 DOWNTO 0); --data read from slave
signal IIC_ack_error : STD_LOGIC;                    --flag if improper acknowledge from slave

signal EXTSM : std_logic_vector(3 downto 0) := x"F";
signal startup_counter : integer := 0;
signal resetn : std_logic := '0';

signal loffset : STD_LOGIC_VECTOR (15 downto 0) := x"0800";

             
begin


iic_master : i2c_master_scidk_config
  PORT MAP(
    clk       => clk,
    reset_n   => '1',
    ena       => IIC_exec,
    addr      => IIC_devaddress(6 downto 0),
    rw        => IIC_rw,
    data_wr   => IIC_data_wr,
    busy      => IIC_busy,
    data_rd   => IIC_data_rd,
    ack_error => IIC_ack_error,
    sda       => sda,
    scl       => scl);

IIC_PROGRAM_SM : process(clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            EXTSM <= x"F";
            resetn <= '0';
        else
            resetn <= '1';
            case EXTSM is
				when x"F" =>
				    if startup_counter= 100000 then
                        EXTSM <= x"1";
                    else
                        startup_counter <= startup_counter +1;
                    end if;
                when x"0" =>
				
                    if w_offset ='1' then
						loffset <= offset;
						EXTSM <= x"1";
					end if;

                    
                when x"1" =>
                    IIC_devaddress <= x"60";
                    IIC_rw <= '0';
                    IIC_data_wr <= x"40";
                    IIC_exec <= '1';
                    if IIC_busy = '1' then
                        EXTSM <= x"2";
                    end if;
                    
                when x"2" =>
                   IIC_data_wr <= loffset(11 downto 4);
                   IIC_exec <= '1';
                   if IIC_busy = '0' then
                    EXTSM <= x"3";
                   end if;                    

                when x"3" =>
                    if IIC_busy = '1' then
                        EXTSM <= x"4";
                    end if;
                
                when x"4" =>    
                    IIC_data_wr <= loffset(3 downto 0) & x"0";
                    IIC_exec <= '1';              
                    if IIC_busy = '0' then
                        EXTSM <= x"5";
                    end if;                        
                    
                when x"5" =>
                    if IIC_busy = '1' then
                        EXTSM <= x"6";
                    end if;
                
                when x"6" =>   
                    IIC_exec <= '0';
                    if IIC_busy = '0' then
                        EXTSM <= x"0";  
                    end if;
                    
                    
                 
                when others =>   
                   
            end case;
        end if;
    end if;
end process;
end Behavioral;