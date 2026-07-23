----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:23:13 06/29/2011 
-- Design Name: 
-- Module Name:    ftdi245_cdc - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

Library xpm;
use xpm.vcomponents.all;
        

entity ftdi245_cdc is
    Port ( 
				--LATO FTDI
	 
			  FTDI_ADBUS : inout STD_LOGIC_VECTOR (7 downto 0);
			  FTDI_RXFN : in STD_LOGIC;									--EMPTY
			  FTDI_TXEN : in STD_LOGIC; 									--FULL
			  FTDI_RDN	: out STD_LOGIC;									--READ ENABLE
			  FTDI_TXN	: out STD_LOGIC;									--WRITE ENABLE
			  FTDI_CLK	: in STD_LOGIC;									--FTDI CLOCK
			  FTDI_OEN	: out STD_LOGIC;									--OUTPUT ENABLE NEGATO LATO FTDI
			  FTDI_SIWU : out STD_LOGIC;									--COMMIT A PACKET IMMEDIATLY

				--LATO FPGA
			  f_CLK : IN STD_LOGIC;
			  f_RESET : IN STD_LOGIC;
			  
			  EEMOSI : out STD_LOGIC;
              EEMISO : in STD_LOGIC;
              EECLK : out STD_LOGIC;
              EECS : out STD_LOGIC; 
			  
			  REG_FIRMWARE_BUILD : IN STD_LOGIC_VECTOR(31 downto 0);
			  
      -- Register interface          
	BUS_Spectrum_0_READ_ADDRESS : OUT STD_LOGIC_VECTOR(15 downto 0); 
	BUS_Spectrum_0_READ_DATA : IN STD_LOGIC_VECTOR(31 downto 0); 
	BUS_Spectrum_0_WRITE_DATA : OUT STD_LOGIC_VECTOR(31 downto 0); 
	BUS_Spectrum_0_W_INT : OUT STD_LOGIC_VECTOR(0 downto 0); 
	BUS_Spectrum_0_R_INT : OUT STD_LOGIC_VECTOR(0 downto 0); 
	BUS_Spectrum_0_VLD : IN STD_LOGIC_VECTOR(0 downto 0); 
		REG_Spectrum_0_STATUS_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		INT_Spectrum_0_STATUS_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_Spectrum_0_CONFIG_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_Spectrum_0_CONFIG_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_Spectrum_0_CONFIG_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_Spectrum_0_CONFIG_LIMIT_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_Spectrum_0_CONFIG_LIMIT_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_Spectrum_0_CONFIG_LIMIT_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_Spectrum_0_CONFIG_REBIN_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_Spectrum_0_CONFIG_REBIN_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_Spectrum_0_CONFIG_REBIN_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_Spectrum_0_CONFIG_MIN_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_Spectrum_0_CONFIG_MIN_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_Spectrum_0_CONFIG_MIN_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_Spectrum_0_CONFIG_MAX_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_Spectrum_0_CONFIG_MAX_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_Spectrum_0_CONFIG_MAX_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_T_OFFSET_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_T_OFFSET_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_T_OFFSET_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_T_OFFSET_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_T_THRS_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_T_THRS_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_T_THRS_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_T_THRS_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_T_TRIG_K_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_T_TRIG_K_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_T_TRIG_K_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_T_TRIG_K_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_T_TRIG_M_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_T_TRIG_M_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_T_TRIG_M_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_T_TRIG_M_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_T_TRAP_K_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_T_TRAP_K_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_T_TRAP_K_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_T_TRAP_K_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_T_DECONV_M_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_T_DECONV_M_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_T_DECONV_M_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_T_DECONV_M_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_T_TRAP_GAIN_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_T_TRAP_GAIN_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_T_TRAP_GAIN_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_T_TRAP_GAIN_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_T_BL_LEN_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_T_BL_LEN_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_T_BL_LEN_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_T_BL_LEN_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_T_BL_INIB_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_T_BL_INIB_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_T_BL_INIB_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_T_BL_INIB_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_T_SAMPLE_POS_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_T_SAMPLE_POS_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_T_SAMPLE_POS_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_T_SAMPLE_POS_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_T_RUN_CFG_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_T_RUN_CFG_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_T_RUN_CFG_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_T_RUN_CFG_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
	BUS_Oscilloscope_0_READ_ADDRESS : OUT STD_LOGIC_VECTOR(13 downto 0); 
	BUS_Oscilloscope_0_READ_DATA : IN STD_LOGIC_VECTOR(31 downto 0); 
	BUS_Oscilloscope_0_WRITE_DATA : OUT STD_LOGIC_VECTOR(31 downto 0); 
	BUS_Oscilloscope_0_W_INT : OUT STD_LOGIC_VECTOR(0 downto 0); 
	BUS_Oscilloscope_0_R_INT : OUT STD_LOGIC_VECTOR(0 downto 0); 
	BUS_Oscilloscope_0_VLD : IN STD_LOGIC_VECTOR(0 downto 0); 
		REG_Oscilloscope_0_READ_STATUS_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		INT_Oscilloscope_0_READ_STATUS_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_Oscilloscope_0_READ_POSITION_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		INT_Oscilloscope_0_READ_POSITION_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_Oscilloscope_0_CONFIG_TRIGGER_MODE_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_Oscilloscope_0_CONFIG_TRIGGER_MODE_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_Oscilloscope_0_CONFIG_TRIGGER_MODE_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_Oscilloscope_0_CONFIG_PRETRIGGER_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_Oscilloscope_0_CONFIG_PRETRIGGER_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_Oscilloscope_0_CONFIG_PRETRIGGER_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_Oscilloscope_0_CONFIG_TRIGGER_LEVEL_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_Oscilloscope_0_CONFIG_TRIGGER_LEVEL_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_Oscilloscope_0_CONFIG_TRIGGER_LEVEL_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_Oscilloscope_0_CONFIG_ARM_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_Oscilloscope_0_CONFIG_ARM_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_Oscilloscope_0_CONFIG_ARM_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_Oscilloscope_0_CONFIG_DECIMATOR_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_Oscilloscope_0_CONFIG_DECIMATOR_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_Oscilloscope_0_CONFIG_DECIMATOR_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_UNIQUE_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_UNIQUE_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
				  
			  
			  REG_OFFSET_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
              REG_OFFSET_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
              INT_OFFSET_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
              INT_OFFSET_WR : OUT STD_LOGIC_VECTOR(0 downto 0);

              REG_IO_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
              REG_IO_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
              INT_IO_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
              INT_IO_WR : OUT STD_LOGIC_VECTOR(0 downto 0);
			
			--Flash controller 
				BUS_Flash_0_READ_DATA : IN STD_LOGIC_VECTOR(31 downto 0);
				BUS_Flash_0_ADDRESS : OUT STD_LOGIC_VECTOR(15 downto 0); 
				BUS_Flash_0_WRITE_DATA : OUT STD_LOGIC_VECTOR(31 downto 0); 
				BUS_Flash_0_W_INT : OUT STD_LOGIC_VECTOR(0 downto 0); 
				BUS_Flash_0_R_INT : OUT STD_LOGIC_VECTOR(0 downto 0); 
				BUS_Flash_0_VLD : IN STD_LOGIC_VECTOR(0 downto 0); 
				
				REG_FLASH_CNTR_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
				REG_FLASH_CNTR_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
				INT_FLASH_CNTR_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
				INT_FLASH_CNTR_WR : OUT STD_LOGIC_VECTOR(0 downto 0);
				
				REG_FLASH_ADDRESS_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
				REG_FLASH_ADDRESS_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
				INT_FLASH_ADDRESS_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
				INT_FLASH_ADDRESS_WR : OUT STD_LOGIC_VECTOR(0 downto 0);    	  
			  
				--test
				BUS_Test_0_READ_DATA : IN STD_LOGIC_VECTOR(31 downto 0);
				BUS_Test_0_ADDRESS : OUT STD_LOGIC_VECTOR(15 downto 0); 
				BUS_Test_0_WRITE_DATA : OUT STD_LOGIC_VECTOR(31 downto 0); 
				BUS_Test_0_W_INT : OUT STD_LOGIC_VECTOR(0 downto 0); 
				BUS_Test_0_R_INT : OUT STD_LOGIC_VECTOR(0 downto 0); 
				BUS_Test_0_VLD : IN STD_LOGIC_VECTOR(0 downto 0)					

			  
				);
end ftdi245_cdc;

architecture Behavioral of ftdi245_cdc is

	component FTDI_FIFOs
		port (
		rst: IN std_logic;
		wr_clk: IN std_logic;
		rd_clk: IN std_logic;
		din: IN std_logic_VECTOR(33 downto 0);
		wr_en: IN std_logic;
		rd_en: IN std_logic;
		dout: OUT std_logic_VECTOR(33 downto 0);
		full: OUT std_logic;
		empty: OUT std_logic;
		prog_full: OUT std_logic
		);
	end component;



	COMPONENT ftdi245
	PORT(
		reset : IN std_logic;
		FTDI_RXFN : IN std_logic;
		FTDI_TXEN : IN std_logic;
		FTDI_CLK : IN std_logic;
		FTDI_ADBUS : INOUT std_logic_vector(7 downto 0);      
		FTDI_RDN : OUT std_logic;
		FTDI_TXN : OUT std_logic;
		FTDI_OEN : OUT std_logic;
		FTDI_SIWU : OUT std_logic;
		
		EEMOSI : out STD_LOGIC;
        EEMISO : in STD_LOGIC;
        EECLK : out STD_LOGIC;
        EECS : out STD_LOGIC;
        		
		b_int_rd : OUT std_logic;
		b_int_wr : OUT std_logic;
		b_data_wr : OUT std_logic_vector(31 downto 0);
		b_data_rd : IN std_logic_vector(31 downto 0); 
		b_addr : OUT std_logic_vector(31 downto 0);
		b_req_read_data : OUT STD_LOGIC;
		b_fifo_reset : OUT STD_LOGIC;
		b_input_fifo_empty : IN STD_LOGIC;
		b_fifo_address_full : IN STD_LOGIC;
		reset_fifo_address_only : OUT STD_LOGIC
		);
	END COMPONENT;
	
	

	
	-- SEGNALI INTERNI
			  
	signal  int_rd 	: STD_LOGIC;
	signal  int_wr 	: STD_LOGIC;
	signal  data_rd 	: STD_LOGIC_VECTOR(31 downto 0) := x"00000000";
	signal  data_wr 	: STD_LOGIC_VECTOR(31 downto 0);
	signal  aaddr 		: STD_LOGIC_VECTOR(31 downto 0);
	
	signal  addr_wrt		: STD_LOGIC;
	signal  addr_empty 	: STD_LOGIC;
	
	signal  BUS_ADDR 		: STD_LOGIC_VECTOR(31 downto 0) := x"00000000";
	signal  BUS_DATA_WR 	: STD_LOGIC_VECTOR(31 downto 0) := x"00000000";
	signal  BUS_DATA_RD 	: STD_LOGIC_VECTOR(31 downto 0) := x"00000000";
	signal  BUS_INT_RD 	: STD_LOGIC:='0';
	signal  BUS_INT_WR 	: STD_LOGIC:='0';
	signal  BUS_DATASTROBE: STD_LOGIC:='0';
	signal  i_BUS_DATASTROBE: STD_LOGIC_vector(2 downto 0):= (others => '0');
	
	signal  req_read_data : STD_LOGIC; 

	signal  SYNC_INT_RD 	: STD_LOGIC:='0';
	signal  SYNC_INT_WR 	: STD_LOGIC:='0';
	signal  oSYNC_INT_WR 	: STD_LOGIC:='0';
	
	signal CLK : STD_LOGIC;
	
	signal reset : std_logic;
	
	signal invFTDI_CLK : STD_LOGIC := '0';
	
	signal fifo_reset : std_logic;
	signal fifo_reset2 : std_logic;
	signal fifo_reset3 : std_logic;
	
	signal input_fifo_empty :  STD_LOGIC :='0';
	
	signal fifo_address_full : STD_LOGIC := '0';
	
	signal data_read_full : STD_LOGIC := '0';
	
	signal not_full_and_pending : STD_LOGIC := '0';
	signal pending : STD_LOGIC := '0';
	
	signal i_f_MODE : STD_LOGIC := '0';
	
	signal f_BUS_DATASTROBE :  std_logic;
    signal f_BUS_DATA_RD : std_logic_vector(31 downto 0);
    signal f_BUS_ADDR :  std_logic_vector(31 downto 0);
    signal f_BUS_INT_RD : std_logic;
    signal f_BUS_INT_WR : std_logic;
    signal f_BUS_DATA_WR :  std_logic_vector(31 downto 0);
    signal f_ENDIAN			 :  STD_LOGIC := '0';			
    
    
    signal wreg				 :  STD_LOGIC_VECTOR(31 downto 0);
    signal addr              : STD_LOGIC_VECTOR(31 downto 0);
    signal f_BUS_DATASTROBE_REG : std_logic := '0';
    signal f_BUS_DATA_RD_REG :  STD_LOGIC_VECTOR(31 downto 0);
    
    signal reset_fifo_address_only : STD_LOGIC;
    signal rd_fifo_wr : STD_LOGIC := '0';
    signal addr_fifo_rd : STD_LOGIC := '0';
    
    signal st_read : std_logic_vector (3 downto 0) := x"0";
	
	signal fifo_reset3b : std_logic;
    
    ATTRIBUTE MARK_DEBUG : string;
attribute MARK_DEBUG of int_rd: signal is "true";	
attribute MARK_DEBUG of int_wr: signal is "true";	
attribute MARK_DEBUG of data_rd: signal is "true";	
attribute MARK_DEBUG of data_wr: signal is "true";	
attribute MARK_DEBUG of addr: signal is "true";	
--
attribute MARK_DEBUG of BUS_ADDR: signal is "true";	
attribute MARK_DEBUG of BUS_DATA_WR: signal is "true";	
attribute MARK_DEBUG of f_BUS_DATA_WR: signal is "true";
attribute MARK_DEBUG of BUS_DATA_RD: signal is "true";	
attribute MARK_DEBUG of BUS_INT_RD: signal is "true";	
attribute MARK_DEBUG of BUS_INT_WR: signal is "true";	
attribute MARK_DEBUG of BUS_DATASTROBE: signal is "true";	

attribute MARK_DEBUG of fifo_reset2: signal is "true";	
attribute MARK_DEBUG of fifo_reset3: signal is "true";	
attribute MARK_DEBUG of addr_wrt: signal is "true";	
attribute MARK_DEBUG of data_read_full: signal is "true";	
attribute MARK_DEBUG of pending: signal is "true";	
attribute MARK_DEBUG of addr_empty: signal is "true";	
attribute MARK_DEBUG of not_full_and_pending: signal is "true";	
attribute MARK_DEBUG of SYNC_INT_RD: signal is "true";	
attribute MARK_DEBUG of SYNC_INT_WR: signal is "true";	
attribute MARK_DEBUG of oSYNC_INT_WR: signal is "true";	
attribute MARK_DEBUG of st_read: signal is "true";	
attribute MARK_DEBUG of addr_fifo_rd: signal is "true";	
attribute MARK_DEBUG of rd_fifo_wr: signal is "true";	

COMPONENT ila_1 IS
PORT (
clk : IN STD_LOGIC;


probe0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    probe1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    probe2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    probe3 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe4 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe5 : IN STD_LOGIC_VECTOR(0 DOWNTO 0)
);
END COMPONENT;

begin

	
	
-- ila_1_i :  ila_1
-- PORT MAP(
    -- clk => clk, 
    -- probe0 => f_BUS_ADDR,
    -- probe1 => f_BUS_DATA_WR,
    -- probe2 => f_BUS_DATA_RD,
    -- probe3(0) => f_BUS_INT_WR,
    -- probe4(0) => f_BUS_INT_RD,
    -- probe5(0) => f_BUS_DATASTROBE
-- );


	invFTDI_CLK <=  FTDI_CLK;



	Inst_ftdi245: ftdi245 PORT MAP(
		reset => reset,
		FTDI_ADBUS => FTDI_ADBUS,
		FTDI_RXFN => FTDI_RXFN ,
		FTDI_TXEN => FTDI_TXEN,
		FTDI_RDN => FTDI_RDN,
		FTDI_TXN => FTDI_TXN,
		FTDI_CLK => invFTDI_CLK,
		FTDI_OEN => FTDI_OEN,
		FTDI_SIWU => FTDI_SIWU,
		
	    EEMOSI => EEMOSI,
        EEMISO => EEMISO,
        EECLK => EECLK,
        EECS => EECS,    		
		
		b_int_rd => int_rd,
		b_int_wr => int_wr,
		b_data_wr => data_wr,
		b_data_rd => data_rd,
		b_addr => aaddr,
		b_req_read_data => req_read_data,
		b_fifo_reset => fifo_reset,
		b_input_fifo_empty => input_fifo_empty,
		b_fifo_address_full => fifo_address_full,
		reset_fifo_address_only => reset_fifo_address_only 
	);


	addr_wrt <= int_rd or int_wr;
	
	fifo_reset2 <= reset or fifo_reset;
	fifo_reset3 <= fifo_reset2 or reset_fifo_address_only;
	
	ADDRESS_FIFO : FTDI_FIFOs
		port map (
			rst => fifo_reset3,
			wr_clk => invFTDI_CLK,
			rd_clk => clk,
			din(33) => int_rd,
			din(32) => int_wr,
			din(31 downto 0) => aaddr,
			wr_en => addr_wrt,
			rd_en => addr_fifo_rd,--not_full_and_pending,
			dout(33) => SYNC_INT_RD,
			dout(32) => SYNC_INT_WR,
			dout(31 downto 0) => BUS_ADDR,
			full => open,
			empty => addr_empty,
			prog_full => fifo_address_full
			);

	--not_full_and_pending <= (not data_read_full) and (not pending);
	--BUS_INT_RD <= SYNC_INT_RD and (not addr_empty) and (not_full_and_pending);
	--oSYNC_INT_WR <= SYNC_INT_WR and (not addr_empty) and (not_full_and_pending);
	
	 
	--led <= BUS_INT_RD or BUS_INT_WR;

	DATAWRITE_FIFO : FTDI_FIFOs
		port map (
			rst => fifo_reset2,
			wr_clk => invFTDI_CLK,
			rd_clk => clk,
			din(33 downto 32) => "00",
			din(31 downto 0) => data_wr,
			wr_en => int_wr,
			rd_en => '1',
			dout(31 downto 0) => BUS_DATA_WR,
			dout(33 downto 32) => open,
			full => open,
			empty => open);


	DATA_READ_FIFO : FTDI_FIFOs
		port map (
			rst => fifo_reset2,
			wr_clk => clk,
			rd_clk => invFTDI_CLK,
			din(33 downto 32) => "00",
			din(31 downto 0) => BUS_DATA_RD,
			wr_en => rd_fifo_wr,--BUS_DATASTROBE,
			rd_en => req_read_data,
			dout(31 downto 0) => data_rd,
			dout(33 downto 32) => open,
			full => open,
			prog_full => data_read_full,
			empty => input_fifo_empty);


	CLK <= f_CLK;
	reset <= f_RESET;


	-- i_f_MODE <= f_MODE;--'0' when BUS_ADDR(31) = '1' else '1';--f_MODE;
	
	f_BUS_ADDR <= BUS_ADDR;
	f_BUS_INT_RD <= BUS_INT_RD;
	BUS_DATASTROBE <=  i_BUS_DATASTROBE(0);--f_BUS_DATASTROBE when i_f_MODE = '0' else i_BUS_DATASTROBE(0);
	BUS_DATA_RD <= f_BUS_DATA_RD(7 downto 0) & f_BUS_DATA_RD(15 downto 8) & f_BUS_DATA_RD(23 downto 16) & f_BUS_DATA_RD(31 downto 24);--f_BUS_DATA_RD when f_ENDIAN = '0' else f_BUS_DATA_RD(7 downto 0) & f_BUS_DATA_RD(15 downto 8) & f_BUS_DATA_RD(23 downto 16) & f_BUS_DATA_RD(31 downto 24);
	
	f_BUS_INT_WR <= BUS_INT_WR;
	f_BUS_DATA_WR <=BUS_DATA_WR(7 downto 0) & BUS_DATA_WR(15 downto 8) & BUS_DATA_WR(23 downto 16) & BUS_DATA_WR(31 downto 24); -- BUS_DATA_WR when f_ENDIAN = '0' else BUS_DATA_WR(7 downto 0) & BUS_DATA_WR(15 downto 8) & BUS_DATA_WR(23 downto 16) & BUS_DATA_WR(31 downto 24);
	
	
--	f_BUS_DATA_RD <= f_BUS_DATA_RD_REG;
--	f_BUS_DATASTROBE <= f_BUS_DATASTROBE_REG;
	
BUS_Spectrum_0_R_INT(0) <= f_BUS_INT_RD when (addr >= x"00000000" And addr < x"00010000") else '0';
BUS_Spectrum_0_READ_ADDRESS <= BUS_ADDR(15 downto 0) when (addr >= x"00000000" And addr < x"00010000") else (others => '0');BUS_Oscilloscope_0_R_INT(0) <= f_BUS_INT_RD when (addr >= x"00014000" And addr < x"00018000") else '0';
BUS_Oscilloscope_0_READ_ADDRESS <= BUS_ADDR(13 downto 0) when (addr >= x"00014000" And addr < x"00018000") else (others => '0');
f_BUS_DATA_RD <= BUS_Test_0_READ_DATA when  (addr >= x"FFFD0000" And addr < x"FFFDFFFF") else 
 BUS_FLASH_0_READ_DATA when (addr >= x"FFFE0000" And addr < x"FFFEE000") else 
BUS_Spectrum_0_READ_DATA  when  addr >= x"00000000" and addr < x"00010000" else 
BUS_Oscilloscope_0_READ_DATA  when  addr >= x"00014000" and addr < x"00018000" else 
 f_BUS_DATA_RD_REG;
 f_BUS_DATASTROBE <=BUS_Test_0_VLD(0) when  (addr >= x"FFFD0000" And addr < x"FFFDFFFF") else 
BUS_FLASH_0_VLD(0) when (addr >= x"FFFE0000" And addr < x"FFFEE000") else 
 BUS_Spectrum_0_VLD(0) when  addr >= x"00000000" and addr < x"00010000" else 
 BUS_Oscilloscope_0_VLD(0) when  addr >= x"00014000" and addr < x"00018000" else 
 f_BUS_DATASTROBE_REG;	

	BUS_FLASH_0_R_INT(0) <= f_BUS_INT_RD when (addr >= x"FFFE0000" And addr < x"FFFEE000") else '0';
    BUS_Test_0_R_INT(0) <= f_BUS_INT_RD when (addr >= x"FFFD0000" And addr < x"FFFDFFFF") else '0';
                            
    
    BUS_Test_0_ADDRESS  <=  BUS_ADDR(15 downto 0) when (addr >= x"FFFD0000" And addr < x"FFFDFFFF") else (others => '0');
    BUS_FLASH_0_ADDRESS  <= BUS_ADDR(15 downto 0) when (addr >= x"FFFE0000" And addr < x"FFFEE000") else (others => '0');
    
    BUS_Test_0_WRITE_DATA  <= f_BUS_DATA_WR;
    BUS_FLASH_0_WRITE_DATA  <= f_BUS_DATA_WR;
    
    
    BUS_Test_0_W_INT (0) <=  f_BUS_INT_WR when (addr >= x"FFFD0000" And addr < x"FFFDFFFF") else '0';
    BUS_FLASH_0_W_INT (0) <=  f_BUS_INT_WR when (addr >= x"FFFE0000" And addr < x"FFFEE000") else '0';
   
	
        wreg <= f_BUS_DATA_WR;
        addr <= f_BUS_ADDR;
        
        register_manager : process(clk)
            variable rreg    :  STD_LOGIC_VECTOR(31 downto 0);
        begin
            if reset='1' then
	BUS_Spectrum_0_W_INT <= "0";
		INT_Spectrum_0_STATUS_RD <= "0";
		REG_Spectrum_0_CONFIG_WR <= (others => '0');
		INT_Spectrum_0_CONFIG_WR <= "0";
		REG_Spectrum_0_CONFIG_LIMIT_WR <= (others => '0');
		INT_Spectrum_0_CONFIG_LIMIT_WR <= "0";
		REG_Spectrum_0_CONFIG_REBIN_WR <= (others => '0');
		INT_Spectrum_0_CONFIG_REBIN_WR <= "0";
		REG_Spectrum_0_CONFIG_MIN_WR <= (others => '0');
		INT_Spectrum_0_CONFIG_MIN_WR <= "0";
		REG_Spectrum_0_CONFIG_MAX_WR <= (others => '0');
		INT_Spectrum_0_CONFIG_MAX_WR <= "0";
		REG_T_OFFSET_WR <= (others => '0');
		INT_T_OFFSET_WR <= "0";
		INT_T_OFFSET_RD <= "0";
		REG_T_THRS_WR <= (others => '0');
		INT_T_THRS_WR <= "0";
		INT_T_THRS_RD <= "0";
		REG_T_TRIG_K_WR <= (others => '0');
		INT_T_TRIG_K_WR <= "0";
		INT_T_TRIG_K_RD <= "0";
		REG_T_TRIG_M_WR <= (others => '0');
		INT_T_TRIG_M_WR <= "0";
		INT_T_TRIG_M_RD <= "0";
		REG_T_TRAP_K_WR <= (others => '0');
		INT_T_TRAP_K_WR <= "0";
		INT_T_TRAP_K_RD <= "0";
		REG_T_DECONV_M_WR <= (others => '0');
		INT_T_DECONV_M_WR <= "0";
		INT_T_DECONV_M_RD <= "0";
		REG_T_TRAP_GAIN_WR <= (others => '0');
		INT_T_TRAP_GAIN_WR <= "0";
		INT_T_TRAP_GAIN_RD <= "0";
		REG_T_BL_LEN_WR <= (others => '0');
		INT_T_BL_LEN_WR <= "0";
		INT_T_BL_LEN_RD <= "0";
		REG_T_BL_INIB_WR <= (others => '0');
		INT_T_BL_INIB_WR <= "0";
		INT_T_BL_INIB_RD <= "0";
		REG_T_SAMPLE_POS_WR <= (others => '0');
		INT_T_SAMPLE_POS_WR <= "0";
		INT_T_SAMPLE_POS_RD <= "0";
		REG_T_RUN_CFG_WR <= (others => '0');
		INT_T_RUN_CFG_WR <= "0";
		INT_T_RUN_CFG_RD <= "0";
	BUS_Oscilloscope_0_W_INT <= "0";
		INT_Oscilloscope_0_READ_STATUS_RD <= "0";
		INT_Oscilloscope_0_READ_POSITION_RD <= "0";
		REG_Oscilloscope_0_CONFIG_TRIGGER_MODE_WR <= (others => '0');
		INT_Oscilloscope_0_CONFIG_TRIGGER_MODE_WR <= "0";
		REG_Oscilloscope_0_CONFIG_PRETRIGGER_WR <= (others => '0');
		INT_Oscilloscope_0_CONFIG_PRETRIGGER_WR <= "0";
		REG_Oscilloscope_0_CONFIG_TRIGGER_LEVEL_WR <= (others => '0');
		INT_Oscilloscope_0_CONFIG_TRIGGER_LEVEL_WR <= "0";
		REG_Oscilloscope_0_CONFIG_ARM_WR <= (others => '0');
		INT_Oscilloscope_0_CONFIG_ARM_WR <= "0";
		REG_Oscilloscope_0_CONFIG_DECIMATOR_WR <= (others => '0');
		INT_Oscilloscope_0_CONFIG_DECIMATOR_WR <= "0";
				
            REG_OFFSET_WR <= (others => '0');
            INT_OFFSET_WR <= "0";
            INT_OFFSET_RD <= "0";
            INT_FLASH_CNTR_RD <= "0";
            INT_FLASH_CNTR_RD <= "0";
            INT_FLASH_ADDRESS_WR <= "0";
            INT_FLASH_ADDRESS_RD <= "0";
			
            f_BUS_DATASTROBE_REG <= '0';
                
            elsif rising_edge(clk) then
	BUS_Spectrum_0_W_INT <= "0";
		INT_Spectrum_0_STATUS_RD <= "0";
		INT_Spectrum_0_CONFIG_WR <= "0";
		INT_Spectrum_0_CONFIG_LIMIT_WR <= "0";
		INT_Spectrum_0_CONFIG_REBIN_WR <= "0";
		INT_Spectrum_0_CONFIG_MIN_WR <= "0";
		INT_Spectrum_0_CONFIG_MAX_WR <= "0";
		INT_T_OFFSET_WR <= "0";
		INT_T_OFFSET_RD <= "0";
		INT_T_THRS_WR <= "0";
		INT_T_THRS_RD <= "0";
		INT_T_TRIG_K_WR <= "0";
		INT_T_TRIG_K_RD <= "0";
		INT_T_TRIG_M_WR <= "0";
		INT_T_TRIG_M_RD <= "0";
		INT_T_TRAP_K_WR <= "0";
		INT_T_TRAP_K_RD <= "0";
		INT_T_DECONV_M_WR <= "0";
		INT_T_DECONV_M_RD <= "0";
		INT_T_TRAP_GAIN_WR <= "0";
		INT_T_TRAP_GAIN_RD <= "0";
		INT_T_BL_LEN_WR <= "0";
		INT_T_BL_LEN_RD <= "0";
		INT_T_BL_INIB_WR <= "0";
		INT_T_BL_INIB_RD <= "0";
		INT_T_SAMPLE_POS_WR <= "0";
		INT_T_SAMPLE_POS_RD <= "0";
		INT_T_RUN_CFG_WR <= "0";
		INT_T_RUN_CFG_RD <= "0";
	BUS_Oscilloscope_0_W_INT <= "0";
		INT_Oscilloscope_0_READ_STATUS_RD <= "0";
		INT_Oscilloscope_0_READ_POSITION_RD <= "0";
		INT_Oscilloscope_0_CONFIG_TRIGGER_MODE_WR <= "0";
		INT_Oscilloscope_0_CONFIG_PRETRIGGER_WR <= "0";
		INT_Oscilloscope_0_CONFIG_TRIGGER_LEVEL_WR <= "0";
		INT_Oscilloscope_0_CONFIG_ARM_WR <= "0";
		INT_Oscilloscope_0_CONFIG_DECIMATOR_WR <= "0";
  			
            INT_OFFSET_WR <= "0";
            INT_OFFSET_RD <= "0";
			INT_FLASH_CNTR_RD <= "0";
            INT_FLASH_CNTR_RD <= "0";
            INT_FLASH_ADDRESS_WR <= "0";
            INT_FLASH_ADDRESS_RD <= "0";
            INT_IO_WR <="0";
            INT_IO_RD <="0";
                        
                
                
               if f_BUS_INT_WR = '1' then
        
                
                    if addr = x"FFFFFFF9" then
                        REG_OFFSET_WR <= wreg; 
                        INT_OFFSET_WR <= "1"; 
                    end if;
                    
                    if addr = x"FFFFFFFB" then
                        REG_IO_WR <= wreg; 
                        INT_IO_WR <= "1"; 
                    end if;      

				   if addr = x"FFFEF000"  then
					   REG_FLASH_CNTR_WR     <= wreg; 
					   INT_FLASH_CNTR_WR <= "1"; 
				   end if; 

				   if addr = x"FFFEF001"  then
					   REG_FLASH_ADDRESS_WR     <= wreg; 
					   INT_FLASH_ADDRESS_WR <= "1"; 
				   end if;  					
         
		If addr >= x"00000000" And addr < x"00010000" Then
			BUS_Spectrum_0_WRITE_DATA <= wreg; 
			BUS_Spectrum_0_W_INT <= "1"; 
		End If;
		if addr = x"00010001" then
			REG_Spectrum_0_CONFIG_WR <= wreg; 
			INT_Spectrum_0_CONFIG_WR <= "1"; 
		end if;
		if addr = x"00010002" then
			REG_Spectrum_0_CONFIG_LIMIT_WR <= wreg; 
			INT_Spectrum_0_CONFIG_LIMIT_WR <= "1"; 
		end if;
		if addr = x"00010003" then
			REG_Spectrum_0_CONFIG_REBIN_WR <= wreg; 
			INT_Spectrum_0_CONFIG_REBIN_WR <= "1"; 
		end if;
		if addr = x"00010004" then
			REG_Spectrum_0_CONFIG_MIN_WR <= wreg; 
			INT_Spectrum_0_CONFIG_MIN_WR <= "1"; 
		end if;
		if addr = x"00010005" then
			REG_Spectrum_0_CONFIG_MAX_WR <= wreg; 
			INT_Spectrum_0_CONFIG_MAX_WR <= "1"; 
		end if;
		if addr = x"00010006" then
			REG_T_OFFSET_WR <= wreg; 
			INT_T_OFFSET_WR <= "1"; 
		end if;
		if addr = x"00010007" then
			REG_T_THRS_WR <= wreg; 
			INT_T_THRS_WR <= "1"; 
		end if;
		if addr = x"00010008" then
			REG_T_TRIG_K_WR <= wreg; 
			INT_T_TRIG_K_WR <= "1"; 
		end if;
		if addr = x"00010009" then
			REG_T_TRIG_M_WR <= wreg; 
			INT_T_TRIG_M_WR <= "1"; 
		end if;
		if addr = x"0001000A" then
			REG_T_TRAP_K_WR <= wreg; 
			INT_T_TRAP_K_WR <= "1"; 
		end if;
		if addr = x"0001000B" then
			REG_T_DECONV_M_WR <= wreg; 
			INT_T_DECONV_M_WR <= "1"; 
		end if;
		if addr = x"0001000C" then
			REG_T_TRAP_GAIN_WR <= wreg; 
			INT_T_TRAP_GAIN_WR <= "1"; 
		end if;
		if addr = x"0001000D" then
			REG_T_BL_LEN_WR <= wreg; 
			INT_T_BL_LEN_WR <= "1"; 
		end if;
		if addr = x"0001000E" then
			REG_T_BL_INIB_WR <= wreg; 
			INT_T_BL_INIB_WR <= "1"; 
		end if;
		if addr = x"0001000F" then
			REG_T_SAMPLE_POS_WR <= wreg; 
			INT_T_SAMPLE_POS_WR <= "1"; 
		end if;
		if addr = x"00010010" then
			REG_T_RUN_CFG_WR <= wreg; 
			INT_T_RUN_CFG_WR <= "1"; 
		end if;
		If addr >= x"00014000" And addr < x"00018000" Then
			BUS_Oscilloscope_0_WRITE_DATA <= wreg; 
			BUS_Oscilloscope_0_W_INT <= "1"; 
		End If;
		if addr = x"00018002" then
			REG_Oscilloscope_0_CONFIG_TRIGGER_MODE_WR <= wreg; 
			INT_Oscilloscope_0_CONFIG_TRIGGER_MODE_WR <= "1"; 
		end if;
		if addr = x"00018003" then
			REG_Oscilloscope_0_CONFIG_PRETRIGGER_WR <= wreg; 
			INT_Oscilloscope_0_CONFIG_PRETRIGGER_WR <= "1"; 
		end if;
		if addr = x"00018004" then
			REG_Oscilloscope_0_CONFIG_TRIGGER_LEVEL_WR <= wreg; 
			INT_Oscilloscope_0_CONFIG_TRIGGER_LEVEL_WR <= "1"; 
		end if;
		if addr = x"00018005" then
			REG_Oscilloscope_0_CONFIG_ARM_WR <= wreg; 
			INT_Oscilloscope_0_CONFIG_ARM_WR <= "1"; 
		end if;
		if addr = x"00018006" then
			REG_Oscilloscope_0_CONFIG_DECIMATOR_WR <= wreg; 
			INT_Oscilloscope_0_CONFIG_DECIMATOR_WR <= "1"; 
		end if;

		 
                end if;
        
        f_BUS_DATASTROBE_REG <= '1';
                if f_BUS_INT_RD = '1' then
   
                    rreg := x"DEADBEEF";
 
 		if addr = x"00010000" then
			rreg := REG_Spectrum_0_STATUS_RD; 
		End If;
		if addr = x"00010001" then
			rreg := REG_Spectrum_0_CONFIG_RD; 
		End If;
		if addr = x"00010002" then
			rreg := REG_Spectrum_0_CONFIG_LIMIT_RD; 
		End If;
		if addr = x"00010003" then
			rreg := REG_Spectrum_0_CONFIG_REBIN_RD; 
		End If;
		if addr = x"00010004" then
			rreg := REG_Spectrum_0_CONFIG_MIN_RD; 
		End If;
		if addr = x"00010005" then
			rreg := REG_Spectrum_0_CONFIG_MAX_RD; 
		End If;
		if addr = x"00010006" then
			rreg := REG_T_OFFSET_RD; 
		End If;
		if addr = x"00010007" then
			rreg := REG_T_THRS_RD; 
		End If;
		if addr = x"00010008" then
			rreg := REG_T_TRIG_K_RD; 
		End If;
		if addr = x"00010009" then
			rreg := REG_T_TRIG_M_RD; 
		End If;
		if addr = x"0001000A" then
			rreg := REG_T_TRAP_K_RD; 
		End If;
		if addr = x"0001000B" then
			rreg := REG_T_DECONV_M_RD; 
		End If;
		if addr = x"0001000C" then
			rreg := REG_T_TRAP_GAIN_RD; 
		End If;
		if addr = x"0001000D" then
			rreg := REG_T_BL_LEN_RD; 
		End If;
		if addr = x"0001000E" then
			rreg := REG_T_BL_INIB_RD; 
		End If;
		if addr = x"0001000F" then
			rreg := REG_T_SAMPLE_POS_RD; 
		End If;
		if addr = x"00010010" then
			rreg := REG_T_RUN_CFG_RD; 
		End If;
		if addr = x"00018000" then
			rreg := REG_Oscilloscope_0_READ_STATUS_RD; 
		End If;
		if addr = x"00018001" then
			rreg := REG_Oscilloscope_0_READ_POSITION_RD; 
		End If;
		if addr = x"00018002" then
			rreg := REG_Oscilloscope_0_CONFIG_TRIGGER_MODE_RD; 
		End If;
		if addr = x"00018003" then
			rreg := REG_Oscilloscope_0_CONFIG_PRETRIGGER_RD; 
		End If;
		if addr = x"00018004" then
			rreg := REG_Oscilloscope_0_CONFIG_TRIGGER_LEVEL_RD; 
		End If;
		if addr = x"00018005" then
			rreg := REG_Oscilloscope_0_CONFIG_ARM_RD; 
		End If;
		if addr = x"00018006" then
			rreg := REG_Oscilloscope_0_CONFIG_DECIMATOR_RD; 
		End If;
	
 
                    if addr = x"FFFFFFF9" then
                        rreg := REG_OFFSET_RD; 
                    End If;    
                    
                    if addr = x"FFFFFFFB" then
                        rreg := REG_IO_RD; 
                    End If;                     
                    
                    if addr = x"FFFFFFF8" then
                        rreg := x"00001260"; 
                    End If;    
                    if addr = x"FFFFFFFE" then
                        rreg := x"21032100"; 
                    End If; 
                    
                   
                    if addr = x"FFFFFFFA" then
                        rreg := REG_FIRMWARE_BUILD;
                    End If;                  
               
                    if addr = x"FFFEFFFC" then
                        rreg := x"20210321";
                    End If;
    
                    if addr = x"FFFFFFFB" then
                        rreg := x"00001260";
                    End If;                
                    
                    if addr = x"FFFFFFFC" then
                        rreg := REG_UNIQUE_RD;
                    End If;                
					if addr = x"FFFEF000" then
						rreg := REG_FLASH_CNTR_RD;
						INT_FLASH_CNTR_RD <= "1"; 
					End If;    
					if addr = x"FFFEF001" then
						rreg := REG_FLASH_ADDRESS_RD;
						INT_FLASH_CNTR_RD <= "1"; 
					End If;                   
					if addr = x"FFFEFFFF" then
						rreg := x"1234ABBA";
						INT_FLASH_CNTR_RD <= "1"; 
					End If;      					
                    
                    f_BUS_DATA_RD_REG <= rreg;
                end if;
    
            end if;
        end process;
        

        xpm_cdc_async_rst_inst: xpm_cdc_async_rst
          generic map (
        
            -- Common module parameters
             DEST_SYNC_FF    => 4, -- integer; range: 2-10
             INIT_SYNC_FF    => 0, -- integer; 0=disable simulation init values, 1=enable simulation init values
             RST_ACTIVE_HIGH => 0  -- integer; 0=active low reset, 1=active high reset
          )
          port map (
        
             src_arst  => fifo_reset3,
             dest_clk  => clk,
             dest_arst => fifo_reset3b
          );       

    rdp : process(clk)
    begin
        if fifo_reset3b = '1' then
            BUS_INT_RD <= '0';
            rd_fifo_wr <= '0';
            addr_fifo_rd <= '0';
            BUS_INT_WR <= '0';
            st_read <= x"0";
        
        elsif rising_edge(clk) then 
            BUS_INT_RD <= '0';
            rd_fifo_wr <= '0';
            addr_fifo_rd <= '0';
            BUS_INT_WR <= '0';
            case st_read is 
                when x"0" =>
                    if addr_empty = '0' and data_read_full ='0' then
                        st_read <= x"1";
                    end if;
                when x"1" =>
                    if SYNC_INT_WR = '1' then
                        addr_fifo_rd <= '1';
                        BUS_INT_WR <= '1';
                        st_read <= x"0";
                    end if;
                    if SYNC_INT_RD = '1' then
                        st_read <= x"2";
                    end if;
                when x"2" =>
                    st_read <= x"3";
                when x"3" =>
                        st_read <= x"4";

                when x"4" =>
                    if f_BUS_DATASTROBE = '1' then
                        BUS_INT_RD <= '1';
                        st_read <= x"5";
                    end if;                    
                when x"5" =>
                    rd_fifo_wr <= '1';
                    addr_fifo_rd <= '1';
                    st_read <= x"6";
                
				when x"6" =>
					st_read <= x"0";
                    
    

                when others =>
            end case;
        end if;
    end process;      

        
    -- rdp : process(clk)
    -- begin
        -- if fifo_reset3 = '1' then
            -- BUS_INT_RD <= '0';
            -- rd_fifo_wr <= '0';
            -- addr_fifo_rd <= '0';
            -- BUS_INT_WR <= '0';
            -- st_read <= x"0";
        
        -- elsif rising_edge(clk) then 
            -- BUS_INT_RD <= '0';
            -- rd_fifo_wr <= '0';
            -- addr_fifo_rd <= '0';
            -- BUS_INT_WR <= '0';
            -- case st_read is 
                -- when x"0" =>
                    -- if addr_empty = '0' and data_read_full ='0' then
                        -- addr_fifo_rd <= '1';
                        -- st_read <= x"1";
                    -- end if;
                -- when x"1" =>
                    -- if SYNC_INT_WR = '1' then
                        -- BUS_INT_WR <= '1';
                        -- st_read <= x"0";
                    -- end if;
                    -- if SYNC_INT_RD = '1' then
                        -- st_read <= x"2";
                    -- end if;
                -- when x"2" =>
                    -- if f_BUS_DATASTROBE = '1' then
                        -- BUS_INT_RD <= '1';
                        -- st_read <= x"3";
                    -- end if;
                -- when x"3" =>
                    -- rd_fifo_wr <= '1';
                    -- st_read <= x"0";
                -- when others =>
            -- end case;
        -- end if;
    -- end process;        


	end Behavioral;

