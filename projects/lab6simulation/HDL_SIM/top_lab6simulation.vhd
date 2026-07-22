----------------------------------------------------------------------------------
-- Company: 	Nuclear Instruments SRL
-- Engineer: 	Andrea Abba
-- 
-- Create Date: 07.06.2020 10:24:18
-- Design Name: SciDK Scicompiler Development Kit
-- Module Name: TOP_lab6simulation
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
    
entity TOP_lab6simulation is
    Port (  
		    
        

            COMP1 : out STD_LOGIC_VECTOR(0 downto 0);
COMP2 : out STD_LOGIC_VECTOR(0 downto 0);
COUNT1 : out STD_LOGIC_VECTOR(31 downto 0);
COUNT2 : out STD_LOGIC_VECTOR(31 downto 0);
A0 : in STD_LOGIC_VECTOR(15 downto 0);
CLK_ACQ_s : in std_logic;
async_clk_s : in std_logic;
GlobalClock_s : in std_logic;
FAST_CLK_100_s : in std_logic;
CLK_125_s : in std_logic;


			lemo_a : inout STD_LOGIC;
			lemo_b : inout STD_LOGIC
                              
                              
			  ); 
end TOP_lab6simulation;

architecture Behavioral of TOP_lab6simulation is
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
	signal U1_OUT : STD_LOGIC_VECTOR(0 DOWNTO 0);

	COMPONENT comparator
		GENERIC( 
			IN_SIZE : INTEGER := 16;
			IN_SIGN : STRING := "unsigned";
			REGISTER_OUT : STRING := "true";
			OPERATION : STRING := "greater"
		);
		PORT( 
			in1 : in STD_LOGIC_VECTOR(IN_SIZE-1 downto 0);
			in2 : in STD_LOGIC_VECTOR(IN_SIZE-1 downto 0);
			clk : in STD_LOGIC;
			comp_out : out STD_LOGIC_VECTOR(0 downto 0)
		);
	END COMPONENT;

	signal U2_OUT : STD_LOGIC_VECTOR(0 DOWNTO 0);
	signal U3_COUNTS : STD_LOGIC_VECTOR(31 DOWNTO 0);

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

	signal U4_COUNTS : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal U9_CONST : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal U10_CONST : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

	
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

	U1 : comparator
	Generic map(
		IN_SIZE => 	16,
		IN_SIGN => 	"unsigned",
		REGISTER_OUT => 	"true",
		OPERATION => 	"greater"
	)
	PORT MAP(
		in1 => U0_A0,
		in2 => U10_CONST,
		clk => GlobalClock(0),
		comp_out => U1_OUT
	);


	U2 : comparator
	Generic map(
		IN_SIZE => 	16,
		IN_SIGN => 	"unsigned",
		REGISTER_OUT => 	"true",
		OPERATION => 	"greater"
	)
	PORT MAP(
		in1 => U0_A0,
		in2 => U9_CONST,
		clk => GlobalClock(0),
		comp_out => U2_OUT
	);


	U3 : COUNTER_RISINGp
	Generic map(
		bitSize => 	32
	)
	PORT MAP(
		COUNTER => U3_COUNTS,
		OVERFLOW => open,
		SIGIN => U1_OUT,
		ENABLE => "1",
		CE => "1",
		CLK => GlobalClock,
		RESET => GlobalReset
	);


	U4 : COUNTER_RISINGp
	Generic map(
		bitSize => 	32
	)
	PORT MAP(
		COUNTER => U4_COUNTS,
		OVERFLOW => open,
		SIGIN => U2_OUT,
		ENABLE => "1",
		CE => "1",
		CLK => GlobalClock,
		RESET => GlobalReset
	);

COMP1 <= U1_OUT;
COMP2 <= U2_OUT;
COUNT1 <= U3_COUNTS;
COUNT2 <= U4_COUNTS;
U9_CONST <= conv_std_logic_vector(1900,16);
U10_CONST <= conv_std_logic_vector(1200,16);
CLK_ACQ(0) <= CLK_ACQ_s;
async_clk(0) <= async_clk_s;
GlobalClock(0) <= GlobalClock_s;
FAST_CLK_100(0) <= FAST_CLK_100_s;
CLK_125(0) <= CLK_125_s;

		 
end Behavioral;

 