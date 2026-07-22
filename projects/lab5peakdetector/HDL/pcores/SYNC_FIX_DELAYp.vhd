------------------------------------------------------------------
--						Nuclear Instruments						--
--																--
--							SciCompiler							--
--																--
--	Module:				DELAY (FIXED)							--
--	Version:			1.1										--
--	Creation Data:		5-11-2024								--
--																--
--																--
------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_MISC.ALL;
use ieee.math_real.all;


entity SYNC_FIX_DELAYp is
  Generic (	DelayValue : integer := 16;
			busWidth : integer := 16);
  port (
	RESET : IN STD_LOGIC_VECTOR (0 DOWNTO 0);
	CLK : IN STD_LOGIC_VECTOR (0 DOWNTO 0);
    PORT_IN : IN STD_LOGIC_VECTOR (busWidth-1 DOWNTO 0);
	PORT_OUT: OUT STD_LOGIC_VECTOR (busWidth-1 downto 0)
	);
end;


architecture Behavioral of SYNC_FIX_DELAYp is

	type tDELAY_V is array (0 to DelayValue-1) of std_logic_vector(busWidth-1 downto 0);
	signal DELAY_V : tDELAY_V := (others => (others => '0'));
	signal DELAY_S : std_logic_vector(busWidth-1 downto 0):= (others => '0');
begin



	PORT_OUT <= DELAY_V(0) when DelayValue > 1 else DELAY_S when DelayValue =1 else PORT_IN;

	delay_process: process(CLK,RESET)
	begin
		if rising_edge(CLK(0)) then
			if RESET(0) = '1' then
				DELAY_V <= (others => (others => '0'));
			else	
				DELAY_V(DelayValue-1) <= 	PORT_IN;		
				if DelayValue > 1 then
				   for I in 1 to DelayValue-1 loop
					  DELAY_V(I-1) <= DELAY_V(I);
				   end loop;
				else
					DELAY_S <= PORT_IN;
				end if;	
            end if;
        end if;
    end process;
    
	
	
			
end Behavioral; 