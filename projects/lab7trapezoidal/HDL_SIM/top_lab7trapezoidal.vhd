----------------------------------------------------------------------------------
-- Company: 	Nuclear Instruments SRL
-- Engineer: 	Andrea Abba
-- 
-- Create Date: 07.06.2020 10:24:18
-- Design Name: SciDK Scicompiler Development Kit
-- Module Name: TOP_lab7trapezoidal
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
    
entity TOP_lab7trapezoidal is
    Port (  
		    
        

            Probe0 : out STD_LOGIC_VECTOR(15 downto 0);
Probe1 : out STD_LOGIC_VECTOR(15 downto 0);
Probe2 : out STD_LOGIC_VECTOR(31 downto 0);
Probe3 : out STD_LOGIC_VECTOR(31 downto 0);
Probe4 : out STD_LOGIC_VECTOR(63 downto 0);
A0 : in STD_LOGIC_VECTOR(15 downto 0);
CLK_ACQ_s : in std_logic;
async_clk_s : in std_logic;
GlobalClock_s : in std_logic;
FAST_CLK_100_s : in std_logic;
CLK_125_s : in std_logic;


			lemo_a : inout STD_LOGIC;
			lemo_b : inout STD_LOGIC
                              
                              
			  ); 
end TOP_lab7trapezoidal;

architecture Behavioral of TOP_lab7trapezoidal is
	attribute keep : string;     
	
	

    signal sample_clk : std_logic;
    signal async_clk : std_logic_vector (0 downto 0) := "0";
    signal GlobalClock : std_logic_vector (0 downto 0) := "0";
    signal BUS_CLK : std_logic_vector (0 downto 0) := "0";
    signal GlobalReset : std_logic_vector (0 downto 0) := "0";       
	signal CLK_ACQ : std_logic_vector (0 downto 0) := "0";
	
    signal mcg_lock : std_logic;
    signal REG_OFFSET :  STD_LOGIC_VECTOR(31 downto 0); 
    signal REG_OFFSET_WR :  STD_LOGIC_VECTOR(0 downto 0); 
    
		
	
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
	
	

	signal U0_A0 : std_logic_vector(15 downto 0);
signal U1_CONST : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
	signal U7_OUT : STD_LOGIC_VECTOR(15 DOWNTO 0);

	COMPONENT SYNC_FIX_DELAYp
		GENERIC( 
			DelayValue : INTEGER := 100;
			busWidth : INTEGER := 16
		);
		PORT( 
			PORT_IN : in STD_LOGIC_VECTOR(BusWidth-1 downto 0);
			PORT_OUT : out STD_LOGIC_VECTOR(BusWidth-1 downto 0);
			CLK : in STD_LOGIC_VECTOR(0 downto 0);
			RESET : in STD_LOGIC_VECTOR(0 downto 0)
		);
	END COMPONENT;

	signal U8_OUT : STD_LOGIC_VECTOR(15 DOWNTO 0);

	COMPONENT subtractor
		GENERIC( 
			N_BITS : INTEGER := 16;
			SIGN : STRING := "SIGNED";
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

	signal U9_OUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal U10_OUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal U11_OUT : STD_LOGIC_VECTOR(31 DOWNTO 0);

	COMPONENT U11_multdsp
		PORT( 
			A : in STD_LOGIC_VECTOR(15 downto 0);
			B : in STD_LOGIC_VECTOR(15 downto 0);
			clk : in STD_LOGIC;
			SCLR : in STD_LOGIC;
			ce : in STD_LOGIC;
			P : out STD_LOGIC_VECTOR(31 downto 0)
		);
	END COMPONENT;

	signal U12_OUT : STD_LOGIC_VECTOR(31 DOWNTO 0);

	COMPONENT U12_accumulatordsp
		PORT( 
			B : in STD_LOGIC_VECTOR(15 downto 0);
			clk : in STD_LOGIC;
			SCLR : in STD_LOGIC;
			ce : in STD_LOGIC;
			Q : out STD_LOGIC_VECTOR(31 downto 0)
		);
	END COMPONENT;

	signal U13_OUT : STD_LOGIC_VECTOR(31 DOWNTO 0);

	COMPONENT adder
		GENERIC( 
			N_BITS : INTEGER := 32;
			SIGN : STRING := "SIGNED";
			N_BITS_OUT : INTEGER := 32;
			LATCH_OUTPUT : BOOLEAN := true;
			SATURATE : BOOLEAN := true
		);
		PORT( 
			a_in : in STD_LOGIC_VECTOR(N_BITS-1 downto 0);
			b_in : in STD_LOGIC_VECTOR(N_BITS-1 downto 0);
			clk : in STD_LOGIC;
			reset : in STD_LOGIC;
			sum_out : out STD_LOGIC_VECTOR(N_BITS_OUT-1 downto 0)
		);
	END COMPONENT;

	signal U14_OUT : STD_LOGIC_VECTOR(63 DOWNTO 0);

	COMPONENT U14_accumulatordsp
		PORT( 
			B : in STD_LOGIC_VECTOR(31 downto 0);
			clk : in STD_LOGIC;
			SCLR : in STD_LOGIC;
			ce : in STD_LOGIC;
			Q : out STD_LOGIC_VECTOR(63 downto 0)
		);
	END COMPONENT;


	
begin


	
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

	
 
  sim_reset : process(GlobalClock(0))
  variable sim_reset_counter : integer range 0 to 63 := 0;	
  begin
    if rising_edge(GlobalClock(0)) then
	
	  if sim_reset_counter < 4 then
         GlobalReset(0) <= '0';
      elsif sim_reset_counter < 10 then
         GlobalReset(0) <= '1';
      else
         GlobalReset(0) <= '0';
      end if;
		
      if sim_reset_counter < 50 then
        sim_reset_counter := sim_reset_counter + 1;
      end if;
    end if;
  end process;

	
	U0_A0 <= A0;
U1_CONST <= conv_std_logic_vector(120,16);
Probe0 <= U8_OUT;
Probe1 <= U10_OUT;
Probe2 <= U12_OUT;
Probe3 <= U13_OUT;
Probe4 <= U14_OUT;

	U7 : SYNC_FIX_DELAYp
	Generic map(
		DelayValue => 	100,
		busWidth => 	16
	)
	PORT MAP(
		PORT_IN => U0_A0,
		PORT_OUT => U7_OUT,
		CLK => CLK_ACQ,
		RESET => GlobalReset
	);


	U8 : subtractor
	Generic map(
		N_BITS => 	16,
		SIGN => 	"SIGNED",
		N_BITS_OUT => 	16,
		LATCH_OUTPUT => 	true,
		SATURATE => 	true
	)
	PORT MAP(
		a_in => U0_A0,
		b_in => U7_OUT,
		clk => GlobalClock(0),
		reset => GlobalReset(0),
		diff_out => U8_OUT
	);


	U9 : SYNC_FIX_DELAYp
	Generic map(
		DelayValue => 	120,
		busWidth => 	16
	)
	PORT MAP(
		PORT_IN => U8_OUT,
		PORT_OUT => U9_OUT,
		CLK => CLK_ACQ,
		RESET => GlobalReset
	);


	U10 : subtractor
	Generic map(
		N_BITS => 	16,
		SIGN => 	"SIGNED",
		N_BITS_OUT => 	16,
		LATCH_OUTPUT => 	true,
		SATURATE => 	true
	)
	PORT MAP(
		a_in => U8_OUT,
		b_in => U9_OUT,
		clk => GlobalClock(0),
		reset => GlobalReset(0),
		diff_out => U10_OUT
	);


	U11 : U11_multdsp
	PORT MAP(
		A => U10_OUT,
		B => U1_CONST,
		clk => GlobalClock(0),
		SCLR => GlobalReset(0),
		ce => '1',
		P => U11_OUT
	);


	U12 : U12_accumulatordsp
	PORT MAP(
		B => U10_OUT,
		clk => GlobalClock(0),
		SCLR => GlobalReset(0),
		ce => '1',
		Q => U12_OUT
	);


	U13 : adder
	Generic map(
		N_BITS => 	32,
		SIGN => 	"SIGNED",
		N_BITS_OUT => 	32,
		LATCH_OUTPUT => 	true,
		SATURATE => 	true
	)
	PORT MAP(
		a_in => U11_OUT,
		b_in => U12_OUT,
		clk => GlobalClock(0),
		reset => GlobalReset(0),
		sum_out => U13_OUT
	);


	U14 : U14_accumulatordsp
	PORT MAP(
		B => U13_OUT,
		clk => GlobalClock(0),
		SCLR => GlobalReset(0),
		ce => '1',
		Q => U14_OUT
	);

CLK_ACQ(0) <= CLK_ACQ_s;
async_clk(0) <= async_clk_s;
GlobalClock(0) <= GlobalClock_s;
FAST_CLK_100(0) <= FAST_CLK_100_s;
CLK_125(0) <= CLK_125_s;

		 
end Behavioral;

 