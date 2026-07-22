----------------------------------------------------------------------------------
-- Company: 	Nuclear Instruments SRL
-- Engineer: 	Andrea Abba
-- 
-- Create Date: 07.06.2020 10:24:18
-- Design Name: SciDK Scicompiler Development Kit
-- Module Name: TOP_lab3counter
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
    
entity TOP_lab3counter is
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
end TOP_lab3counter;

architecture Behavioral of TOP_lab3counter is
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
				REG_THRESHOLD_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_THRESHOLD_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_THRESHOLD_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_THRESHOLD_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_INIBIT_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_INIBIT_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_INIBIT_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_INIBIT_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_COUNTS_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_COUNTS_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_COUNTS_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_COUNTS_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_DELTA_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_DELTA_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_DELTA_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_DELTA_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_RESET_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_RESET_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_RESET_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_RESET_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
	BUS_Oscilloscope_0_READ_ADDRESS : OUT STD_LOGIC_VECTOR(9 downto 0); 
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
		REG_WIDTH_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_WIDTH_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_WIDTH_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_WIDTH_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_RUNNING_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_RUNNING_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_RUNNING_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_RUNNING_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
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

	
		signal U0_DATA_OUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal U0_TRIGGER : STD_LOGIC_VECTOR(0 DOWNTO 0);

	COMPONENT trigger_le_delta
		GENERIC( 
			ADC_nbits : INTEGER := 16
		);
		PORT( 
			CLK : in STD_LOGIC_VECTOR(0 downto 0);
			RESET : in STD_LOGIC_VECTOR(0 downto 0);
			DATA_IN : in STD_LOGIC_VECTOR(ADC_nbits-1 downto 0);
			POLARITY : in STD_LOGIC_VECTOR(0 downto 0);
			THRESHOLD : in STD_LOGIC_VECTOR(ADC_nbits-1 downto 0);
			DELTA : in STD_LOGIC_VECTOR(ADC_nbits-1 downto 0);
			INIBIT : in STD_LOGIC_VECTOR(ADC_nbits-1 downto 0);
			DATA_OUT : out STD_LOGIC_VECTOR(ADC_nbits-1 downto 0);
			TRIGGER_OUT : out STD_LOGIC_VECTOR(0 downto 0);
			TOT_OUT : out STD_LOGIC_VECTOR(0 downto 0)
		);
	END COMPONENT;

signal U1_CONST : STD_LOGIC_VECTOR(0 downto 0) := (others => '0');
signal U2_hold : std_logic_vector(31 downto 0);
signal U3_out_0 : std_logic_vector(15 downto 0);
signal U4_out_0 : std_logic_vector(15 downto 0);
	signal U5_COUNTS : STD_LOGIC_VECTOR(31 DOWNTO 0);

	COMPONENT COUNTER_RISINGp
		GENERIC( 
			bitSize : INTEGER := 32
		);
		PORT( 
			COUNTER : out STD_LOGIC_VECTOR(bitSize-1 downto 0);
			OVERFLOW : out STD_LOGIC_VECTOR(0 downto 0);
			SIGIN : in STD_LOGIC_VECTOR(0 downto 0);
			ENABLE : in STD_LOGIC_VECTOR(0 downto 0);
			CE : in STD_LOGIC_VECTOR(0 downto 0);
			CLK : in STD_LOGIC_VECTOR(0 downto 0);
			RESET : in STD_LOGIC_VECTOR(0 downto 0)
		);
	END COMPONENT;

signal U6_CONST : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal U7_A0 : std_logic_vector(15 downto 0);
	signal BUS_Oscilloscope_0_READ_DATA : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal BUS_Oscilloscope_0_VLD : STD_LOGIC_VECTOR(0 DOWNTO 0);
	signal REG_Oscilloscope_0_READ_STATUS_RD : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal REG_Oscilloscope_0_READ_POSITION_RD : STD_LOGIC_VECTOR(31 DOWNTO 0);

	COMPONENT xlx_oscilloscope_sync
		GENERIC( 
			channels : INTEGER := 1;
			memLength : INTEGER := 1024;
			wordWidth : INTEGER := 16
		);
		PORT( 
			ANALOG : in STD_LOGIC_VECTOR((wordWidth*channels)-1 downto 0);
			D0 : in STD_LOGIC_VECTOR(channels-1 downto 0);
			D1 : in STD_LOGIC_VECTOR(channels-1 downto 0);
			D2 : in STD_LOGIC_VECTOR(channels-1 downto 0);
			D3 : in STD_LOGIC_VECTOR(channels-1 downto 0);
			TRIG : in STD_LOGIC_VECTOR(0 downto 0);
			BUSY : out STD_LOGIC_VECTOR(0 downto 0);
			CE : in STD_LOGIC_VECTOR(0 downto 0);
			CLK_WRITE : in STD_LOGIC_VECTOR(0 downto 0);
			RESET : in STD_LOGIC_VECTOR(0 downto 0);
			CLK_READ : in STD_LOGIC_VECTOR(0 downto 0);
			READ_ADDRESS : in STD_LOGIC_VECTOR(integer(ceil(log2(real(memLength*channels))))-1 downto 0);
			READ_DATA : out STD_LOGIC_VECTOR(31 downto 0);
			READ_DATAVALID : out STD_LOGIC_VECTOR(0 downto 0);
			READ_STATUS : out STD_LOGIC_VECTOR(31 downto 0);
			READ_POSITION : out STD_LOGIC_VECTOR(31 downto 0);
			CONFIG_TRIGGER_MODE : in STD_LOGIC_VECTOR(31 downto 0);
			CONFIG_TRIGGER_LEVEL : in STD_LOGIC_VECTOR(31 downto 0);
			CONFIG_PRETRIGGER : in STD_LOGIC_VECTOR(31 downto 0);
			CONFIG_DECIMATOR : in STD_LOGIC_VECTOR(31 downto 0);
			CONFIG_ARM : in STD_LOGIC_VECTOR(31 downto 0)
		);
	END COMPONENT;

	signal U9_OUT : STD_LOGIC_VECTOR(0 DOWNTO 0);

	COMPONENT EDGE_DETECTOR_REp
		GENERIC( 
			bitSize : INTEGER := 1
		);
		PORT( 
			PORT_IN : in STD_LOGIC_VECTOR(bitSize-1 downto 0);
			CE : in STD_LOGIC_VECTOR(0 downto 0);
			CLK : in STD_LOGIC_VECTOR(0 downto 0);
			RESET : in STD_LOGIC_VECTOR(0 downto 0);
			PULSE_WIDTH : in INTEGER;
			PORT_OUT : out STD_LOGIC_VECTOR(bitSize-1 downto 0)
		);
	END COMPONENT;

signal U10_out_0 : std_logic_vector(0 downto 0);
	signal U11_OUT : STD_LOGIC_VECTOR(0 DOWNTO 0);

	COMPONENT pulseshaper
		GENERIC( 
			EDGE : STRING := "rising";
			NO_DELAY : STRING := "false"
		);
		PORT( 
			a : in STD_LOGIC_VECTOR(0 downto 0);
			CE : in STD_LOGIC;
			clk : in STD_LOGIC;
			reset : in STD_LOGIC;
			width : in INTEGER;
			delay : in INTEGER;
			b : out STD_LOGIC_VECTOR(0 downto 0)
		);
	END COMPONENT;

signal U12_out_0 : integer;
signal U13_hold : std_logic_vector(31 downto 0);
	signal BUS_Oscilloscope_0_READ_ADDRESS : STD_LOGIC_VECTOR(9 downto 0);
	signal BUS_Oscilloscope_0_WRITE_DATA : STD_LOGIC_VECTOR(31 downto 0);
	signal BUS_Oscilloscope_0_W_INT : STD_LOGIC_VECTOR(0 downto 0);
	signal BUS_Oscilloscope_0_R_INT : STD_LOGIC_VECTOR(0 downto 0);
	signal INT_Oscilloscope_0_READ_STATUS_RD : STD_LOGIC_VECTOR(0 downto 0);
	signal INT_Oscilloscope_0_READ_POSITION_RD : STD_LOGIC_VECTOR(0 downto 0);
	signal REG_Oscilloscope_0_CONFIG_TRIGGER_MODE_WR : STD_LOGIC_VECTOR(31 downto 0);
	signal INT_Oscilloscope_0_CONFIG_TRIGGER_MODE_WR : STD_LOGIC_VECTOR(0 downto 0);
	signal REG_Oscilloscope_0_CONFIG_PRETRIGGER_WR : STD_LOGIC_VECTOR(31 downto 0);
	signal INT_Oscilloscope_0_CONFIG_PRETRIGGER_WR : STD_LOGIC_VECTOR(0 downto 0);
	signal REG_Oscilloscope_0_CONFIG_TRIGGER_LEVEL_WR : STD_LOGIC_VECTOR(31 downto 0);
	signal INT_Oscilloscope_0_CONFIG_TRIGGER_LEVEL_WR : STD_LOGIC_VECTOR(0 downto 0);
	signal REG_Oscilloscope_0_CONFIG_ARM_WR : STD_LOGIC_VECTOR(31 downto 0);
	signal INT_Oscilloscope_0_CONFIG_ARM_WR : STD_LOGIC_VECTOR(0 downto 0);
	signal REG_Oscilloscope_0_CONFIG_DECIMATOR_WR : STD_LOGIC_VECTOR(31 downto 0);
	signal INT_Oscilloscope_0_CONFIG_DECIMATOR_WR : STD_LOGIC_VECTOR(0 downto 0);
	signal REG_THRESHOLD_RD : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal REG_THRESHOLD_WR : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal INT_THRESHOLD_WR : STD_LOGIC_VECTOR(0 downto 0); 
	signal INT_THRESHOLD_RD : STD_LOGIC_VECTOR(0 downto 0); 
	signal REG_INIBIT_RD : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal REG_INIBIT_WR : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal INT_INIBIT_WR : STD_LOGIC_VECTOR(0 downto 0); 
	signal INT_INIBIT_RD : STD_LOGIC_VECTOR(0 downto 0); 
	signal REG_COUNTS_RD : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal REG_COUNTS_WR : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal INT_COUNTS_WR : STD_LOGIC_VECTOR(0 downto 0); 
	signal INT_COUNTS_RD : STD_LOGIC_VECTOR(0 downto 0); 
	signal REG_DELTA_RD : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal REG_DELTA_WR : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal INT_DELTA_WR : STD_LOGIC_VECTOR(0 downto 0); 
	signal INT_DELTA_RD : STD_LOGIC_VECTOR(0 downto 0); 
	signal REG_RESET_RD : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal REG_RESET_WR : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal INT_RESET_WR : STD_LOGIC_VECTOR(0 downto 0); 
	signal INT_RESET_RD : STD_LOGIC_VECTOR(0 downto 0); 
	signal REG_WIDTH_RD : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal REG_WIDTH_WR : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal INT_WIDTH_WR : STD_LOGIC_VECTOR(0 downto 0); 
	signal INT_WIDTH_RD : STD_LOGIC_VECTOR(0 downto 0); 
	signal REG_RUNNING_RD : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal REG_RUNNING_WR : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal INT_RUNNING_WR : STD_LOGIC_VECTOR(0 downto 0); 
	signal INT_RUNNING_RD : STD_LOGIC_VECTOR(0 downto 0); 

	
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
				REG_THRESHOLD_RD => REG_THRESHOLD_RD,
		REG_THRESHOLD_WR => REG_THRESHOLD_WR,
		INT_THRESHOLD_RD => INT_THRESHOLD_RD,
		INT_THRESHOLD_WR => INT_THRESHOLD_WR,
		REG_INIBIT_RD => REG_INIBIT_RD,
		REG_INIBIT_WR => REG_INIBIT_WR,
		INT_INIBIT_RD => INT_INIBIT_RD,
		INT_INIBIT_WR => INT_INIBIT_WR,
		REG_COUNTS_RD => REG_COUNTS_RD,
		REG_COUNTS_WR => REG_COUNTS_WR,
		INT_COUNTS_RD => INT_COUNTS_RD,
		INT_COUNTS_WR => INT_COUNTS_WR,
		REG_DELTA_RD => REG_DELTA_RD,
		REG_DELTA_WR => REG_DELTA_WR,
		INT_DELTA_RD => INT_DELTA_RD,
		INT_DELTA_WR => INT_DELTA_WR,
		REG_RESET_RD => REG_RESET_RD,
		REG_RESET_WR => REG_RESET_WR,
		INT_RESET_RD => INT_RESET_RD,
		INT_RESET_WR => INT_RESET_WR,
	BUS_Oscilloscope_0_READ_ADDRESS => BUS_Oscilloscope_0_READ_ADDRESS,
	BUS_Oscilloscope_0_READ_DATA => BUS_Oscilloscope_0_READ_DATA,
	BUS_Oscilloscope_0_WRITE_DATA => BUS_Oscilloscope_0_WRITE_DATA,
	BUS_Oscilloscope_0_W_INT => BUS_Oscilloscope_0_W_INT,
	BUS_Oscilloscope_0_R_INT => BUS_Oscilloscope_0_R_INT,
	BUS_Oscilloscope_0_VLD => BUS_Oscilloscope_0_VLD,
		REG_Oscilloscope_0_READ_STATUS_RD => REG_Oscilloscope_0_READ_STATUS_RD,
		INT_Oscilloscope_0_READ_STATUS_RD => INT_Oscilloscope_0_READ_STATUS_RD,
		REG_Oscilloscope_0_READ_POSITION_RD => REG_Oscilloscope_0_READ_POSITION_RD,
		INT_Oscilloscope_0_READ_POSITION_RD => INT_Oscilloscope_0_READ_POSITION_RD,
		REG_Oscilloscope_0_CONFIG_TRIGGER_MODE_WR => REG_Oscilloscope_0_CONFIG_TRIGGER_MODE_WR,
		INT_Oscilloscope_0_CONFIG_TRIGGER_MODE_WR => INT_Oscilloscope_0_CONFIG_TRIGGER_MODE_WR,
		REG_Oscilloscope_0_CONFIG_TRIGGER_MODE_RD => REG_Oscilloscope_0_CONFIG_TRIGGER_MODE_WR,
		REG_Oscilloscope_0_CONFIG_PRETRIGGER_WR => REG_Oscilloscope_0_CONFIG_PRETRIGGER_WR,
		INT_Oscilloscope_0_CONFIG_PRETRIGGER_WR => INT_Oscilloscope_0_CONFIG_PRETRIGGER_WR,
		REG_Oscilloscope_0_CONFIG_PRETRIGGER_RD => REG_Oscilloscope_0_CONFIG_PRETRIGGER_WR,
		REG_Oscilloscope_0_CONFIG_TRIGGER_LEVEL_WR => REG_Oscilloscope_0_CONFIG_TRIGGER_LEVEL_WR,
		INT_Oscilloscope_0_CONFIG_TRIGGER_LEVEL_WR => INT_Oscilloscope_0_CONFIG_TRIGGER_LEVEL_WR,
		REG_Oscilloscope_0_CONFIG_TRIGGER_LEVEL_RD => REG_Oscilloscope_0_CONFIG_TRIGGER_LEVEL_WR,
		REG_Oscilloscope_0_CONFIG_ARM_WR => REG_Oscilloscope_0_CONFIG_ARM_WR,
		INT_Oscilloscope_0_CONFIG_ARM_WR => INT_Oscilloscope_0_CONFIG_ARM_WR,
		REG_Oscilloscope_0_CONFIG_ARM_RD => REG_Oscilloscope_0_CONFIG_ARM_WR,
		REG_Oscilloscope_0_CONFIG_DECIMATOR_WR => REG_Oscilloscope_0_CONFIG_DECIMATOR_WR,
		INT_Oscilloscope_0_CONFIG_DECIMATOR_WR => INT_Oscilloscope_0_CONFIG_DECIMATOR_WR,
		REG_Oscilloscope_0_CONFIG_DECIMATOR_RD => REG_Oscilloscope_0_CONFIG_DECIMATOR_WR,
		REG_WIDTH_RD => REG_WIDTH_RD,
		REG_WIDTH_WR => REG_WIDTH_WR,
		INT_WIDTH_RD => INT_WIDTH_RD,
		INT_WIDTH_WR => INT_WIDTH_WR,
		REG_RUNNING_RD => REG_RUNNING_RD,
		REG_RUNNING_WR => REG_RUNNING_WR,
		INT_RUNNING_RD => INT_RUNNING_RD,
		INT_RUNNING_WR => INT_RUNNING_WR,
		REG_UNIQUE_RD => x"3FFCE738",
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
    


	
	
	U0 : trigger_le_delta
	Generic map(
		ADC_nbits => 	16
	)
	PORT MAP(
		CLK => CLK_ACQ,
		RESET => "1",
		DATA_IN => U7_A0,
		POLARITY => U1_CONST,
		THRESHOLD => U4_out_0,
		DELTA => U3_out_0,
		INIBIT => U6_CONST,
		DATA_OUT => U0_DATA_OUT,
		TRIGGER_OUT => U0_TRIGGER,
		TOT_OUT => open
	);

U1_CONST <= conv_std_logic_vector(1,1);
PROCESS_REG_U2 : process(GlobalClock,GlobalReset)
begin
    if rising_edge(GlobalClock(0))  then
         U2_hold <= EXT(U5_COUNTS,32);
    end if;
end process;
REG_COUNTS_RD <= EXT(U5_COUNTS,32);
U3_out_0 <= REG_DELTA_WR(15 downto 0);
REG_DELTA_RD  <= REG_DELTA_WR;
U4_out_0 <= REG_THRESHOLD_WR(15 downto 0);
REG_THRESHOLD_RD  <= REG_THRESHOLD_WR;

	U5 : COUNTER_RISINGp
	Generic map(
		bitSize => 	32
	)
	PORT MAP(
		COUNTER => U5_COUNTS,
		OVERFLOW => open,
		SIGIN => U0_TRIGGER,
		ENABLE => U11_OUT,
		CE => "1",
		CLK => GlobalClock,
		RESET => U9_OUT
	);

U6_CONST <= conv_std_logic_vector(10,16);
U7_A0 <= "0000" & CHA0(13 downto 2);

	U8 : xlx_oscilloscope_sync
	Generic map(
		channels => 	1,
		memLength => 	1024,
		wordWidth => 	16
	)
	PORT MAP(
		ANALOG => U0_DATA_OUT,
		D0 => U0_TRIGGER,
		D1 => "0",
		D2 => "0",
		D3 => "0",
		TRIG => "0",
		BUSY => open,
		CE => "1",
		CLK_WRITE => CLK_ACQ,
		RESET => GlobalReset,
		CLK_READ => BUS_CLK,
		READ_ADDRESS => BUS_Oscilloscope_0_READ_ADDRESS,
		READ_DATA => BUS_Oscilloscope_0_READ_DATA,
		READ_DATAVALID => BUS_Oscilloscope_0_VLD,
		READ_STATUS => REG_Oscilloscope_0_READ_STATUS_RD,
		READ_POSITION => REG_Oscilloscope_0_READ_POSITION_RD,
		CONFIG_TRIGGER_MODE => REG_Oscilloscope_0_CONFIG_TRIGGER_MODE_WR,
		CONFIG_TRIGGER_LEVEL => REG_Oscilloscope_0_CONFIG_TRIGGER_LEVEL_WR,
		CONFIG_PRETRIGGER => REG_Oscilloscope_0_CONFIG_PRETRIGGER_WR,
		CONFIG_DECIMATOR => REG_Oscilloscope_0_CONFIG_DECIMATOR_WR,
		CONFIG_ARM => REG_Oscilloscope_0_CONFIG_ARM_WR
	);


	U9 : EDGE_DETECTOR_REp
	Generic map(
		bitSize => 	1
	)
	PORT MAP(
		PORT_IN => U10_out_0,
		CE => "1",
		CLK => GlobalClock,
		RESET => GlobalReset,
		PULSE_WIDTH => 1,
		PORT_OUT => U9_OUT
	);

U10_out_0 <= REG_RESET_WR(0 downto 0);
REG_RESET_RD  <= REG_RESET_WR;

	U11 : pulseshaper
	Generic map(
		EDGE => 	"rising",
		NO_DELAY => 	"false"
	)
	PORT MAP(
		a => U9_OUT,
		CE => '1',
		clk => GlobalClock(0),
		reset => GlobalReset(0),
		width => U12_out_0,
		delay => 0,
		b => U11_OUT
	);

U12_out_0 <= conv_integer(REG_WIDTH_WR);
REG_WIDTH_RD  <= REG_WIDTH_WR;
PROCESS_REG_U13 : process(GlobalClock,GlobalReset)
begin
    if rising_edge(GlobalClock(0))  then
         U13_hold <= EXT(U11_OUT,32);
    end if;
end process;
REG_RUNNING_RD <= EXT(U11_OUT,32);

		 
end Behavioral;

 