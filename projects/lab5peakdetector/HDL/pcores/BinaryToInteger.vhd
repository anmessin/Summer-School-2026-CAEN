------------------------------------------------------------------
--                      Nuclear Instruments                     --
--                                                              --
--                          SciCompiler                         --
--                                                              --
--  Module:             BINARY TO INTEGER                       --
--  Version:            1.1                                     --
--  Creation Date:      11-1-2025                               --
--                                                              --
------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--------------------------------------------------------------------------------
-- Entity: BinarytoInteger
-- Description:
--   This component converts a std_logic_vector into an integer, 
--   depending on the sign specified by the generic SIGN ("UNSIGNED" or "SIGNED").
--------------------------------------------------------------------------------
entity BinarytoInteger is
  generic (
    N_BITS : integer := 8;      -- Width of the std_logic_vector
    SIGN   : string  := "UNSIGNED"   -- "UNSIGNED" or "SIGNED"
  );
  port (
    slv_in  : in  std_logic_vector(N_BITS-1 downto 0);
    int_out : out integer
  );
end entity BinarytoInteger;

architecture behave of BinarytoInteger is
begin

  ------------------------------------------------------------------------------
  -- Combinational process that interprets slv_in as either SIGNED or UNSIGNED 
  -- and converts it to an integer.
  ------------------------------------------------------------------------------
  process(slv_in) is
  begin
    if SIGN = "SIGNED" then
      int_out <= to_integer(signed(slv_in));
    else
      int_out <= to_integer(unsigned(slv_in));
    end if;
  end process;

end architecture behave;