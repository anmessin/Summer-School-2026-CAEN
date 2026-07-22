------------------------------------------------------------------
--						Nuclear Instruments						--
--																--
--							SciCompiler							--
--																--
--	Module:				PEAK STRETCHER							--
--	Version:			1.1										--
--	Creation Data:		08-11-2024								--
--																--
--																--
------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_MISC.ALL;
--Library UNISIM;
--use UNISIM.vcomponents.all;


entity PK_STRETCHERp is
Generic (	
			wordWidth : integer := 16);
  port (
	RESET : IN STD_LOGIC_VECTOR (0 DOWNTO 0);
	CLK : IN STD_LOGIC_VECTOR (0 DOWNTO 0);
	CE : IN STD_LOGIC_VECTOR (0 DOWNTO 0);
    DATA_IN : IN STD_LOGIC_VECTOR (wordWidth-1 DOWNTO 0);
	DATA_OUT : OUT STD_LOGIC_VECTOR (wordWidth-1 DOWNTO 0);
	TRACKHOLD : OUT STD_LOGIC_VECTOR (0 DOWNTO 0)
	);
end;


architecture Behavioral of PK_STRETCHERp is
	signal PEAK : STD_LOGIC_VECTOR (wordWidth-1 DOWNTO 0) := (others => '0');
	signal iDATA_OUT : STD_LOGIC_VECTOR (wordWidth-1 DOWNTO 0):= (others => '0');
	signal iTRACKHOLD : STD_LOGIC_VECTOR (0 DOWNTO 0) := "0";
begin
	
	DATA_OUT <= iDATA_OUT;
	TRACKHOLD <= iTRACKHOLD;
	timer_process: process(CLK,RESET)
	begin
		if rising_edge(CLK(0)) then
			if RESET = "1" then
				PEAK<=(others =>'0');
				iTRACKHOLD <= "0";
				iDATA_OUT <= (others =>'0');
			else	
				iDATA_OUT <= PEAK;
				if CE = "1" then
					if DATA_IN > PEAK then
						PEAK <= DATA_IN;
						iTRACKHOLD <= "0";
					else
						iTRACKHOLD <= "1";
					end if;
				end if;
			end if;
						
        end if;
    end process;
    

end Behavioral; 