library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity subtractor is
  generic(
    N_BITS       : integer := 8;         -- Larghezza ingressi a_in, b_in
    N_BITS_OUT   : integer := 8;         -- Larghezza uscita diff_out
    SIGN         : string  := "UNSIGNED";-- "SIGNED" oppure "UNSIGNED"
    LATCH_OUTPUT : boolean := false;     -- true => uscita registrata, false => combinatoria
    SATURATE     : boolean := true       -- abilita saturazione quando N_BITS_OUT = N_BITS
  );
  port(
    clk      : in  std_logic;
    reset    : in  std_logic;
    a_in     : in  std_logic_vector(N_BITS-1 downto 0);
    b_in     : in  std_logic_vector(N_BITS-1 downto 0);
    diff_out : out std_logic_vector(N_BITS_OUT-1 downto 0)
  );
end entity subtractor;

architecture behave of subtractor is

  ----------------------------------------------------------------------------
  -- INTERNAL_BITS: un bit extra per gestire overflow/underflow
  ----------------------------------------------------------------------------
  constant INTERNAL_BITS : integer := N_BITS_OUT + 1;

  ----------------------------------------------------------------------------
  -- Risultato combinatorio finale (std_logic_vector)
  ----------------------------------------------------------------------------
  signal diff_comb : std_logic_vector(N_BITS_OUT-1 downto 0);

begin

  ----------------------------------------------------------------------------
  -- PROCESS COMBINATORIO: separazione SIGNED / UNSIGNED
  ----------------------------------------------------------------------------
  comb_process: process(a_in, b_in)
    ----------------------------------------------------------------------------
    -- Variabili per il ramo SIGNED
    ----------------------------------------------------------------------------
    variable a_s, b_s, tmp_diff_s : signed(INTERNAL_BITS-1 downto 0);
    variable max_s, min_s         : signed(INTERNAL_BITS-1 downto 0);

    ----------------------------------------------------------------------------
    -- Variabili per il ramo UNSIGNED
    ----------------------------------------------------------------------------
    variable a_u, b_u, tmp_diff_u : unsigned(INTERNAL_BITS-1 downto 0);
    variable max_u, min_u         : unsigned(INTERNAL_BITS-1 downto 0);
    variable temp : signed(N_BITS-1 downto 0);
    variable temp_u : unsigned(N_BITS downto 0);
  begin
    --------------------------------------------------------------------------
    -- Se SIGN = "SIGNED", usiamo i tipi signed
    --------------------------------------------------------------------------
    if SIGN = "SIGNED" then
      -----------------------
      -- 1) Estensione di segno
      -----------------------
      a_s := signed(resize(signed(a_in), INTERNAL_BITS));
      b_s := signed(resize(signed(b_in), INTERNAL_BITS));

      -----------------------
      -- 2) Sottrazione
      -----------------------
      tmp_diff_s := a_s - b_s;

      -----------------------
      -- 3) Saturazione (se serve)
      -----------------------
      if SATURATE and (N_BITS_OUT = N_BITS) then
        -- range SIGNED: -(2^(N_BITS-1)) .. +2^(N_BITS-1)-1
        temp := shift_left(to_signed(1, N_BITS), N_BITS-1);
        
        -- max_s =  2^(N_BITS-1) - 1
        max_s := resize(temp - to_signed(1, N_BITS), INTERNAL_BITS);
        
        -- min_s = -2^(N_BITS-1)
        min_s := resize(-temp, INTERNAL_BITS);

        if tmp_diff_s > max_s then
          tmp_diff_s := max_s;
        elsif tmp_diff_s < min_s then
          tmp_diff_s := min_s;
        end if;
      end if;

      -----------------------
      -- 4) Output combinatorio (slice)
      -----------------------
      diff_comb <= std_logic_vector(tmp_diff_s(N_BITS_OUT-1 downto 0));

    --------------------------------------------------------------------------
    -- Altrimenti, se SIGN = "UNSIGNED", usiamo i tipi unsigned
    --------------------------------------------------------------------------
    else
      -----------------------
      -- 1) Estensione zero
      -----------------------
      a_u := unsigned(resize(unsigned(a_in), INTERNAL_BITS));
      b_u := unsigned(resize(unsigned(b_in), INTERNAL_BITS));

      -----------------------
      -- 2) Sottrazione
      --    Potrebbe diventare negativa se a < b
      -----------------------
      tmp_diff_u := a_u - b_u;

      -----------------------
      -- 3) Saturazione (se serve)
      -----------------------
      if SATURATE and (N_BITS_OUT = N_BITS) then
        -- range UNSIGNED: 0 .. (2^N_BITS - 1)
        --max_u := resize(to_unsigned((2**N_BITS) - 1, N_BITS), INTERNAL_BITS);
        temp_u := shift_left(to_unsigned(1, N_BITS+1), N_BITS);
        
        -- max_u = 2^N_BITS - 1 (poi lo ridimensioniamo alla larghezza INTERNAL_BITS)
        max_u := resize(temp_u - 1, INTERNAL_BITS);

        min_u := (others => '0');  -- 0

        if tmp_diff_u > max_u then
          tmp_diff_u := max_u;
        elsif tmp_diff_u < min_u then
          tmp_diff_u := min_u;  -- se è negative => clamp a 0
        end if;
      end if;

      -----------------------
      -- 4) Output combinatorio (slice)
      -----------------------
      diff_comb <= std_logic_vector(tmp_diff_u(N_BITS_OUT-1 downto 0));

    end if;  -- SIGN = "SIGNED" / else

  end process;


  ----------------------------------------------------------------------------
  -- SE LATCH_OUTPUT = true => registriamo diff_comb su clk
  ----------------------------------------------------------------------------
  latch_gen: if LATCH_OUTPUT generate
    process(clk)
    begin
      if rising_edge(clk) then
        if reset = '1' then
          diff_out <= (others => '0');
        else
          diff_out <= diff_comb;
        end if;
      end if;
    end process;
  end generate;

  ----------------------------------------------------------------------------
  -- Altrimenti, uscita combinatoria
  ----------------------------------------------------------------------------
  direct_gen: if not LATCH_OUTPUT generate
    diff_out <= diff_comb;
  end generate;

end architecture behave;
