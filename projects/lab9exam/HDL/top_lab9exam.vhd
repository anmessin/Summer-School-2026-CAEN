----------------------------------------------------------------------------------
-- Company: 	Nuclear Instruments SRL
-- Engineer: 	Andrea Abba
-- 
-- Create Date: 07.06.2020 10:24:18
-- Design Name: SciDK Scicompiler Development Kit
-- Module Name: TOP_lab9exam
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
    
entity TOP_lab9exam is
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
end TOP_lab9exam;

architecture Behavioral of TOP_lab9exam is
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
		REG_M_LENGTH_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_M_LENGTH_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_M_LENGTH_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_M_LENGTH_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_BL_HOLD_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_BL_HOLD_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_BL_HOLD_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_BL_HOLD_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_INT_Q_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_INT_Q_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_INT_Q_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_INT_Q_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_GAIN_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_GAIN_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_GAIN_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_GAIN_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_INT_SAMPLES_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_INT_SAMPLES_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_INT_SAMPLES_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_INT_SAMPLES_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
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
		REG_PRE_TRIGGER_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_PRE_TRIGGER_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_PRE_TRIGGER_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_PRE_TRIGGER_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_DELAY_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_DELAY_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_DELAY_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_DELAY_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
	BUS_Oscilloscope_0_READ_ADDRESS : OUT STD_LOGIC_VECTOR(11 downto 0); 
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
signal U1_out_0 : std_logic_vector(15 downto 0);
signal U2_CONST : INTEGER := 0;
signal U3_CONST : STD_LOGIC_VECTOR(0 downto 0) := (others => '0');
	signal U4_OUT : STD_LOGIC_VECTOR(15 DOWNTO 0);

	COMPONENT subtractor
		GENERIC( 
			N_BITS : INTEGER := 16;
			SIGN : STRING := "UNSIGNED";
			N_BITS_OUT : INTEGER := 16;
			LATCH_OUTPUT : BOOLEAN := true;
			SATURATE : BOOLEAN := true
		);
		PORT( 
			a_in : in STD_LOGIC_VECTOR(N_BITS-1 downto 0);
			b_in : in STD_LOGIC_VECTOR(N_BITS-1 downto 0);
			clk : in STD_LOGIC;
			reset : in STD_LOGIC;
			diff_out : out STD_LOGIC_VECTOR(N_BITS_OUT-1 downto 0)
		);
	END COMPONENT;

	signal U5_BASELINE : STD_LOGIC_VECTOR(15 DOWNTO 0);

	COMPONENT BASELINE_RESTORERp
		GENERIC( 
			wordWidth : INTEGER := 16;
			maxLength : INTEGER := 1024
		);
		PORT( 
			DATA_IN : in STD_LOGIC_VECTOR(WordWidth-1 downto 0);
			TRIGGER : in STD_LOGIC_VECTOR(0 downto 0);
			M_LENGTH : in INTEGER;
			BL_HOLD : in INTEGER;
			FLUSH : in STD_LOGIC_VECTOR(0 downto 0);
			CLK : in STD_LOGIC_VECTOR(0 downto 0);
			RESET : in STD_LOGIC_VECTOR(0 downto 0);
			CE : in STD_LOGIC_VECTOR(0 downto 0);
			BASELINE : out STD_LOGIC_VECTOR(WordWidth-1 downto 0);
			BASELINE_VALID : out STD_LOGIC_VECTOR(0 downto 0);
			HOLD_TIME : out STD_LOGIC_VECTOR(47 downto 0);
			RUNNING_NOT_HOLD : out STD_LOGIC_VECTOR(0 downto 0)
		);
	END COMPONENT;

signal U6_out_0 : integer;
signal U7_out_0 : integer;
	signal U8_DATA_OUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal U8_TRACKHOLD : STD_LOGIC_VECTOR(0 DOWNTO 0);

	COMPONENT PK_STRETCHERp
		GENERIC( 
			wordWidth : INTEGER := 16
		);
		PORT( 
			DATA_IN : in STD_LOGIC_VECTOR(WordWidth-1 downto 0);
			CLK : in STD_LOGIC_VECTOR(0 downto 0);
			RESET : in STD_LOGIC_VECTOR(0 downto 0);
			CE : in STD_LOGIC_VECTOR(0 downto 0);
			DATA_OUT : out STD_LOGIC_VECTOR(WordWidth-1 downto 0);
			TRACKHOLD : out STD_LOGIC_VECTOR(0 downto 0)
		);
	END COMPONENT;

	signal U9_MONITOR : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal U9_CHARGE : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal U9_DV : STD_LOGIC_VECTOR(0 downto 0) := "0";
	signal U9_INT_MON : STD_LOGIC_VECTOR(0 downto 0) := "0";

	COMPONENT xlx_qdc_UUJHQOSO
		PORT( 
			in1 : in STD_LOGIC_VECTOR(15 downto 0);
			base_line : in STD_LOGIC_VECTOR(15 downto 0);
			int_length : in STD_LOGIC_VECTOR(15 downto 0);
			pre_length : in STD_LOGIC_VECTOR(15 downto 0);
			gain : in STD_LOGIC_VECTOR(15 downto 0);
			offset : in STD_LOGIC_VECTOR(15 downto 0);
			pileup_inib : in STD_LOGIC_VECTOR(15 downto 0);
			trigger : in STD_LOGIC;
			pileup_rj_enable : in STD_LOGIC;
			ce_enable : in STD_LOGIC;
			monitor : out STD_LOGIC_VECTOR(15 downto 0);
			energy_out : out STD_LOGIC_VECTOR(15 downto 0);
			charge_monitor : out STD_LOGIC_VECTOR(31 downto 0);
			energy_trigger : out STD_LOGIC;
			p_integrate : out STD_LOGIC;
			p_pileup : out STD_LOGIC;
			p_busy : out STD_LOGIC;
			p_lost_flag : out STD_LOGIC;
			ap_clk : in STD_LOGIC;
			ap_rst : in STD_LOGIC
		);
	END COMPONENT;

	signal U10_CHARGE : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal U10_INT_MON : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal U11_out_0 : std_logic_vector(15 downto 0);
	signal BUS_Spectrum_0_READ_DATA : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal BUS_Spectrum_0_VLD : STD_LOGIC_VECTOR(0 DOWNTO 0);
	signal REG_Spectrum_0_STATUS_RD : STD_LOGIC_VECTOR(31 DOWNTO 0);

	COMPONENT xlx_spectrum
		GENERIC( 
			memLength : INTEGER := 1024;
			wordWidth : INTEGER := 16;
			CLK_FREQ : INTEGER := 125000
		);
		PORT( 
			ENERGY : in STD_LOGIC_VECTOR(15 downto 0);
			ENERGY_STROBE : in STD_LOGIC_VECTOR(0 downto 0);
			P_running : out STD_LOGIC_VECTOR(0 downto 0);
			P_acceptedPulse : out STD_LOGIC_VECTOR(0 downto 0);
			CLK_WRITE : in STD_LOGIC_VECTOR(0 downto 0);
			CE : in STD_LOGIC_VECTOR(0 downto 0);
			RESET : in STD_LOGIC_VECTOR(0 downto 0);
			CLK_READ : in STD_LOGIC_VECTOR(0 downto 0);
			READ_ADDRESS : in STD_LOGIC_VECTOR(15 downto 0);
			READ_DATA : out STD_LOGIC_VECTOR(31 downto 0);
			READ_INT : in STD_LOGIC_VECTOR(0 downto 0);
			READ_DATAVALID : out STD_LOGIC_VECTOR(0 downto 0);
			STATUS : out STD_LOGIC_VECTOR(31 downto 0);
			CONFIG : in STD_LOGIC_VECTOR(31 downto 0);
			CONFIG_LIMIT : in STD_LOGIC_VECTOR(31 downto 0);
			CONFIG_REBIN : in STD_LOGIC_VECTOR(31 downto 0);
			CONFIG_MIN : in STD_LOGIC_VECTOR(31 downto 0);
			CONFIG_MAX : in STD_LOGIC_VECTOR(31 downto 0)
		);
	END COMPONENT;

signal U13_CONST : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal U14_out_0 : std_logic_vector(15 downto 0);
	signal U15_OUT : STD_LOGIC_VECTOR(0 DOWNTO 0);

	COMPONENT SYNC_DELAYp
		GENERIC( 
			maxDelay : INTEGER := 1024;
			busWidth : INTEGER := 1
		);
		PORT( 
			PORT_IN : in STD_LOGIC_VECTOR(BusWidth-1 downto 0);
			DELAY : in INTEGER;
			PORT_OUT : out STD_LOGIC_VECTOR(BusWidth-1 downto 0);
			CLK : in STD_LOGIC_VECTOR(0 downto 0);
			RESET : in STD_LOGIC_VECTOR(0 downto 0)
		);
	END COMPONENT;

signal U16_out_0 : integer;
	signal BUS_Oscilloscope_0_READ_DATA : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal BUS_Oscilloscope_0_VLD : STD_LOGIC_VECTOR(0 DOWNTO 0);
	signal REG_Oscilloscope_0_READ_STATUS_RD : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal REG_Oscilloscope_0_READ_POSITION_RD : STD_LOGIC_VECTOR(31 DOWNTO 0);

	COMPONENT xlx_oscilloscope_sync
		GENERIC( 
			channels : INTEGER := 3;
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

	signal U18_DATA_OUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal U18_DERIVATE : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal U18_TRIGGER : STD_LOGIC_VECTOR(0 DOWNTO 0);

	COMPONENT TRIGGER_DERIVATIVEp
		GENERIC( 
			noise_filter : INTEGER := 1;
			wordWidth : INTEGER := 16;
			data_delay : INTEGER := 0
		);
		PORT( 
			PORT_IN : in STD_LOGIC_VECTOR(wordWidth-1 downto 0);
			THRESHOLD : in STD_LOGIC_VECTOR(wordWidth-1 downto 0);
			POLARITY : in STD_LOGIC_VECTOR(0 downto 0);
			TRIGGER_INIB : in INTEGER;
			CE : in STD_LOGIC_VECTOR(0 downto 0);
			CLK : in STD_LOGIC_VECTOR(0 downto 0);
			RESET : in STD_LOGIC_VECTOR(0 downto 0);
			DELAYED_DATA : out STD_LOGIC_VECTOR(wordWidth-1 downto 0);
			DERIVATIVE_DATA : out STD_LOGIC_VECTOR(wordWidth-1 downto 0);
			TRIGGER_OUT : out STD_LOGIC_VECTOR(0 downto 0)
		);
	END COMPONENT;

	signal BUS_List_0_READ_DATA : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal BUS_List_0_VLD : STD_LOGIC_VECTOR(0 DOWNTO 0);
	signal REG_List_0_STATUS_RD : STD_LOGIC_VECTOR(31 DOWNTO 0);

	COMPONENT listmodule
		GENERIC( 
			fifolength : INTEGER := 1024;
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

signal U20_OUT : std_logic_vector(64-1 downto 0) := (others => '0');
	signal U21_b : STD_LOGIC_VECTOR(15 DOWNTO 0);

	COMPONENT sigunsig
		GENERIC( 
			A_SIZE : INTEGER := 16;
			B_SIZE : INTEGER := 16;
			OPERATION : STRING := "sign_to_unsign"
		);
		PORT( 
			a : in STD_LOGIC_VECTOR(A_SIZE-1 downto 0);
			b : out STD_LOGIC_VECTOR(B_SIZE-1 downto 0)
		);
	END COMPONENT;

signal U22_out_0 : std_logic_vector(15 downto 0);
signal U23_out_0 : std_logic_vector(15 downto 0);
	signal BUS_Spectrum_0_READ_ADDRESS : STD_LOGIC_VECTOR(15 downto 0);
	signal BUS_Spectrum_0_WRITE_DATA : STD_LOGIC_VECTOR(31 downto 0);
	signal BUS_Spectrum_0_W_INT : STD_LOGIC_VECTOR(0 downto 0);
	signal BUS_Spectrum_0_R_INT : STD_LOGIC_VECTOR(0 downto 0);
	signal INT_Spectrum_0_STATUS_RD : STD_LOGIC_VECTOR(0 downto 0);
	signal REG_Spectrum_0_CONFIG_WR : STD_LOGIC_VECTOR(31 downto 0);
	signal INT_Spectrum_0_CONFIG_WR : STD_LOGIC_VECTOR(0 downto 0);
	signal REG_Spectrum_0_CONFIG_LIMIT_WR : STD_LOGIC_VECTOR(31 downto 0);
	signal INT_Spectrum_0_CONFIG_LIMIT_WR : STD_LOGIC_VECTOR(0 downto 0);
	signal REG_Spectrum_0_CONFIG_REBIN_WR : STD_LOGIC_VECTOR(31 downto 0);
	signal INT_Spectrum_0_CONFIG_REBIN_WR : STD_LOGIC_VECTOR(0 downto 0);
	signal REG_Spectrum_0_CONFIG_MIN_WR : STD_LOGIC_VECTOR(31 downto 0);
	signal INT_Spectrum_0_CONFIG_MIN_WR : STD_LOGIC_VECTOR(0 downto 0);
	signal REG_Spectrum_0_CONFIG_MAX_WR : STD_LOGIC_VECTOR(31 downto 0);
	signal INT_Spectrum_0_CONFIG_MAX_WR : STD_LOGIC_VECTOR(0 downto 0);
	signal BUS_Oscilloscope_0_READ_ADDRESS : STD_LOGIC_VECTOR(11 downto 0);
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
	signal BUS_List_0_READ_ADDRESS : STD_LOGIC_VECTOR(-1 downto 0);
	signal BUS_List_0_WRITE_DATA : STD_LOGIC_VECTOR(31 downto 0);
	signal BUS_List_0_W_INT : STD_LOGIC_VECTOR(0 downto 0);
	signal BUS_List_0_R_INT : STD_LOGIC_VECTOR(0 downto 0);
	signal INT_List_0_STATUS_RD : STD_LOGIC_VECTOR(0 downto 0);
	signal REG_List_0_CONFIG_WR : STD_LOGIC_VECTOR(31 downto 0);
	signal INT_List_0_CONFIG_WR : STD_LOGIC_VECTOR(0 downto 0);
	signal REG_THRESHOLD_RD : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal REG_THRESHOLD_WR : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal INT_THRESHOLD_WR : STD_LOGIC_VECTOR(0 downto 0); 
	signal INT_THRESHOLD_RD : STD_LOGIC_VECTOR(0 downto 0); 
	signal REG_M_LENGTH_RD : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal REG_M_LENGTH_WR : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal INT_M_LENGTH_WR : STD_LOGIC_VECTOR(0 downto 0); 
	signal INT_M_LENGTH_RD : STD_LOGIC_VECTOR(0 downto 0); 
	signal REG_BL_HOLD_RD : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal REG_BL_HOLD_WR : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal INT_BL_HOLD_WR : STD_LOGIC_VECTOR(0 downto 0); 
	signal INT_BL_HOLD_RD : STD_LOGIC_VECTOR(0 downto 0); 
	signal REG_INT_Q_RD : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal REG_INT_Q_WR : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal INT_INT_Q_WR : STD_LOGIC_VECTOR(0 downto 0); 
	signal INT_INT_Q_RD : STD_LOGIC_VECTOR(0 downto 0); 
	signal REG_GAIN_RD : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal REG_GAIN_WR : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal INT_GAIN_WR : STD_LOGIC_VECTOR(0 downto 0); 
	signal INT_GAIN_RD : STD_LOGIC_VECTOR(0 downto 0); 
	signal REG_INT_SAMPLES_RD : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal REG_INT_SAMPLES_WR : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal INT_INT_SAMPLES_WR : STD_LOGIC_VECTOR(0 downto 0); 
	signal INT_INT_SAMPLES_RD : STD_LOGIC_VECTOR(0 downto 0); 
	signal REG_PRE_TRIGGER_RD : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal REG_PRE_TRIGGER_WR : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal INT_PRE_TRIGGER_WR : STD_LOGIC_VECTOR(0 downto 0); 
	signal INT_PRE_TRIGGER_RD : STD_LOGIC_VECTOR(0 downto 0); 
	signal REG_DELAY_RD : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal REG_DELAY_WR : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal INT_DELAY_WR : STD_LOGIC_VECTOR(0 downto 0); 
	signal INT_DELAY_RD : STD_LOGIC_VECTOR(0 downto 0); 

	
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
		REG_M_LENGTH_RD => REG_M_LENGTH_RD,
		REG_M_LENGTH_WR => REG_M_LENGTH_WR,
		INT_M_LENGTH_RD => INT_M_LENGTH_RD,
		INT_M_LENGTH_WR => INT_M_LENGTH_WR,
		REG_BL_HOLD_RD => REG_BL_HOLD_RD,
		REG_BL_HOLD_WR => REG_BL_HOLD_WR,
		INT_BL_HOLD_RD => INT_BL_HOLD_RD,
		INT_BL_HOLD_WR => INT_BL_HOLD_WR,
		REG_INT_Q_RD => REG_INT_Q_RD,
		REG_INT_Q_WR => REG_INT_Q_WR,
		INT_INT_Q_RD => INT_INT_Q_RD,
		INT_INT_Q_WR => INT_INT_Q_WR,
		REG_GAIN_RD => REG_GAIN_RD,
		REG_GAIN_WR => REG_GAIN_WR,
		INT_GAIN_RD => INT_GAIN_RD,
		INT_GAIN_WR => INT_GAIN_WR,
		REG_INT_SAMPLES_RD => REG_INT_SAMPLES_RD,
		REG_INT_SAMPLES_WR => REG_INT_SAMPLES_WR,
		INT_INT_SAMPLES_RD => INT_INT_SAMPLES_RD,
		INT_INT_SAMPLES_WR => INT_INT_SAMPLES_WR,
	BUS_Spectrum_0_READ_ADDRESS => BUS_Spectrum_0_READ_ADDRESS,
	BUS_Spectrum_0_READ_DATA => BUS_Spectrum_0_READ_DATA,
	BUS_Spectrum_0_WRITE_DATA => BUS_Spectrum_0_WRITE_DATA,
	BUS_Spectrum_0_W_INT => BUS_Spectrum_0_W_INT,
	BUS_Spectrum_0_R_INT => BUS_Spectrum_0_R_INT,
	BUS_Spectrum_0_VLD => BUS_Spectrum_0_VLD,
		REG_Spectrum_0_STATUS_RD => REG_Spectrum_0_STATUS_RD,
		INT_Spectrum_0_STATUS_RD => INT_Spectrum_0_STATUS_RD,
		REG_Spectrum_0_CONFIG_WR => REG_Spectrum_0_CONFIG_WR,
		INT_Spectrum_0_CONFIG_WR => INT_Spectrum_0_CONFIG_WR,
		REG_Spectrum_0_CONFIG_RD => REG_Spectrum_0_CONFIG_WR,
		REG_Spectrum_0_CONFIG_LIMIT_WR => REG_Spectrum_0_CONFIG_LIMIT_WR,
		INT_Spectrum_0_CONFIG_LIMIT_WR => INT_Spectrum_0_CONFIG_LIMIT_WR,
		REG_Spectrum_0_CONFIG_LIMIT_RD => REG_Spectrum_0_CONFIG_LIMIT_WR,
		REG_Spectrum_0_CONFIG_REBIN_WR => REG_Spectrum_0_CONFIG_REBIN_WR,
		INT_Spectrum_0_CONFIG_REBIN_WR => INT_Spectrum_0_CONFIG_REBIN_WR,
		REG_Spectrum_0_CONFIG_REBIN_RD => REG_Spectrum_0_CONFIG_REBIN_WR,
		REG_Spectrum_0_CONFIG_MIN_WR => REG_Spectrum_0_CONFIG_MIN_WR,
		INT_Spectrum_0_CONFIG_MIN_WR => INT_Spectrum_0_CONFIG_MIN_WR,
		REG_Spectrum_0_CONFIG_MIN_RD => REG_Spectrum_0_CONFIG_MIN_WR,
		REG_Spectrum_0_CONFIG_MAX_WR => REG_Spectrum_0_CONFIG_MAX_WR,
		INT_Spectrum_0_CONFIG_MAX_WR => INT_Spectrum_0_CONFIG_MAX_WR,
		REG_Spectrum_0_CONFIG_MAX_RD => REG_Spectrum_0_CONFIG_MAX_WR,
		REG_PRE_TRIGGER_RD => REG_PRE_TRIGGER_RD,
		REG_PRE_TRIGGER_WR => REG_PRE_TRIGGER_WR,
		INT_PRE_TRIGGER_RD => INT_PRE_TRIGGER_RD,
		INT_PRE_TRIGGER_WR => INT_PRE_TRIGGER_WR,
		REG_DELAY_RD => REG_DELAY_RD,
		REG_DELAY_WR => REG_DELAY_WR,
		INT_DELAY_RD => INT_DELAY_RD,
		INT_DELAY_WR => INT_DELAY_WR,
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
		REG_UNIQUE_RD => x"33FFB629",
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
U1_out_0 <= REG_THRESHOLD_WR(15 downto 0);
REG_THRESHOLD_RD  <= REG_THRESHOLD_WR;
U2_CONST <= 10;
U3_CONST <= conv_std_logic_vector(1,1);

	U4 : subtractor
	Generic map(
		N_BITS => 	16,
		SIGN => 	"UNSIGNED",
		N_BITS_OUT => 	16,
		LATCH_OUTPUT => 	true,
		SATURATE => 	true
	)
	PORT MAP(
		a_in => U18_DATA_OUT,
		b_in => U5_BASELINE,
		clk => GlobalClock(0),
		reset => GlobalReset(0),
		diff_out => U4_OUT
	);


	U5 : BASELINE_RESTORERp
	Generic map(
		wordWidth => 	16,
		maxLength => 	1024
	)
	PORT MAP(
		DATA_IN => U18_DATA_OUT,
		TRIGGER => U18_TRIGGER,
		M_LENGTH => U6_out_0,
		BL_HOLD => U7_out_0,
		FLUSH => "0",
		CLK => GlobalClock,
		RESET => GlobalReset,
		CE => "1",
		BASELINE => U5_BASELINE,
		BASELINE_VALID => open,
		HOLD_TIME => open,
		RUNNING_NOT_HOLD => open
	);

U6_out_0 <= conv_integer(REG_M_LENGTH_WR);
REG_M_LENGTH_RD  <= REG_M_LENGTH_WR;
U7_out_0 <= conv_integer(REG_BL_HOLD_WR);
REG_BL_HOLD_RD  <= REG_BL_HOLD_WR;

	U8 : PK_STRETCHERp
	Generic map(
		wordWidth => 	16
	)
	PORT MAP(
		DATA_IN => U21_b,
		CLK => GlobalClock,
		RESET => U18_TRIGGER,
		CE => "1",
		DATA_OUT => U8_DATA_OUT,
		TRACKHOLD => U8_TRACKHOLD
	);


	U9 : xlx_qdc_UUJHQOSO
	PORT MAP(
		in1 => U18_DATA_OUT,
		base_line => U5_BASELINE,
		int_length => U11_out_0,
		pre_length => U14_out_0,
		gain => U23_out_0,
		offset => x"0000",
		pileup_inib => x"0000",
		trigger => U18_TRIGGER(0),
		pileup_rj_enable => '0',
		ce_enable => '1',
		monitor => U9_MONITOR,
		energy_out => U9_CHARGE,
		charge_monitor => open,
		energy_trigger => U9_DV(0),
		p_integrate => U9_INT_MON(0),
		p_pileup => open,
		p_busy => open,
		p_lost_flag => open,
		ap_clk => CLK_ACQ(0),
		ap_rst => GlobalReset(0)
	);


	U10 : xlx_qdc_UUJHQOSO
	PORT MAP(
		in1 => U18_DATA_OUT,
		base_line => U5_BASELINE,
		int_length => U22_out_0,
		pre_length => U14_out_0,
		gain => U23_out_0,
		offset => x"0000",
		pileup_inib => x"0000",
		trigger => U15_OUT(0),
		pileup_rj_enable => '0',
		ce_enable => '1',
		monitor => open,
		energy_out => U10_CHARGE,
		charge_monitor => open,
		energy_trigger => open,
		p_integrate => U10_INT_MON(0),
		p_pileup => open,
		p_busy => open,
		p_lost_flag => open,
		ap_clk => CLK_ACQ(0),
		ap_rst => GlobalReset(0)
	);

U11_out_0 <= REG_INT_Q_WR(15 downto 0);
REG_INT_Q_RD  <= REG_INT_Q_WR;

	U12 : xlx_spectrum
	Generic map(
		memLength => 	1024,
		wordWidth => 	16,
		CLK_FREQ => 	125000
	)
	PORT MAP(
		ENERGY => U9_CHARGE,
		ENERGY_STROBE => U9_DV,
		P_running => open,
		P_acceptedPulse => open,
		CLK_WRITE => CLK_ACQ,
		CE => "1",
		RESET => GlobalReset,
		CLK_READ => BUS_CLK,
		READ_ADDRESS => BUS_Spectrum_0_READ_ADDRESS,
		READ_DATA => BUS_Spectrum_0_READ_DATA,
		READ_INT => BUS_Spectrum_0_R_INT,
		READ_DATAVALID => BUS_Spectrum_0_VLD,
		STATUS => REG_Spectrum_0_STATUS_RD,
		CONFIG => REG_Spectrum_0_CONFIG_WR,
		CONFIG_LIMIT => REG_Spectrum_0_CONFIG_LIMIT_WR,
		CONFIG_REBIN => REG_Spectrum_0_CONFIG_REBIN_WR,
		CONFIG_MIN => REG_Spectrum_0_CONFIG_MIN_WR,
		CONFIG_MAX => REG_Spectrum_0_CONFIG_MAX_WR
	);

U13_CONST <= conv_std_logic_vector(0000,16);
U14_out_0 <= REG_PRE_TRIGGER_WR(15 downto 0);
REG_PRE_TRIGGER_RD  <= REG_PRE_TRIGGER_WR;

	U15 : SYNC_DELAYp
	Generic map(
		maxDelay => 	1024,
		busWidth => 	1
	)
	PORT MAP(
		PORT_IN => U18_TRIGGER,
		DELAY => U16_out_0,
		PORT_OUT => U15_OUT,
		CLK => CLK_ACQ,
		RESET => GlobalReset
	);

U16_out_0 <= conv_integer(REG_DELAY_WR);
REG_DELAY_RD  <= REG_DELAY_WR;

	U17 : xlx_oscilloscope_sync
	Generic map(
		channels => 	3,
		memLength => 	1024,
		wordWidth => 	16
	)
	PORT MAP(
		ANALOG => U18_DERIVATE & U8_DATA_OUT & U9_MONITOR,
		D0 => "0" & U10_INT_MON & U18_TRIGGER,
		D1 => "0" & "0" & U9_DV,
		D2 => "0" & "0" & U9_INT_MON,
		D3 => "0" & "0" & U8_TRACKHOLD,
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


	U18 : TRIGGER_DERIVATIVEp
	Generic map(
		noise_filter => 	1,
		wordWidth => 	16,
		data_delay => 	0
	)
	PORT MAP(
		PORT_IN => U0_A0,
		THRESHOLD => U1_out_0,
		POLARITY => U3_CONST,
		TRIGGER_INIB => U2_CONST,
		CE => "1",
		CLK => GlobalClock,
		RESET => GlobalReset,
		DELAYED_DATA => U18_DATA_OUT,
		DERIVATIVE_DATA => U18_DERIVATE,
		TRIGGER_OUT => U18_TRIGGER
	);


	U19 : listmodule
	Generic map(
		fifolength => 	1024,
		bitsize => 	64,
		channels => 	1
	)
	PORT MAP(
		DATAIN => U20_OUT,
		WE => U9_DV,
		FULL => open,
		BUSY => open,
		RUNNING => open,
		CLEAR => open,
		RESET => GlobalReset,
		CLK_WRITE => CLK_ACQ,
		CLK_READ => BUS_CLK,
		READ_DATA => BUS_List_0_READ_DATA,
		READ_DATAVALID => BUS_List_0_VLD,
		READ_NEXT => BUS_List_0_R_INT,
		STATUS => REG_List_0_STATUS_RD,
		CONFIG => REG_List_0_CONFIG_WR
	);

U20_OUT <= U13_CONST & U8_DATA_OUT & U9_CHARGE & U10_CHARGE;

	U21 : sigunsig
	Generic map(
		A_SIZE => 	16,
		B_SIZE => 	16,
		OPERATION => 	"sign_to_unsign"
	)
	PORT MAP(
		a => U4_OUT,
		b => U21_b
	);

U22_out_0 <= REG_INT_SAMPLES_WR(15 downto 0);
REG_INT_SAMPLES_RD  <= REG_INT_SAMPLES_WR;
U23_out_0 <= REG_GAIN_WR(15 downto 0);
REG_GAIN_RD  <= REG_GAIN_WR;

		 
end Behavioral;

 