library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;

entity tb_readfile_std_logic_vector_tm is
    generic (
        word_output_size : integer := 16;
        tm_factor : integer := 4;
        repeat_count : integer := 10;
        repeat_forever : boolean := false;
        file_name : string := "test.txt"
    );
    port (
        clk : in std_logic;
        word_output : out std_logic_vector(word_output_size * tm_factor - 1 downto 0);
        done : out std_logic
    );
end tb_readfile_std_logic_vector_tm;

architecture tb_read_file of tb_readfile_std_logic_vector_tm is
    type integer_array is array (0 to tm_factor-1) of integer; -- Define a custom array type
begin
    RDF : process
        file text_file : text open read_mode is file_name;
        variable text_line : line;
        variable ok : boolean;
        variable numbers : integer_array; -- Use the custom array type
        variable number : integer;
        variable i : integer;
        variable large_word : unsigned(word_output_size * tm_factor - 1 downto 0);
    begin
        done <= '0';
        while not endfile(text_file) loop
            large_word := (others => '0');

            -- Read tm_factor numbers from the file
            for i in 0 to tm_factor-1 loop
                if not endfile(text_file) then
                    readline(text_file, text_line);
                    read(text_line, number, ok);
                    if ok then
                        numbers(i) := number;
                    else
                        numbers(i) := 0;
                    end if;
                else
                    numbers(i) := 0;
                end if;
            end loop;

            -- Concatenate numbers into a large word
            for i in 0 to tm_factor-1 loop
                large_word((i+1)*word_output_size-1 downto i*word_output_size) := to_unsigned(numbers(i), word_output_size);
            end loop;

            -- Output the large word
            word_output <= std_logic_vector(large_word);
            wait until falling_edge(clk);
        end loop;

        done <= '1';
        wait;
    end process RDF;
end tb_read_file;
