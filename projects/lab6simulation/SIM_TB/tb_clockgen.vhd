--module to generate a clock signal with a given frequency. 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use ieee.math_real.all;  
entity tb_clockgen is
    Generic (
        clk_ts : real;
        initial_delay : real
    );
    Port ( clk : out STD_LOGIC
    );
end tb_clockgen;

architecture Behavioral of tb_clockgen is
   
begin

    clk_gen_proc : process
    variable clk_count : integer := 0;
    variable clk_state : STD_LOGIC := '0';
    begin
        wait for initial_delay * 1 ns;
        while true loop
            clk <= '0';
            wait for (clk_ts/2.0) * 1 ns;
            clk <= '1';
            wait for (clk_ts/2.0) * 1 ns;
        end loop;
    end process clk_gen_proc;

end Behavioral;