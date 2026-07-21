----------------------------------------------------------------------------------
-- Company:     Nuclear Instruments
-- Engineer:    Andrea Abba
--
-- Create Date: 28.01.2019 09:17:08
-- Design Name: SciCompiler
-- Module Name: PulseGenerator
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description: Generate periodic pulse
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PULSE_GENERATOR is
	Port (
		RESET : IN STD_LOGIC_VECTOR (0 downto 0);
		CE : IN STD_LOGIC_VECTOR (0 downto 0);
		CLK : IN STD_LOGIC_VECTOR (0 downto 0);
		PULSE_WIDTH : IN STD_LOGIC_VECTOR (31 downto 0);
		PULSE_PERIOD : IN STD_LOGIC_VECTOR (31 downto 0);
		PULSE_OUT : OUT STD_LOGIC_VECTOR (0 downto 0)
	);
end PULSE_GENERATOR;

architecture Behavioral of PULSE_GENERATOR is
	signal TimeCounter : unsigned(31 downto 0) := (others => '0');
	signal TimeCounter_next : unsigned(31 downto 0):= (others => '0');

begin

	TimeCounter_next <=
		(others => '0') when TimeCounter >= unsigned(PULSE_PERIOD) - 1 else
		TimeCounter + 1;


	TCP : process (CLK, RESET)
	begin
		if RESET(0) = '1' then
			TimeCounter <= (others => '0');
		elsif rising_edge(CLK(0)) and CE(0) = '1' then
			TimeCounter <= TimeCounter_next;
		end if;
	end process;

	PULSE_OUT(0) <=
		'0' when TimeCounter > unsigned(PULSE_WIDTH) - 1 else
		'1';

end Behavioral;
