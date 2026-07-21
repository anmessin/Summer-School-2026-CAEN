----------------------------------------------------------------------------------
-- Company: 	Nuclear Instruments SRL
-- Engineer: 	Andrea Abba
-- 
-- Create Date: 07.06.2020 10:24:18
-- Design Name: SciDK Scicompiler Development Kit
-- Module Name: TOP_lab1ledlblink
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
    
entity TOP_lab1ledlblink is
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
end TOP_lab1ledlblink;

architecture Behavioral of TOP_lab1ledlblink is
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
				REG_PULSE_PERIOD_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_PULSE_PERIOD_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_PULSE_PERIOD_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_PULSE_PERIOD_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_PULSE_WIDTH_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_PULSE_WIDTH_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_PULSE_WIDTH_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_PULSE_WIDTH_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
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

	
		signal U2_PULSE : STD_LOGIC_VECTOR(0 DOWNTO 0);

	COMPONENT PULSE_GENERATOR
		PORT( 
			PULSE_OUT : out STD_LOGIC_VECTOR(0 downto 0);
			PULSE_PERIOD : in STD_LOGIC_VECTOR(31 downto 0);
			PULSE_WIDTH : in STD_LOGIC_VECTOR(31 downto 0);
			CE : in STD_LOGIC_VECTOR(0 downto 0);
			CLK : in STD_LOGIC_VECTOR(0 downto 0);
			RESET : in STD_LOGIC_VECTOR(0 downto 0)
		);
	END COMPONENT;

	signal U3_OUT : STD_LOGIC_VECTOR(0 DOWNTO 0);
signal U4_out_0 : std_logic_vector(31 downto 0);
signal U5_out_0 : std_logic_vector(31 downto 0);
	signal REG_PULSE_PERIOD_RD : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal REG_PULSE_PERIOD_WR : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal INT_PULSE_PERIOD_WR : STD_LOGIC_VECTOR(0 downto 0); 
	signal INT_PULSE_PERIOD_RD : STD_LOGIC_VECTOR(0 downto 0); 
	signal REG_PULSE_WIDTH_RD : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal REG_PULSE_WIDTH_WR : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 
	signal INT_PULSE_WIDTH_WR : STD_LOGIC_VECTOR(0 downto 0); 
	signal INT_PULSE_WIDTH_RD : STD_LOGIC_VECTOR(0 downto 0); 

	
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
				REG_PULSE_PERIOD_RD => REG_PULSE_PERIOD_RD,
		REG_PULSE_PERIOD_WR => REG_PULSE_PERIOD_WR,
		INT_PULSE_PERIOD_RD => INT_PULSE_PERIOD_RD,
		INT_PULSE_PERIOD_WR => INT_PULSE_PERIOD_WR,
		REG_PULSE_WIDTH_RD => REG_PULSE_WIDTH_RD,
		REG_PULSE_WIDTH_WR => REG_PULSE_WIDTH_WR,
		INT_PULSE_WIDTH_RD => INT_PULSE_WIDTH_RD,
		INT_PULSE_WIDTH_WR => INT_PULSE_WIDTH_WR,
		REG_UNIQUE_RD => x"12724658",
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
    


	
	LED_1 <= U3_OUT;
LED_0 <= U2_PULSE;

	U2 : PULSE_GENERATOR
	PORT MAP(
		PULSE_OUT => U2_PULSE,
		PULSE_PERIOD => U4_out_0,
		PULSE_WIDTH => U5_out_0,
		CE => "1",
		CLK => GlobalClock,
		RESET => GlobalReset
	);

U3_OUT <= NOT U2_PULSE;
U4_out_0 <= REG_PULSE_PERIOD_WR(31 downto 0);
REG_PULSE_PERIOD_RD  <= REG_PULSE_PERIOD_WR;
U5_out_0 <= REG_PULSE_WIDTH_WR(31 downto 0);
REG_PULSE_WIDTH_RD  <= REG_PULSE_WIDTH_WR;

		 
end Behavioral;

 