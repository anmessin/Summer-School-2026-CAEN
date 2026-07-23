--a testbench file 

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
entity testbench is

end testbench;

architecture arc_testbench of testbench is
    component TOP_lab7trapezoidal is
        Port (  
                A0 : in STD_LOGIC_VECTOR(15 downto 0);
CLK_ACQ_s : in std_logic;
async_clk_s : in std_logic;
GlobalClock_s : in std_logic;
FAST_CLK_100_s : in std_logic;
CLK_125_s : in std_logic;
Probe0 : out STD_LOGIC_VECTOR(15 downto 0);
Probe1 : out STD_LOGIC_VECTOR(15 downto 0);
Probe2 : out STD_LOGIC_VECTOR(31 downto 0);
Probe3 : out STD_LOGIC_VECTOR(31 downto 0);
Probe4 : out STD_LOGIC_VECTOR(63 downto 0);

                lemo_a : inout STD_LOGIC;
                lemo_b : inout STD_LOGIC
                                  
                                  
              ); 
    end component TOP_lab7trapezoidal;
    signal A0 :  STD_LOGIC_VECTOR(15 downto 0);
component tb_readfile_std_logic_vector is
generic (
	word_output_size : integer := 16;
	repeat_count : integer := 10;
	repeat_forever : boolean := false;
	file_name : string := "test.txt"
);
port (
	clk : in std_logic;
	word_output : out std_logic_vector(word_output_size-1 downto 0);
	done : out std_logic
);
end component tb_readfile_std_logic_vector;

component tb_readfile_std_logic_vector_tm is
generic (
	word_output_size : integer := 16;
	tm_factor : integer := 4;
	repeat_count : integer := 10;
	repeat_forever : boolean := false;
	file_name : string := "test.txt"
);
port (
	clk : in std_logic;
	word_output : out std_logic_vector(tm_factor*word_output_size-1 downto 0);
	done : out std_logic
);
end component tb_readfile_std_logic_vector_tm;

component tb_clockgen is
	Generic (
		clk_ts : real;
		initial_delay : real
	);
	Port ( clk : out STD_LOGIC
	);
end component tb_clockgen;
signal CLK_ACQ : std_logic;
signal async_clk : std_logic;
signal GlobalClock : std_logic;
signal FAST_CLK_100 : std_logic;
signal CLK_125 : std_logic;
signal Probe0 : STD_LOGIC_VECTOR(15 downto 0);
signal Probe1 : STD_LOGIC_VECTOR(15 downto 0);
signal Probe2 : STD_LOGIC_VECTOR(31 downto 0);
signal Probe3 : STD_LOGIC_VECTOR(31 downto 0);
signal Probe4 : STD_LOGIC_VECTOR(63 downto 0);

    signal lemo_a : STD_LOGIC;
    signal lemo_b : STD_LOGIC;

begin

    UUT : TOP_lab7trapezoidal 
    Port Map ( 
        A0=>A0,
CLK_ACQ_s => CLK_ACQ,
async_clk_s => async_clk,
GlobalClock_s => GlobalClock,
FAST_CLK_100_s => FAST_CLK_100,
CLK_125_s => CLK_125,
Probe0 => Probe0,Probe1 => Probe1,Probe2 => Probe2,Probe3 => Probe3,Probe4 => Probe4,

        lemo_a => lemo_a,
        lemo_b => lemo_b
        
    );

    
file_read_A0 : tb_readfile_std_logic_vector 
    generic map (
        word_output_size => 16,
        repeat_count => 0,
        repeat_forever => False,
        file_name => "A0.txt"
    )
    port map (
        clk => GlobalClock,
        word_output => A0,
        done => open
    );



  CLK_ACQ_gen : tb_clockgen 
        Generic Map(
            clk_ts => real(15.3846153846154),
            initial_delay => real(0)
        )
        Port Map( clk => CLK_ACQ
        );




  async_clk_gen : tb_clockgen 
        Generic Map(
            clk_ts => real(15.3846153846154),
            initial_delay => real(0)
        )
        Port Map( clk => async_clk
        );




  GlobalClock_gen : tb_clockgen 
        Generic Map(
            clk_ts => real(15.3846153846154),
            initial_delay => real(0)
        )
        Port Map( clk => GlobalClock
        );




  FAST_CLK_100_gen : tb_clockgen 
        Generic Map(
            clk_ts => real(10),
            initial_delay => real(0)
        )
        Port Map( clk => FAST_CLK_100
        );




  CLK_125_gen : tb_clockgen 
        Generic Map(
            clk_ts => real(8),
            initial_delay => real(0)
        )
        Port Map( clk => CLK_125
        );





reg_stim : process
begin

wait;
end process;


end arc_testbench;