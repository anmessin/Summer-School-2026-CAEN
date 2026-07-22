library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_MISC.ALL;
use ieee.numeric_std.all;
use ieee.math_real.all;



entity SUBPAGE_subdesign_1 is
    Port (	
		AN : in std_logic_vector(15 downto 0);
PEAK_DELAY : in std_logic_vector(15 downto 0);
BL_M : in std_logic_vector(15 downto 0);
BL_HOLD : in std_logic_vector(15 downto 0);
TIMESTAMPO : in std_logic_vector(39 downto 0);
DATA : out std_logic_vector(55 downto 0);
DATA_VALID : out std_logic_vector(0 downto 0);

		async_clk : in std_logic_vector (0 downto 0);
		CLK_ACQ : in std_logic_vector (0 downto 0);
		BUS_CLK : in std_logic_vector (0 downto 0);
		CLK_40 : in std_logic_vector (0 downto 0);
		CLK_50 : in std_logic_vector (0 downto 0);
		CLK_80 : in std_logic_vector (0 downto 0);
		clk_160 : in std_logic_vector (0 downto 0);
		clk_320 : in std_logic_vector (0 downto 0);
		CLK_125 : in std_logic_vector(0 downto 0);
		FAST_CLK_100 : in std_logic_vector (0 downto 0);
		FAST_CLK_200 : in std_logic_vector (0 downto 0);
		FAST_CLK_250 : in std_logic_vector (0 downto 0);
		FAST_CLK_250_90 : in std_logic_vector (0 downto 0);
		FAST_CLK_500 : in std_logic_vector (0 downto 0);
		FAST_CLK_500_90 : in std_logic_vector (0 downto 0);
		GlobalClock : in std_logic_vector (0 downto 0);
		GlobalReset : in std_logic_vector (0 downto 0);
		BUS_READ_DATA : OUT STD_LOGIC_VECTOR(31 downto 0);
		BUS_ADDRESS : IN STD_LOGIC_VECTOR(31 downto 0); 
		BUS_WRITE_DATA : IN STD_LOGIC_VECTOR(31 downto 0); 
		BUS_INT_RD : IN STD_LOGIC_VECTOR(0 downto 0); 
		BUS_INT_WR : IN STD_LOGIC_VECTOR(0 downto 0); 
		BUS_VLD : OUT STD_LOGIC_VECTOR(0 downto 0)
 );
end SUBPAGE_subdesign_1;

architecture Behavioral of SUBPAGE_subdesign_1 is
signal U0_AN : std_logic_vector(15 downto 0);
	signal U1_DATA_OUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal U1_TRIGGER : STD_LOGIC_VECTOR(0 DOWNTO 0);

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

signal U2_CONST : STD_LOGIC_VECTOR(0 downto 0) := (others => '0');
signal U3_out_0 : std_logic_vector(15 downto 0);
signal U4_out_0 : std_logic_vector(15 downto 0);
signal U5_CONST : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
	signal U6_BASELINE : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal U6_RUNNING_NOT_HOLD : STD_LOGIC_VECTOR(0 DOWNTO 0);

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

	signal U7_INT : INTEGER := 0;

	COMPONENT BinaryToInteger
		GENERIC( 
			N_BITS : INTEGER := 16;
			SIGN : STRING := "UNSIGNED"
		);
		PORT( 
			slv_in : in STD_LOGIC_VECTOR(N_BITS -1 downto 0);
			int_out : out INTEGER
		);
	END COMPONENT;

	signal U8_OUT : STD_LOGIC_VECTOR(15 DOWNTO 0);

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

	signal U9_DATA_OUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal U9_TRACKHOLD : STD_LOGIC_VECTOR(0 DOWNTO 0);

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

	signal U10_INT : INTEGER := 0;
	signal BUS_Spectrum_0_READ_DATA : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal BUS_Spectrum_0_VLD : STD_LOGIC_VECTOR(0 DOWNTO 0);
	signal REG_Spectrum_0_STATUS_RD : STD_LOGIC_VECTOR(31 DOWNTO 0);

	COMPONENT xlx_spectrum
		GENERIC( 
			memLength : INTEGER := 4096;
			wordWidth : INTEGER := 32;
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

	signal U12_OUT : STD_LOGIC_VECTOR(0 DOWNTO 0);

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

	signal U13_INT : INTEGER := 0;
signal U14_PEAK_DELAY : std_logic_vector(15 downto 0);
	signal BUS_Oscilloscope_0_READ_DATA : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal BUS_Oscilloscope_0_VLD : STD_LOGIC_VECTOR(0 DOWNTO 0);
	signal REG_Oscilloscope_0_READ_STATUS_RD : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal REG_Oscilloscope_0_READ_POSITION_RD : STD_LOGIC_VECTOR(31 DOWNTO 0);

	COMPONENT xlx_oscilloscope_sync
		GENERIC( 
			channels : INTEGER := 4;
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

	signal U16_OUT : STD_LOGIC_VECTOR(15 DOWNTO 0);

	COMPONENT SYNC_FIX_DELAYp
		GENERIC( 
			DelayValue : INTEGER := 32;
			busWidth : INTEGER := 16
		);
		PORT( 
			PORT_IN : in STD_LOGIC_VECTOR(BusWidth-1 downto 0);
			PORT_OUT : out STD_LOGIC_VECTOR(BusWidth-1 downto 0);
			CLK : in STD_LOGIC_VECTOR(0 downto 0);
			RESET : in STD_LOGIC_VECTOR(0 downto 0)
		);
	END COMPONENT;

signal U17_BL_M : std_logic_vector(15 downto 0);
signal U18_BL_HOLD : std_logic_vector(15 downto 0);
signal U19_TIMESTAMPO : std_logic_vector(39 downto 0);
signal U20_OUT : std_logic_vector(56-1 downto 0) := (others => '0');
	signal REG_THRESHOLD_RD : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 

	signal REG_THRESHOLD_WR : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 

	signal INT_THRESHOLD_WR : STD_LOGIC_VECTOR(0 downto 0); 

	signal INT_THRESHOLD_RD : STD_LOGIC_VECTOR(0 downto 0); 

	signal REG_DELTA_RD : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 

	signal REG_DELTA_WR : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"; 

	signal INT_DELTA_WR : STD_LOGIC_VECTOR(0 downto 0); 

	signal INT_DELTA_RD : STD_LOGIC_VECTOR(0 downto 0); 

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


COMPONENT subdesign_1_pmc IS
    Port (  clk : in STD_LOGIC;
            reset : in STD_LOGIC;
			
	        -- Register interface          
		REG_THRESHOLD_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_THRESHOLD_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_THRESHOLD_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_THRESHOLD_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_DELTA_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_DELTA_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_DELTA_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_DELTA_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
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
	

            BUS_READ_DATA : OUT STD_LOGIC_VECTOR(31 downto 0);
			BUS_ADDRESS : IN STD_LOGIC_VECTOR(31 downto 0); 
			BUS_WRITE_DATA : IN STD_LOGIC_VECTOR(31 downto 0); 
			BUS_INT_RD : IN STD_LOGIC_VECTOR(0 downto 0); 
			BUS_INT_WR : IN STD_LOGIC_VECTOR(0 downto 0); 
			BUS_VLD : OUT STD_LOGIC_VECTOR(0 downto 0)        


    );
END COMPONENT;


begin
U0_AN <= AN;

	subdesign_1_U1 : trigger_le_delta
	Generic map(
		ADC_nbits => 	16
	)
	PORT MAP(
		CLK => CLK_ACQ,
		RESET => "1",
		DATA_IN => U0_AN,
		POLARITY => U2_CONST,
		THRESHOLD => U3_out_0,
		DELTA => U4_out_0,
		INIBIT => U5_CONST,
		DATA_OUT => U1_DATA_OUT,
		TRIGGER_OUT => U1_TRIGGER,
		TOT_OUT => open
	);

U2_CONST <= conv_std_logic_vector(1,1);
U3_out_0 <= REG_THRESHOLD_WR(15 downto 0);
REG_THRESHOLD_RD  <= REG_THRESHOLD_WR;
U4_out_0 <= REG_DELTA_WR(15 downto 0);
REG_DELTA_RD  <= REG_DELTA_WR;
U5_CONST <= conv_std_logic_vector(10,16);

	subdesign_1_U6 : BASELINE_RESTORERp
	Generic map(
		wordWidth => 	16,
		maxLength => 	1024
	)
	PORT MAP(
		DATA_IN => U16_OUT,
		TRIGGER => U1_TRIGGER,
		M_LENGTH => U7_INT,
		BL_HOLD => U10_INT,
		FLUSH => "0",
		CLK => GlobalClock,
		RESET => GlobalReset,
		CE => "1",
		BASELINE => U6_BASELINE,
		BASELINE_VALID => open,
		HOLD_TIME => open,
		RUNNING_NOT_HOLD => U6_RUNNING_NOT_HOLD
	);


	subdesign_1_U7 : BinaryToInteger
	Generic map(
		N_BITS => 	16,
		SIGN => 	"UNSIGNED"
	)
	PORT MAP(
		slv_in => U17_BL_M,
		int_out => U7_INT
	);


	subdesign_1_U8 : subtractor
	Generic map(
		N_BITS => 	16,
		SIGN => 	"UNSIGNED",
		N_BITS_OUT => 	16,
		LATCH_OUTPUT => 	true,
		SATURATE => 	true
	)
	PORT MAP(
		a_in => U1_DATA_OUT,
		b_in => U6_BASELINE,
		clk => GlobalClock(0),
		reset => GlobalReset(0),
		diff_out => U8_OUT
	);


	subdesign_1_U9 : PK_STRETCHERp
	Generic map(
		wordWidth => 	16
	)
	PORT MAP(
		DATA_IN => U8_OUT,
		CLK => GlobalClock,
		RESET => U1_TRIGGER,
		CE => "1",
		DATA_OUT => U9_DATA_OUT,
		TRACKHOLD => U9_TRACKHOLD
	);


	subdesign_1_U10 : BinaryToInteger
	Generic map(
		N_BITS => 	16,
		SIGN => 	"UNSIGNED"
	)
	PORT MAP(
		slv_in => U18_BL_HOLD,
		int_out => U10_INT
	);


	subdesign_1_U11 : xlx_spectrum
	Generic map(
		memLength => 	4096,
		wordWidth => 	32,
		CLK_FREQ => 	125000
	)
	PORT MAP(
		ENERGY => U9_DATA_OUT,
		ENERGY_STROBE => U12_OUT,
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


	subdesign_1_U12 : SYNC_DELAYp
	Generic map(
		maxDelay => 	1024,
		busWidth => 	1
	)
	PORT MAP(
		PORT_IN => U1_TRIGGER,
		DELAY => U13_INT,
		PORT_OUT => U12_OUT,
		CLK => CLK_ACQ,
		RESET => GlobalReset
	);


	subdesign_1_U13 : BinaryToInteger
	Generic map(
		N_BITS => 	16,
		SIGN => 	"UNSIGNED"
	)
	PORT MAP(
		slv_in => U14_PEAK_DELAY,
		int_out => U13_INT
	);

U14_PEAK_DELAY <= PEAK_DELAY;

	subdesign_1_U15 : xlx_oscilloscope_sync
	Generic map(
		channels => 	4,
		memLength => 	1024,
		wordWidth => 	16
	)
	PORT MAP(
		ANALOG => U9_DATA_OUT & U8_OUT & U6_BASELINE & U1_DATA_OUT,
		D0 => "0" & "0" & "0" & U1_TRIGGER,
		D1 => "0" & "0" & "0" & U6_RUNNING_NOT_HOLD,
		D2 => "0" & "0" & "0" & U9_TRACKHOLD,
		D3 => "0" & "0" & "0" & U12_OUT,
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


	subdesign_1_U16 : SYNC_FIX_DELAYp
	Generic map(
		DelayValue => 	32,
		busWidth => 	16
	)
	PORT MAP(
		PORT_IN => U1_DATA_OUT,
		PORT_OUT => U16_OUT,
		CLK => CLK_ACQ,
		RESET => GlobalReset
	);

U17_BL_M <= BL_M;
U18_BL_HOLD <= BL_HOLD;
U19_TIMESTAMPO <= TIMESTAMPO;
U20_OUT <= U19_TIMESTAMPO & U9_DATA_OUT;
DATA <= U20_OUT;
DATA_VALID <= U12_OUT;

pmc_inst : subdesign_1_pmc 
    port map (
        clk => BUS_CLK(0),
        reset => GlobalReset(0),
    		REG_THRESHOLD_RD => REG_THRESHOLD_RD,
		REG_THRESHOLD_WR => REG_THRESHOLD_WR,
		INT_THRESHOLD_RD => INT_THRESHOLD_RD,
		INT_THRESHOLD_WR => INT_THRESHOLD_WR,
		REG_DELTA_RD => REG_DELTA_RD,
		REG_DELTA_WR => REG_DELTA_WR,
		INT_DELTA_RD => INT_DELTA_RD,
		INT_DELTA_WR => INT_DELTA_WR,
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

        BUS_READ_DATA => BUS_READ_DATA,
        BUS_ADDRESS => BUS_ADDRESS,
        BUS_WRITE_DATA => BUS_WRITE_DATA,
        BUS_INT_RD => BUS_INT_RD,
        BUS_INT_WR => BUS_INT_WR,
        BUS_VLD => BUS_VLD
);

end Behavioral;
