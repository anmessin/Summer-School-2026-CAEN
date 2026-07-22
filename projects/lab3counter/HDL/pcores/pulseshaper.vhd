------------------------------------------------------------------
--						Nuclear Instruments						--
--																--
--							SciCompiler							--
--																--
--	Module:				MONOSTABLE       		        		--
--	Version:			1.1										--
--	Creation Data:		06-11-2024								--
--																--
--																--
------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pulseshaper is
   Generic (
		NO_DELAY : STRING := "false";
        EDGE : STRING := "rising"
        );
    Port ( a : in STD_LOGIC_VECTOR (0 downto 0);
           b : out STD_LOGIC_VECTOR (0 downto 0);
           ce : in STD_LOGIC;
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           width : in integer;
		   delay : in integer
		   );
end pulseshaper;

architecture Behavioral of pulseshaper is

	signal SM : std_logic_vector (3 downto 0) := x"0";
	signal iwidth : integer := 0;
	signal idelay : integer := 0;
	signal oa : std_logic;
	signal ib : std_logic;
	signal ia : std_logic;
	signal ia_i : std_logic;
	signal iib : std_logic;
begin

b(0) <= a(0) when width = 0 else iib;
IF_NO_DELAY_FALSE:
   if NO_DELAY = "false" generate
      begin
		iib <= ib;
   end generate;

IF_NO_DELAY_TRUE:
   if NO_DELAY = "true" generate
      begin
		iib <= a(0) or ib;
   end generate;


IF_rising:
   if EDGE = "rising" generate
      begin
		ia_i <= a(0);
   end generate;


IF_falling:
   if EDGE = "falling" generate
      begin
		ia_i <= not a(0);
end generate;

        latch : process(clk)
        begin
            if reset ='1' then
                ib <= '0';
				SM <= x"0";
            elsif rising_edge(clk) and ce='1' then
				ia <= ia_i;
				oa <= ia;
				case SM is 
					when x"0" =>
						if oa = '0' and ia='1' then
							idelay <= delay-1;
							iwidth <= width-1;
							if width > 0 then
								if delay = 0 then
									ib<='1';
									SM <= x"2";
								else
									SM <= x"1";
								end if;
							end if;
						end if;

					when x"1" =>
						if idelay = 0 then
							ib<='1';
							SM <= x"2";
						else	
							idelay <= idelay -1;
						end if;
					
					when x"2" =>
						if iwidth = 0 then
							ib<='0';
							SM <= x"0";
						else
							iwidth <= iwidth -1;
						end if;
					when others =>
						SM <= x"0";
				end case;

            end if;
        end process;



        
end Behavioral;
