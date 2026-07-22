------------------------------------------------------------------
--                        Nuclear Instruments                     --
--                                                                --
--                            SciCompiler                          --
--                                                                --
--  Module:              BASELINE RESTORER                         --
--  Version:             1.2                                      --
--  Creation Date:       08-11-2024                               --
--                                                                --
------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_MISC.ALL;
use ieee.math_real.all;

library UNISIM;
use UNISIM.vcomponents.all;
Library xpm;
use xpm.vcomponents.all;

entity BASELINE_RESTORERp is
  Generic (
    wordWidth : integer := 16;
    maxLength : integer := 1024
  );
  port (
    RESET: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    CLK : IN STD_LOGIC_VECTOR (0 DOWNTO 0);
    CE : IN STD_LOGIC_VECTOR (0 DOWNTO 0);
    
    TRIGGER: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    DATA_IN: IN STD_LOGIC_VECTOR(wordWidth-1 DOWNTO 0);
    
    M_LENGTH: IN INTEGER;
    BL_HOLD: IN INTEGER;
    FLUSH: IN STD_LOGIC_VECTOR(0 DOWNTO 0);

    BASELINE: OUT STD_LOGIC_VECTOR(wordWidth-1 DOWNTO 0);
    BASELINE_VALID: OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    HOLD_TIME: OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
    RUNNING_NOT_HOLD: OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
  );
end;

architecture Behavioral of BASELINE_RESTORERp is
  
    constant memDepthBits : integer := integer(ceil(log2(real(maxLength))));
    
    signal WP : std_logic_vector(memDepthBits-1 downto 0) := (others => '0');
    signal RP : std_logic_vector(memDepthBits-1 downto 0) := (others => '0');
    signal memOut : std_logic_vector(wordWidth-1 downto 0);
    signal memIn : std_logic_vector(wordWidth-1 downto 0);
    signal accumulator : std_logic_vector(wordWidth + memDepthBits - 1 downto 0) := (others => '0');
    signal sampleCount : integer := 0;

   

    signal hold : std_logic := '0';
    signal enable_memory : std_logic := '0';
    signal sm_plr : std_logic_vector(3 downto 0) := x"F";
    signal int_HOLD_TIME : std_logic_vector(47 downto 0) := (others => '0');
    signal M_LENGTH_NUMBER: integer := 0;
    signal DELAY_COUNTER: integer := 0;

    signal oldM_LENGTH : integer := 0;
    function pow2(n : integer) return integer is
    begin
        return 2**n;
    end function;

begin
    
    
    xpm_memory_sdpram_inst : xpm_memory_sdpram
		generic map (
			-- Common module generics
			MEMORY_SIZE => maxLength * wordWidth, --positive integer
			MEMORY_PRIMITIVE => "block", --string; "auto", "distributed", "block" or "ultra" ;
			CLOCKING_MODE => "common_clock",--string; "common_clock", "independent_clock"
			MEMORY_INIT_FILE => "none", --string; "none" or "<filename>.mem"
			MEMORY_INIT_PARAM => "", --string;
			USE_MEM_INIT => 1, --integer; 0,1
			WAKEUP_TIME => "disable_sleep",--string; "disable_sleep" or "use_sleep_pin"
			MESSAGE_CONTROL => 0, --integer; 0,1
			-- Port A module generics
			WRITE_DATA_WIDTH_A => wordWidth, --positive integer
			BYTE_WRITE_WIDTH_A => wordWidth, --integer; 8, 9, or WRITE_DATA_WIDTH_A value
			ADDR_WIDTH_A => memDepthBits, --positive integer
			-- Port B module generics
			READ_DATA_WIDTH_B => wordWidth, --positive integer
			ADDR_WIDTH_B => memDepthBits, --positive integer
			READ_RESET_VALUE_B => "0", --string
			READ_LATENCY_B => 1, --non-negative integer
			WRITE_MODE_B => "no_change" --string; "write_first", "read_first", "no_change"
			)
			port map (
			-- Common module ports
			sleep => '0',
			-- Port A module ports
			clka => CLK(0),
			ena => enable_memory,
			wea => "1",
			addra => WP,
			dina => memIn,
			injectsbiterra => '0', --do not change
			injectdbiterra => '0', --do not change
			-- Port B module ports
			clkb => CLK(0),
			rstb => RESET(0),
			enb => enable_memory,
			regceb => enable_memory,
			addrb => RP,
			doutb => memOut,
			sbiterrb => open, --do not change
			dbiterrb => open --do not change
			);

    HOLD_TIME <= int_HOLD_TIME;
    RUNNING_NOT_HOLD(0) <= hold;
    enable_memory <= not hold;
    -- Moving Average Accumulator
    process (CLK)
    begin
        if RESET = "1" or FLUSH = "1" then
            accumulator <= (others => '0');
            sampleCount <= 0;
            BASELINE_VALID <= "0";
        elsif rising_edge(CLK(0)) and CE = "1" then
            if hold = '0' then
                if sampleCount = maxLength +10 then
                    accumulator <= accumulator - memOut + DATA_IN;
                    RP <= WP - M_LENGTH_NUMBER+3;
                    memIn <= DATA_IN;
                    BASELINE_VALID <= "1";
                else
                    accumulator <= (others => '0'); 
                    memIn <=(others => '0');
                    sampleCount <= sampleCount + 1;
                    BASELINE_VALID <= "0";
                end if;
                
                WP <= WP + 1;
            end if;

            if oldM_LENGTH /= M_LENGTH then
                sampleCount <= 0;
                BASELINE_VALID <= "0";
            end if;

            oldM_LENGTH <= M_LENGTH;
        end if;
    end process;

    -- Calculate average and output baseline
    process (accumulator, M_LENGTH)
    begin
        if M_LENGTH > 2 and M_LENGTH < 16 then
         M_LENGTH_NUMBER <= pow2(M_LENGTH);
         BASELINE <= std_logic_vector(accumulator(wordWidth + M_LENGTH - 1 downto M_LENGTH));
        else 
         BASELINE <= (others => '0');
         M_LENGTH_NUMBER <= 0;
        end if;
    end process;

    -- Controller Logic
    bl_controller_process: process(CLK)
    begin
        if RESET = "1" or FLUSH = "1" then
            int_HOLD_TIME <= (others => '0');
            sm_plr <= x"F";
        elsif rising_edge(CLK(0)) and CE = "1" then
            hold <= '0';
            case sm_plr is    
                when x"F" =>
                    DELAY_COUNTER <= M_LENGTH_NUMBER + 10;
                    sm_plr <= x"E";
                when x"E" =>
                    if DELAY_COUNTER = 0 then
                        sm_plr <= x"0";
                    else
                        DELAY_COUNTER <= DELAY_COUNTER - 1;
                    end if;
                    if TRIGGER = "1" then
                        DELAY_COUNTER <= M_LENGTH_NUMBER;
                    end if;
                when x"0" =>
                    int_HOLD_TIME <= (others => '0');
                    if TRIGGER = "1" then
                        DELAY_COUNTER <= BL_HOLD;
                        hold <= '1';
                        sm_plr <= x"1";
                    end if;
                when x"1" =>
                    hold <= '1';
                    int_HOLD_TIME <= int_HOLD_TIME + 1;
                    if TRIGGER = "1" then
                        DELAY_COUNTER <= BL_HOLD;
                    elsif DELAY_COUNTER = 0 then
                        sm_plr <= x"0";
                    else
                        DELAY_COUNTER <= DELAY_COUNTER - 1;
                    end if;
                when others =>
                    sm_plr <= x"0";
            end case;
        end if;
    end process;
end Behavioral;
