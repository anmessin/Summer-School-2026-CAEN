library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use ieee.std_logic_misc.all; 
use IEEE.std_logic_signed.all;

entity trigger_le_delta is
	Generic (
		ADC_nbits : integer := 16
	);
	Port (
		CLK : in STD_LOGIC_VECTOR(0 downto 0);
		RESET : in STD_LOGIC_VECTOR(0 downto 0);	-- active low RESET(0)
		DATA_IN : in STD_LOGIC_VECTOR(ADC_nbits-1 downto 0);
		POLARITY : in STD_LOGIC_VECTOR(0 downto 0);	-- "1" = positive, "0" = negative
		--
		THRESHOLD : in STD_LOGIC_VECTOR(ADC_nbits-1 downto 0) := (others=>'0');
		DELTA     : in STD_LOGIC_VECTOR(ADC_nbits-1 downto 0) := (others=>'0');
		INIBIT    : in STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
		--
		DATA_OUT : out STD_LOGIC_VECTOR (ADC_nbits-1 downto 0);
		TRIGGER_OUT : out STD_LOGIC_VECTOR(0 downto 0);
		TOT_OUT : out STD_LOGIC_VECTOR(0 downto 0)
	);
end trigger_le_delta;

architecture Behavioral of trigger_le_delta is
	
begin
               
    double_th_inibit: process (RESET, CLK)
    
    variable is_tot: STD_LOGIC:='0';
    variable is_passed: STD_LOGIC:='0';
    variable is_inibit: STD_LOGIC:='0';
    variable trigger_enable: std_logic:='1';
    variable tdata : UNSIGNED(ADC_nbits-1 downto 0);
    variable inibit_counter : integer range 0 to 65535 := 0;
    
    begin
        if RESET = "0" then
            is_passed       := '0';
            is_tot          := '0';
            inibit_counter  :=  0;
            is_inibit       := '0';
            
            DATA_OUT        <= (others => '0');
            TOT_OUT(0)      <= '0';
            TRIGGER_OUT(0)  <= '0';
            
            
        elsif rising_edge(CLK(0)) then

            tdata           := UNSIGNED(DATA_IN);
            trigger_enable  := not is_passed and not is_inibit;
            TRIGGER_OUT(0)  <= '0';
    
            if POLARITY = "1" then
               
                if tdata > UNSIGNED(THRESHOLD) and trigger_enable = '1'then 
                    is_passed := '1';
                    is_inibit :='1';
                    is_tot := '1';  
                    TRIGGER_OUT(0)  <= '1';                  
                    end if;
                
                if tdata < UNSIGNED(THRESHOLD - DELTA) and is_passed = '1' and is_tot = '0' then 
                    is_passed := '0';
                end if;
                
                if tdata < UNSIGNED(THRESHOLD - DELTA)  and is_passed = '1' then 
                    is_tot :='0';
                end if;
 
            else            
               
                if tdata < UNSIGNED(THRESHOLD) and trigger_enable = '1'then 
                    is_passed := '1';
                    is_inibit :='1';
                    is_tot := '1';
                    TRIGGER_OUT(0)  <= '1';
                end if;
                
                if tdata > UNSIGNED(THRESHOLD + DELTA) and is_passed = '1' and is_tot = '0' then 
                    is_passed := '0';
                end if;
                
                if tdata > UNSIGNED(THRESHOLD + DELTA)  and is_passed = '1' then 
                    is_tot :='0';
                end if;

            end if;
           
            if is_inibit = '1' then
                inibit_counter := inibit_counter + 1;                    
                if inibit_counter = INIBIT + 1 then
                    is_inibit := '0';
                    inibit_counter := 0;
                end if;
            end if;
           
            DATA_OUT    <= std_logic_vector(tdata);
            TOT_OUT(0)  <= is_tot; 
                                
        end if;        
    end process;

end Behavioral;
