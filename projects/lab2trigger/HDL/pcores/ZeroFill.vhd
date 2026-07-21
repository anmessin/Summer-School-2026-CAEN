------------------------------------------------------------------
--                      Nuclear Instruments                     --
--                                                              --
--                          SciCompiler                         --
--                                                              --
--  Module:             ZERO FILL                               --
--  Version:            1.2                                     --
--  Creation Date:      12-10-2024                              --
--                                                              --
------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ZeroFill is
  generic (
    INPUT_WIDTH  : integer := 8;  -- Width of the input vector
    OUTPUT_WIDTH : integer := 16; -- Width of the output vector (must be >= INPUT_WIDTH)
    ALIGN        : string  := "LEFT" -- Alignment of the input vector: "LEFT" or "RIGHT"
  );
  port (
    din   : in  std_logic_vector(INPUT_WIDTH-1 downto 0);  -- Input vector
    dout  : out std_logic_vector(OUTPUT_WIDTH-1 downto 0) -- Output vector
  );
end ZeroFill;

architecture Behavioral of ZeroFill is
begin
  -- Assert to check if OUTPUT_WIDTH is valid
  assert (OUTPUT_WIDTH >= INPUT_WIDTH)
    report "Error: OUTPUT_WIDTH must be greater than or equal to INPUT_WIDTH."
    severity failure;
  assert (ALIGN = "LEFT" or ALIGN = "RIGHT")
    report "Error: ALIGN must be either 'LEFT' or 'RIGHT'."
    severity failure;

  process(din)
    variable zero_padding : std_logic_vector(OUTPUT_WIDTH-INPUT_WIDTH-1 downto 0);
  begin
    zero_padding := (others => '0'); -- Create the zero-padding vector

    if ALIGN = "LEFT" then
      -- Left alignment: append zeros to the right
      dout <= din & zero_padding;
    elsif ALIGN = "RIGHT" then
      -- Right alignment: prepend zeros to the left
      dout <= zero_padding & din;
    else
      -- Default fallback (not expected to occur due to assertion)
      dout <= (others => '0');
    end if;
  end process;
end Behavioral;
