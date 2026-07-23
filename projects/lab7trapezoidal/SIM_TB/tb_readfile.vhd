--a compoent that read a file of integer and
--return each integer on the signal interface one at a time
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;

entity tb_readfile_std_logic_vector is
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
end tb_readfile_std_logic_vector;

architecture tb_read_file of tb_readfile_std_logic_vector is
  
begin
    RDF : process 
    file text_file : text open read_mode is file_name;
    variable text_line : line;
    variable ok : boolean;
    variable number : integer;
    begin
        while not endfile(text_file) loop
    
            readline(text_file, text_line);
        
            read(text_line, number, ok);
            if ok then
                word_output <= std_logic_vector(to_unsigned(number, word_output_size));
                wait until falling_edge(clk);
            end if;
        end loop;
        done <= '1';

        wait;
    end process RDF;
end tb_read_file;
