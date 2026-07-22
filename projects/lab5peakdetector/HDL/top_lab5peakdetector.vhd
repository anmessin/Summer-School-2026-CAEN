----------------------------------------------------------------------------------
-- Company: 	Nuclear Instruments SRL
-- Engineer: 	Andrea Abba
-- 
-- Create Date: 07.06.2020 10:24:18
-- Design Name: SciDK Scicompiler Development Kit
-- Module Name: TOP_lab5peakdetector
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
-- http://www.nuclearinstruments.eu
-- Nuclear Instruments SRL, via lecco 16, Lambrugo (CO), ITALY
-- info@nuclearinstruments.eu
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.std_logic_misc.all;
use ieee.math_real.all;
library UNISIM;
use UNISIM.VComponents.all;

Library xpm;
use xpm.vcomponents.all;
    
entity TOP_lab5peakdetector is
    Port (  
		    
			
			--input clock
			clk_100 : in STD_LOGIC;
			
			--adc
			ADC_A_IN : in STD_LOGIC_VECTOR (13 downto 0);
			ADC_B_IN : in STD_LOGIC_VECTOR (13 downto 0);
			CLK_TO_ADC_A : out std_logic;
			OE_ADC_A : out std_logic;
			SHND_ADC_A : out std_logic;
			CLK_TO_ADC_B : out std_logic;
			OE_ADC_B : out std_logic;
			SHND_ADC_B : out std_logic;
			
			--USB Interface
			FTDI_ADBUS : inout STD_LOGIC_VECTOR ( 7 downto 0 );
			FTDI_CLK : in STD_LOGIC;
			FTDI_OEN : out STD_LOGIC;
			FTDI_RDN : out STD_LOGIC;
			FTDI_RXFN : in STD_LOGIC;
			FTDI_SIWU : out STD_LOGIC;
			FTDI_TXEN : in STD_LOGIC;
			FTDI_TXN : out STD_LOGIC;
			
			--gpio
			led_0 : out STD_LOGIC_VECTOR(0 downto 0);
			led_1 : out STD_LOGIC_VECTOR(0 downto 0);
					
			gpio : inout STD_LOGIC_VECTOR ( 7 downto 0 );
			sw1 : in std_logic;
        
			--digital lemo
			lemo_a : inout STD_LOGIC;
			lemo_b : inout STD_LOGIC;
			lemo_dir_a : out STD_LOGIC;
			lemo_dir_b : out STD_LOGIC;
			lemo_oe : out STD_LOGIC;
        
			--boot switch
			boot_sw : in std_logic;
			boot_led : out STD_LOGIC;
        
			--i2c master
			IIC_0_scl : inout std_logic;
			IIC_0_sda : inout std_logic;
		
			  
			--security eeprom			  
			EEMOSI : out STD_LOGIC;
			EEMISO : in STD_LOGIC;
			EECLK : out STD_LOGIC;
			EECS : out STD_LOGIC
                              
                              
			  ); 
end TOP_lab5peakdetector;

architecture Behavioral of TOP_lab5peakdetector is
	attribute keep : string;     
	
	
	 component main_clk_gen 
    port
     ( 
        sample_clk : out std_logic;
        locked  : out std_logic;
        clk_in1 : in std_logic;
        clk_out2 : out std_logic
     );
     END COMPONENT;
	 
    COMPONENT ftdi245_cdc
    PORT(
        FTDI_RXFN : IN std_logic;
        FTDI_TXEN : IN std_logic;
        FTDI_CLK : IN std_logic;
        f_CLK : IN std_logic;
        f_RESET : IN std_logic;
        FTDI_ADBUS : INOUT std_logic_vector(7 downto 0);      
        FTDI_RDN : OUT std_logic;
        FTDI_TXN : OUT std_logic;
        FTDI_OEN : OUT std_logic;
        FTDI_SIWU : OUT std_logic;
		
	    EEMOSI : out STD_LOGIC;
        EEMISO : in STD_LOGIC;
        EECLK : out STD_LOGIC;
        EECS : out STD_LOGIC;
		
		-- Register interface          
				REG_EL_M_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_EL_M_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_EL_M_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_EL_M_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_PEAK_DELAY_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_PEAK_DELAY_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_PEAK_DELAY_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_PEAK_DELAY_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_BL_M_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_BL_M_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_BL_M_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_BL_M_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_BL_HOLD_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_BL_HOLD_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_BL_HOLD_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_BL_HOLD_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
	BUS_page_subdesign_1_READ_ADDRESS : OUT STD_LOGIC_VECTOR(18 downto 0); 
	BUS_page_subdesign_1_READ_DATA : IN STD_LOGIC_VECTOR(31 downto 0); 
	BUS_page_subdesign_1_WRITE_DATA : OUT STD_LOGIC_VECTOR(31 downto 0); 
	BUS_page_subdesign_1_W_INT : OUT STD_LOGIC_VECTOR(0 downto 0); 
	BUS_page_subdesign_1_R_INT : OUT STD_LOGIC_VECTOR(0 downto 0); 
	BUS_page_subdesign_1_VLD : IN STD_LOGIC_VECTOR(0 downto 0); 
	BUS_List_0_READ_DATA : IN STD_LOGIC_VECTOR(31 downto 0); 
	BUS_List_0_WRITE_DATA : OUT STD_LOGIC_VECTOR(31 downto 0); 
	BUS_List_0_W_INT : OUT STD_LOGIC_VECTOR(0 downto 0); 
	BUS_List_0_R_INT : OUT STD_LOGIC_VECTOR(0 downto 0); 
	BUS_List_0_VLD : IN STD_LOGIC_VECTOR(0 downto 0); 
		REG_List_0_STATUS_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		INT_List_0_STATUS_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_List_0_CONFIG_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_List_0_CONFIG_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_List_0_CONFIG_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_UNIQUE_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_UNIQUE_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
	

        
		REG_FIRMWARE_BUILD : IN STD_LOGIC_VECTOR(31 downto 0);
        
        
        REG_OFFSET_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
        REG_OFFSET_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
        INT_OFFSET_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
        INT_OFFSET_WR : OUT STD_LOGIC_VECTOR(0 downto 0);

        REG_IO_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
        REG_IO_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
        INT_IO_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
        INT_IO_WR : OUT STD_LOGIC_VECTOR(0 downto 0);
        
		--FLASH CONTROLLER   
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
    END COMPONENT;
    
    
    COMPONENT scidk_internal_i2c_manager is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           offset : in STD_LOGIC_VECTOR (15 downto 0);
           w_offset : in STD_LOGIC;
           sda : inout STD_LOGIC;
           scl : inout STD_LOGIC
           );
    end COMPONENT;

    

    signal sample_clk : std_logic;
    signal async_clk : std_logic_vector (0 downto 0) := "0";
    signal GlobalClock : std_logic_vector (0 downto 0) := "0";
    signal BUS_CLK : std_logic_vector (0 downto 0) := "0";
    signal GlobalReset : std_logic_vector (0 downto 0) := "0";       
	signal CLK_ACQ : std_logic_vector (0 downto 0) := "0";
	
    signal mcg_lock : std_logic;
    signal REG_OFFSET :  STD_LOGIC_VECTOR(31 downto 0); 
    signal REG_OFFSET_WR :  STD_LOGIC_VECTOR(0 downto 0); 
    
    signal REG_IO_RD : STD_LOGIC_VECTOR(31 downto 0); 
    signal REG_IO_WR : STD_LOGIC_VECTOR(31 downto 0); 
    
	signal BUS_Flash_0_READ_DATA :  STD_LOGIC_VECTOR(31 downto 0);
    signal BUS_Flash_0_ADDRESS :  STD_LOGIC_VECTOR(15 downto 0); 
    signal BUS_Flash_0_WRITE_DATA :  STD_LOGIC_VECTOR(31 downto 0); 
    signal BUS_Flash_0_W_INT :  STD_LOGIC_VECTOR(0 downto 0); 
    signal BUS_Flash_0_R_INT :  STD_LOGIC_VECTOR(0 downto 0); 
    signal BUS_Flash_0_VLD :  STD_LOGIC_VECTOR(0 downto 0);   
    
    signal REG_FLASH_CNTR_RD :  STD_LOGIC_VECTOR(31 downto 0); 
    signal REG_FLASH_CNTR_WR :  STD_LOGIC_VECTOR(31 downto 0); 
    signal INT_FLASH_CNTR_RD :  STD_LOGIC_VECTOR(0 downto 0); 
    signal INT_FLASH_CNTR_WR :  STD_LOGIC_VECTOR(0 downto 0); 
    
    signal REG_FLASH_ADDRESS_RD :  STD_LOGIC_VECTOR(31 downto 0); 
    signal REG_FLASH_ADDRESS_WR :  STD_LOGIC_VECTOR(31 downto 0); 
    signal INT_FLASH_ADDRESS_RD :  STD_LOGIC_VECTOR(0 downto 0); 
    signal INT_FLASH_ADDRESS_WR :  STD_LOGIC_VECTOR(0 downto 0);         
    
	signal BUS_Test_0_READ_DATA :  STD_LOGIC_VECTOR(31 downto 0);
    signal BUS_Test_0_ADDRESS :  STD_LOGIC_VECTOR(15 downto 0); 
    signal BUS_Test_0_WRITE_DATA :  STD_LOGIC_VECTOR(31 downto 0); 
    signal BUS_Test_0_W_INT :  STD_LOGIC_VECTOR(0 downto 0); 
    signal BUS_Test_0_R_INT :  STD_LOGIC_VECTOR(0 downto 0); 
    signal BUS_Test_0_VLD :  STD_LOGIC_VECTOR(0 downto 0) := "1";  	
	
	signal LEMO_0_A_OUT : std_logic_vector(0 downto 0);
    signal LEMO_0_A_IN : std_logic_vector(0 downto 0);
	signal LEMO_1_A_OUT : std_logic_vector(0 downto 0);
    signal LEMO_1_A_IN : std_logic_vector(0 downto 0);

    signal LEMO_0_DIRECTION : std_logic_vector(0 downto 0) := "0";
    signal LEMO_1_DIRECTION : std_logic_vector(0 downto 0) := "0";

    signal CLK_40 :  std_logic_vector(0 downto 0); 
	signal CLK_80 : std_logic_vector(0 downto 0); 
    signal CLK_160 :  std_logic_vector(0 downto 0);   
    signal CLK_320 : std_logic_vector(0 downto 0); 
	signal CLK_125 : std_logic_vector(0 downto 0);
	signal FAST_CLK_100 : std_logic_vector (0 downto 0) := "0";
	signal FAST_CLK_200 : std_logic_vector (0 downto 0) := "0";
	signal FAST_CLK_250 : std_logic_vector (0 downto 0) := "0";
	signal FAST_CLK_250_90 : std_logic_vector (0 downto 0) := "0";
	signal FAST_CLK_500 : std_logic_vector (0 downto 0) := "0";
	signal FAST_CLK_500_90 : std_logic_vector (0 downto 0) := "0";
	
	signal CHA0 : STD_LOGIC_VECTOR (13 downto 0);
	signal CHA1 : STD_LOGIC_VECTOR (13 downto 0);

	signal pw_led_counter : integer :=0;
	signal power_led_sig : std_logic := '1';


	COMPONENT CLK_125MHZ
	PORT (
	clk_out1 : OUT STD_LOGIC;
	clk_in1  : IN  STD_LOGIC
	);
	END COMPONENT;

	
	signal U0_A0 : std_logic_vector(15 downto 0);
signal U1_A1 : std_logic_vector(15 downto 0);
signal U2_out_0 : std_logic_vector(15 downto 0);
signal U3_out_0 : std_logic_vector(15 downto 0);
signal U4_out_0 : std_logic_vector(15 downto 0);
	signal U5_DATA_0 : std_logic_vector(55 downto 0);
	signal U5_DATA_VALID_0 : std_logic_vector(0 downto 0);
	signal U5_DATA_1 : std_logic_vector(55 downto 0);
	signal U5_DATA_VALID_1 : std_logic_vector(0 downto 0);

COMPONENT SUBPAGE_subdesign_1
PORT(
	AN : IN std_logic_vector(15 downto 0);
	DATA : OUT std_logic_vector(55 downto 0);
	DATA_VALID : OUT std_logic_vector(0 downto 0);
	TIMESTAMPO : IN std_logic_vector(39 downto 0);
	BL_M : IN std_logic_vector(15 downto 0);
	BL_HOLD : IN std_logic_vector(15 downto 0);
	PEAK_DELAY : IN std_logic_vector(15 downto 0);
	GlobalReset: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
	CLK_ACQ: in std_logic_vector (0 downto 0);
	BUS_CLK: in std_logic_vector (0 downto 0);
	CLK_40: in std_logic_vector (0 downto 0);
	CLK_50: in std_logic_vector (0 downto 0);
	CLK_80: in std_logic_vector (0 downto 0);
	clk_160: in std_logic_vector (0 downto 0);
	clk_320: in std_logic_vector (0 downto 0);
	clk_125: in std_logic_vector (0 downto 0);
	FAST_CLK_100: in std_logic_vector (0 downto 0);
	FAST_CLK_200: in std_logic_vector (0 downto 0);
	FAST_CLK_250: in std_logic_vector (0 downto 0);
	FAST_CLK_250_90: in std_logic_vector (0 downto 0);
	FAST_CLK_500: in std_logic_vector (0 downto 0);
	FAST_CLK_500_90: in std_logic_vector (0 downto 0);
	GlobalClock: in std_logic_vector (0 downto 0);
	async_clk: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
	BUS_READ_DATA : OUT STD_LOGIC_VECTOR(31 downto 0);
	BUS_ADDRESS : IN STD_LOGIC_VECTOR(31 downto 0); 
	BUS_WRITE_DATA : IN STD_LOGIC_VECTOR(31 downto 0);
	BUS_INT_RD : IN STD_LOGIC_VECTOR(0 downto 0); 
	BUS_INT_WR : IN STD_LOGIC_VECTOR(0 downto 0);
	BUS_VLD : OUT STD_LOGIC_VECTOR(0 downto 0));
END COMPONENT;
signal BUS_page_subdesign_1_0_READ_DATA: STD_LOGIC_VECTOR(31 downto 0);

signal BUS_page_subdesign_1_0_R_INT: STD_LOGIC_VECTOR(0 downto 0);

signal BUS_page_subdesign_1_0_W_INT: STD_LOGIC_VECTOR(0 downto 0);

signal BUS_page_subdesign_1_0_VLD: STD_LOGIC_VECTOR(0 downto 0);

signal BUS_page_subdesign_1_1_READ_DATA: STD_LOGIC_VECTOR(31 downto 0);

signal BUS_page_subdesign_1_1_R_INT: STD_LOGIC_VECTOR(0 downto 0);

signal BUS_page_subdesign_1_1_W_INT: STD_LOGIC_VECTOR(0 downto 0);

signal BUS_page_subdesign_1_1_VLD: STD_LOGIC_VECTOR(0 downto 0);

	signal U6_TIMESTAMP : STD_LOGIC_VECTOR(39 DOWNTO 0);

	COMPONENT TimestampGenerator
		GENERIC( 
			nbits : INTEGER := 40
		);
		PORT( 
			TIMESTAMP : out STD_LOGIC_VECTOR(nbits-1 downto 0);
			T0 : in STD_LOGIC;
			CLK_READ : in STD_LOGIC;
			ClkCounter : in STD_LOGIC
		);
	END COMPONENT;

	signal U7_AD : STD_LOGIC_VECTOR(63 DOWNTO 0);
	signal U7_DV_OUT : STD_LOGIC_VECTOR(0 DOWNTO 0);
	signal U7_busyin : STD_LOGIC_VECTOR(1 DOWNTO 0);

	COMPONENT arbiter_round_robbins_fifop
		GENERIC( 
			nbits : INTEGER := 56;
			nports : INTEGER := 2;
			timemax : INTEGER := 10;
			fifolength : INTEGER := 256
		);
		PORT( 
			data_in : in STD_LOGIC_VECTOR((nports*nbits)-1 downto 0);
			we : in STD_LOGIC_VECTOR(nports-1 downto 0);
			out_full : in STD_LOGIC_VECTOR(0 downto 0);
			CE : in STD_LOGIC_VECTOR(0 downto 0);
			CLK : in STD_LOGIC_VECTOR(0 downto 0);
			RESET : in STD_LOGIC_VECTOR(0 downto 0);
			out_data : out STD_LOGIC_VECTOR(nbits-1 downto 0);
			out_addr : out STD_LOGIC_VECTOR(7 downto 0);
			out_addr_data : out STD_LOGIC_VECTOR(8+nbits-1 downto 0);
			out_dv : out STD_LOGIC_VECTOR(0 downto 0);
			busy : out STD_LOGIC_VECTOR(nports-1 downto 0)
		);
	END COMPONENT;

	signal U8_BUSY : STD_LOGIC_VECTOR(0 DOWNTO 0);
	signal U8_CLEAR : STD_LOGIC_VECTOR(0 DOWNTO 0);
	signal BUS_List_0_READ_DATA : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal BUS_List_0_VLD : STD_LOGIC_VECTOR(0 DOWNTO 0);
	signal REG_List_0_STATUS_RD : STD_LOGIC_VECTOR(31 DOWNTO 0);

	COMPONENT listmodule
		GENERIC( 
			fifolength : INTEGER := 8192;
			bitsize : INTEGER := 64;
			channels : INTEGER := 1
		);
		PORT( 
			DATAIN : in STD_LOGIC_VECTOR((bitsize*channels)-1 downto 0);
			WE : in STD_LOGIC_VECTOR(0 downto 0);
			FULL : out STD_LOGIC_VECTOR(0 downto 0);
			BUSY : out STD_LOGIC_VECTOR(0 downto 0);
			RUNNING : out STD_LOGIC_VECTOR(0 downto 0);
			CLEAR : out STD_LOGIC_VECTOR(0 downto 0);
			RESET : in STD_LOGIC_VECTOR(0 downto 0);
			CLK_WRITE : in STD_LOGIC_VECTOR(0 downto 0);
			CLK_READ : in STD_LOGIC_VECTOR(0 downto 0);
			READ_DATA : out STD_LOGIC_VECTOR(31 downto 0);
			READ_DATAVALID : out STD_LOGIC_VECTOR(0 downto 0);
			READ_NEXT : in STD_LOGIC_VECTOR(0 downto 0);
			STATUS : out STD_LOGIC_VECTOR(31 downto 0);
			CONFIG : in STD_LOGIC_VECTOR(31 downto 0)
		);
	END COMPONENT;

	signal BUS_page_subdesign_1_READ_ADDRESS : STD_LOGIC_VECTOR(18 downto 0);
	signal BUS_page_subdesign_1_READ_DATA : STD_LOGIC_VECTOR(31 downto 0);
	signal BUS_page_subdesign_1_WRITE_DATA : STD_LOGIC_VECTOR(31 downto 0);
	signal BUS_page_subdesign_1_W_INT : STD_LOGIC_VECTOR(0 downto 0);
	signal BUS_page_subdesign_1_R_INT : STD_LOGIC_VECTOR(0 downto 0);
	signal BUS_page_subdesign_1_VLD : STD_LOGIC_VECTOR(0 downto 0) := "1";
	signal BUS_List_0_READ_ADDRESS : STD_LOGIC_VECTOR(-1 downto 0);
	signal BUS_List_0_WRITE_DATA : STD_LOGIC_VECTOR(31 downto 0);
	signal BUS_List_0_W_INT : STD_LOGIC_VECTOR(0 downto 0);
	signal BUS_List_0_R_INT : STD_LOGIC_VECTOR(0 downto 0);
	signal INT_List_0_STATUS_RD : STD_LOGIC_VECTOR(0 downto 0);
	signal REG_List_0_CONFIG_WR : STD_LOGIC_VECTOR(31 downto 0);
	signal INT_List_0_CONFIG_WR : STD_LOGIC_VECTOR(0 downto 0);
	signal REG_EL_M_RD : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal REG_EL_M_WR : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal INT_EL_M_WR : STD_LOGIC_VECTOR(0 downto 0); 
	signal INT_EL_M_RD : STD_LOGIC_VECTOR(0 downto 0); 
	signal REG_PEAK_DELAY_RD : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal REG_PEAK_DELAY_WR : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal INT_PEAK_DELAY_WR : STD_LOGIC_VECTOR(0 downto 0); 
	signal INT_PEAK_DELAY_RD : STD_LOGIC_VECTOR(0 downto 0); 
	signal REG_BL_M_RD : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal REG_BL_M_WR : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal INT_BL_M_WR : STD_LOGIC_VECTOR(0 downto 0); 
	signal INT_BL_M_RD : STD_LOGIC_VECTOR(0 downto 0); 
	signal REG_BL_HOLD_RD : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal REG_BL_HOLD_WR : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal INT_BL_HOLD_WR : STD_LOGIC_VECTOR(0 downto 0); 
	signal INT_BL_HOLD_RD : STD_LOGIC_VECTOR(0 downto 0); 

	
begin
	CHA0 <= ADC_A_IN;
	CHA1 <= ADC_B_IN;

	Inst_ftdi245_cdc: ftdi245_cdc PORT MAP(
		FTDI_ADBUS => FTDI_ADBUS,
		FTDI_RXFN => FTDI_RXFN,
		FTDI_TXEN => FTDI_TXEN,
		FTDI_RDN => FTDI_RDN,
		FTDI_TXN => FTDI_TXN,
		FTDI_CLK => FTDI_CLK,
		FTDI_OEN => FTDI_OEN,
		FTDI_SIWU => FTDI_SIWU,
		f_CLK => sample_clk ,
		f_RESET => '0',
		
	    EEMOSI => EEMOSI,
        EEMISO => EEMISO,
        EECLK => EECLK,
        EECS => EECS,

		
		-- Register interface  
				REG_EL_M_RD => REG_EL_M_RD,
		REG_EL_M_WR => REG_EL_M_WR,
		INT_EL_M_RD => INT_EL_M_RD,
		INT_EL_M_WR => INT_EL_M_WR,
		REG_PEAK_DELAY_RD => REG_PEAK_DELAY_RD,
		REG_PEAK_DELAY_WR => REG_PEAK_DELAY_WR,
		INT_PEAK_DELAY_RD => INT_PEAK_DELAY_RD,
		INT_PEAK_DELAY_WR => INT_PEAK_DELAY_WR,
		REG_BL_M_RD => REG_BL_M_RD,
		REG_BL_M_WR => REG_BL_M_WR,
		INT_BL_M_RD => INT_BL_M_RD,
		INT_BL_M_WR => INT_BL_M_WR,
		REG_BL_HOLD_RD => REG_BL_HOLD_RD,
		REG_BL_HOLD_WR => REG_BL_HOLD_WR,
		INT_BL_HOLD_RD => INT_BL_HOLD_RD,
		INT_BL_HOLD_WR => INT_BL_HOLD_WR,
	BUS_page_subdesign_1_READ_ADDRESS => BUS_page_subdesign_1_READ_ADDRESS,
	BUS_page_subdesign_1_READ_DATA => BUS_page_subdesign_1_READ_DATA,
	BUS_page_subdesign_1_WRITE_DATA => BUS_page_subdesign_1_WRITE_DATA,
	BUS_page_subdesign_1_W_INT => BUS_page_subdesign_1_W_INT,
	BUS_page_subdesign_1_R_INT => BUS_page_subdesign_1_R_INT,
	BUS_page_subdesign_1_VLD => BUS_page_subdesign_1_VLD,
	BUS_List_0_READ_DATA => BUS_List_0_READ_DATA,
	BUS_List_0_WRITE_DATA => BUS_List_0_WRITE_DATA,
	BUS_List_0_W_INT => BUS_List_0_W_INT,
	BUS_List_0_R_INT => BUS_List_0_R_INT,
	BUS_List_0_VLD => BUS_List_0_VLD,
		REG_List_0_STATUS_RD => REG_List_0_STATUS_RD,
		INT_List_0_STATUS_RD => INT_List_0_STATUS_RD,
		REG_List_0_CONFIG_WR => REG_List_0_CONFIG_WR,
		INT_List_0_CONFIG_WR => INT_List_0_CONFIG_WR,
		REG_List_0_CONFIG_RD => REG_List_0_CONFIG_WR,
		REG_UNIQUE_RD => x"2672AE17",
		REG_UNIQUE_WR => open,
   
        
        REG_FIRMWARE_BUILD => x"12345678",
        
        REG_OFFSET_RD =>REG_OFFSET,
        REG_OFFSET_WR =>REG_OFFSET,
        INT_OFFSET_RD => open,
        INT_OFFSET_WR => REG_OFFSET_WR,

        REG_IO_RD => REG_IO_RD,
        REG_IO_WR => REG_IO_WR,
        INT_IO_RD => open,
        INT_IO_WR => open,
		
      --FLASH CONTROLLER
        BUS_Flash_0_READ_DATA => BUS_Flash_0_READ_DATA,
        BUS_Flash_0_ADDRESS => BUS_Flash_0_ADDRESS, 
        BUS_Flash_0_WRITE_DATA => BUS_Flash_0_WRITE_DATA, 
        BUS_Flash_0_W_INT => BUS_Flash_0_W_INT, 
        BUS_Flash_0_R_INT => BUS_Flash_0_R_INT, 
        BUS_Flash_0_VLD => BUS_Flash_0_VLD, 
        
        REG_FLASH_CNTR_RD => REG_FLASH_CNTR_RD, 
        REG_FLASH_CNTR_WR => REG_FLASH_CNTR_WR, 
        INT_FLASH_CNTR_RD => INT_FLASH_CNTR_RD, 
        INT_FLASH_CNTR_WR => INT_FLASH_CNTR_WR, 
        
        REG_FLASH_ADDRESS_RD => REG_FLASH_ADDRESS_RD, 
        REG_FLASH_ADDRESS_WR => REG_FLASH_ADDRESS_WR, 
        INT_FLASH_ADDRESS_RD => INT_FLASH_ADDRESS_RD, 
        INT_FLASH_ADDRESS_WR => INT_FLASH_ADDRESS_WR,     
        
        -- Test 
        BUS_Test_0_READ_DATA => BUS_Test_0_READ_DATA,
        BUS_Test_0_ADDRESS => BUS_Test_0_ADDRESS, 
        BUS_Test_0_WRITE_DATA => BUS_Test_0_WRITE_DATA, 
        BUS_Test_0_W_INT => BUS_Test_0_W_INT, 
        BUS_Test_0_R_INT => BUS_Test_0_R_INT, 
        BUS_Test_0_VLD => BUS_Test_0_VLD		
        		
	);
	async_clk(0) <= sample_clk;
	CLK_ACQ(0) <= sample_clk;
	GlobalClock(0) <= sample_clk;
	BUS_CLK(0) <= sample_clk;
	boot_led <= power_led_sig;--REG_IO_WR(2);
	lemo_oe <= '0';
	REG_IO_RD(0) <= boot_sw;
	REG_IO_RD(1) <= sw1;
	
	gpio <= REG_IO_WR(15 downto 8);
		
	pwled : process(sample_clk)
	begin
		if rising_edge(sample_clk) then
			if pw_led_counter = 65000000 then
				pw_led_counter <= 0;
				power_led_sig <= '1';
			else
				if pw_led_counter = 6500000 then
					power_led_sig <= '0';
				end if;
				pw_led_counter <= pw_led_counter +1;
			end if;
		end if;
	end process;
	
   LEMO0_BUFF : IOBUF
   generic map (
      DRIVE => 12,
      IOSTANDARD => "DEFAULT",
      SLEW => "SLOW")
   port map (
      O =>  LEMO_0_A_OUT(0),     
      IO => lemo_a,   
      I =>  LEMO_0_A_IN(0),
      T =>  LEMO_0_DIRECTION(0) 
   ); 
   	lemo_dir_a <= LEMO_0_DIRECTION(0);
	
   LEMO2_BUFF : IOBUF
   generic map (
      DRIVE => 12,
      IOSTANDARD => "DEFAULT",
      SLEW => "SLOW")
   port map (
      O =>  LEMO_1_A_OUT(0),     
      IO => lemo_b,   
      I =>  LEMO_1_A_IN(0),
      T =>  LEMO_1_DIRECTION(0) 
   ); 
   	lemo_dir_b <= LEMO_1_DIRECTION(0);	
	
    mcg : main_clk_gen
    port map
    (
        sample_clk => sample_clk,
        locked => mcg_lock,
        clk_in1 => clk_100,
		clk_out2 => open
    );
    
    clk125 : CLK_125MHZ
      PORT MAP(
          clk_out1    => clk_125(0),
          clk_in1    => clk_100
      );
	FAST_CLK_100(0) <= clk_100;

    Inst_scidk_internal_i2c_manager : scidk_internal_i2c_manager 
    Port map( clk => sample_clk,
           reset => GlobalReset(0),
           offset => REG_OFFSET(15 downto 0),
           w_offset => REG_OFFSET_WR(0), 
           sda => IIC_0_sda,
           scl => IIC_0_scl
           );
  
    
    CLK_TO_ADC_A<=sample_clk;
    CLK_TO_ADC_B<=sample_clk;
    GlobalReset(0) <= not mcg_lock;
    SHND_ADC_A <='0';
    SHND_ADC_B <='0';
    OE_ADC_A <= '0';
    OE_ADC_B <= '0';
    


	
	U0_A0 <= "0000" & CHA0(13 downto 2);
U1_A1 <= "0000" & CHA1(13 downto 2);
U2_out_0 <= REG_BL_M_WR(15 downto 0);
REG_BL_M_RD  <= REG_BL_M_WR;
U3_out_0 <= REG_BL_HOLD_WR(15 downto 0);
REG_BL_HOLD_RD  <= REG_BL_HOLD_WR;
U4_out_0 <= REG_PEAK_DELAY_WR(15 downto 0);
REG_PEAK_DELAY_RD  <= REG_PEAK_DELAY_WR;

U5_0:SUBPAGE_subdesign_1
PORT MAP(
	AN => U0_A0,
	DATA => U5_DATA_0,
	DATA_VALID => U5_DATA_VALID_0,
	TIMESTAMPO => U6_TIMESTAMP,
	BL_M => U2_out_0,
	BL_HOLD => U3_out_0,
	PEAK_DELAY => U4_out_0,
	GlobalReset => GlobalReset,
	CLK_ACQ=>CLK_ACQ ,
	BUS_CLK=>BUS_CLK ,
	CLK_40=>CLK_40 ,
	CLK_50 => "0" ,
	CLK_80=>CLK_80 ,
	clk_160=>clk_160 ,
	clk_320=>clk_320 ,
	clk_125=>clk_125 ,
	FAST_CLK_100=>FAST_CLK_100 ,
	FAST_CLK_200=>FAST_CLK_200 ,
	FAST_CLK_250=>FAST_CLK_250 ,
	FAST_CLK_250_90=>FAST_CLK_250_90 ,
	FAST_CLK_500=>FAST_CLK_500 ,
	FAST_CLK_500_90=>FAST_CLK_500_90 ,
	GlobalClock=>GlobalClock ,
	async_clk => async_clk, 
	BUS_READ_DATA => BUS_page_subdesign_1_0_READ_DATA, 
	BUS_ADDRESS => ext(BUS_page_subdesign_1_READ_ADDRESS(17 downto 0),32), 
	BUS_WRITE_DATA => BUS_page_subdesign_1_WRITE_DATA, 
	BUS_INT_RD => BUS_page_subdesign_1_0_R_INT, 
	BUS_INT_WR => BUS_page_subdesign_1_0_W_INT, 
	BUS_VLD => BUS_page_subdesign_1_0_VLD 
);
BUS_page_subdesign_1_0_R_INT <= BUS_page_subdesign_1_R_INT when conv_integer(BUS_page_subdesign_1_READ_ADDRESS(18 downto 18)) = 0 else "0";

BUS_page_subdesign_1_0_W_INT <= BUS_page_subdesign_1_W_INT when conv_integer(BUS_page_subdesign_1_READ_ADDRESS(18 downto 18)) = 0 else "0";


U5_1:SUBPAGE_subdesign_1
PORT MAP(
	AN => U1_A1,
	DATA => U5_DATA_1,
	DATA_VALID => U5_DATA_VALID_1,
	TIMESTAMPO => U6_TIMESTAMP,
	BL_M => U2_out_0,
	BL_HOLD => U3_out_0,
	PEAK_DELAY => U4_out_0,
	GlobalReset => GlobalReset,
	CLK_ACQ=>CLK_ACQ ,
	BUS_CLK=>BUS_CLK ,
	CLK_40=>CLK_40 ,
	CLK_50 => "0" ,
	CLK_80=>CLK_80 ,
	clk_160=>clk_160 ,
	clk_320=>clk_320 ,
	clk_125=>clk_125 ,
	FAST_CLK_100=>FAST_CLK_100 ,
	FAST_CLK_200=>FAST_CLK_200 ,
	FAST_CLK_250=>FAST_CLK_250 ,
	FAST_CLK_250_90=>FAST_CLK_250_90 ,
	FAST_CLK_500=>FAST_CLK_500 ,
	FAST_CLK_500_90=>FAST_CLK_500_90 ,
	GlobalClock=>GlobalClock ,
	async_clk => async_clk, 
	BUS_READ_DATA => BUS_page_subdesign_1_1_READ_DATA, 
	BUS_ADDRESS => ext(BUS_page_subdesign_1_READ_ADDRESS(17 downto 0),32), 
	BUS_WRITE_DATA => BUS_page_subdesign_1_WRITE_DATA, 
	BUS_INT_RD => BUS_page_subdesign_1_1_R_INT, 
	BUS_INT_WR => BUS_page_subdesign_1_1_W_INT, 
	BUS_VLD => BUS_page_subdesign_1_1_VLD 
);
BUS_page_subdesign_1_1_R_INT <= BUS_page_subdesign_1_R_INT when conv_integer(BUS_page_subdesign_1_READ_ADDRESS(18 downto 18)) = 1 else "0";

BUS_page_subdesign_1_1_W_INT <= BUS_page_subdesign_1_W_INT when conv_integer(BUS_page_subdesign_1_READ_ADDRESS(18 downto 18)) = 1 else "0";

BUS_page_subdesign_1_READ_DATA <= BUS_page_subdesign_1_0_READ_DATA when conv_integer(BUS_page_subdesign_1_READ_ADDRESS(18 downto 18)) = 0 else
BUS_page_subdesign_1_1_READ_DATA when conv_integer(BUS_page_subdesign_1_READ_ADDRESS(18 downto 18)) = 1 else
x"00000000";

BUS_page_subdesign_1_VLD <= BUS_page_subdesign_1_0_VLD when conv_integer(BUS_page_subdesign_1_READ_ADDRESS(18 downto 18)) = 0 else
BUS_page_subdesign_1_1_VLD when conv_integer(BUS_page_subdesign_1_READ_ADDRESS(18 downto 18)) = 1 else
"0";


	U6 : TimestampGenerator
	Generic map(
		nbits => 	40
	)
	PORT MAP(
		TIMESTAMP => U6_TIMESTAMP,
		T0 => U8_CLEAR(0),
		CLK_READ => GlobalClock(0),
		ClkCounter => GlobalClock(0)
	);



	U7 : arbiter_round_robbins_fifop
	Generic map(
		nbits => 	56,
		nports => 	2,
		timemax => 	10,
		fifolength => 	256
	)
	PORT MAP(
		data_in => U5_DATA_1 & U5_DATA_0,
		we => U5_DATA_VALID_1 & U5_DATA_VALID_0,
		out_full => U8_BUSY,
		CE => "1",
		CLK => GlobalClock,
		RESET => U8_CLEAR,
		out_data => open,
		out_addr => open,
		out_addr_data => U7_AD,
		out_dv => U7_DV_OUT,
		busy => U7_busyin
	);


	U8 : listmodule
	Generic map(
		fifolength => 	8192,
		bitsize => 	64,
		channels => 	1
	)
	PORT MAP(
		DATAIN => U7_AD,
		WE => U7_DV_OUT,
		FULL => open,
		BUSY => U8_BUSY,
		RUNNING => open,
		CLEAR => U8_CLEAR,
		RESET => GlobalReset,
		CLK_WRITE => CLK_ACQ,
		CLK_READ => BUS_CLK,
		READ_DATA => BUS_List_0_READ_DATA,
		READ_DATAVALID => BUS_List_0_VLD,
		READ_NEXT => BUS_List_0_R_INT,
		STATUS => REG_List_0_STATUS_RD,
		CONFIG => REG_List_0_CONFIG_WR
	);


		 
end Behavioral;

 