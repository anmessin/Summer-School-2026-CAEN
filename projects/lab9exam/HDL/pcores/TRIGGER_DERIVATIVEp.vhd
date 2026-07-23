------------------------------------------------------------------
--						Nuclear Instruments						--
--																--
--							SciCompiler							--
--																--
--	Module:				TRIGGER_DERIVATIVE						--
--	Version:			1.1										--
--	Creation Data:		08-11-2024								--
--																--
--																--
------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.STD_LOGIC_MISC.ALL;
--Library UNISIM;
--use UNISIM.vcomponents.all;


entity TRIGGER_DERIVATIVEp is
  Generic (	wordWidth : integer := 16;
			noise_filter : integer := 2;
			data_delay : integer := 3);
  port (
	RESET: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
	CLK : IN STD_LOGIC_VECTOR (0 DOWNTO 0);
	CE : IN STD_LOGIC_VECTOR (0 DOWNTO 0);
	POLARITY: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
	PORT_IN: IN STD_LOGIC_VECTOR(wordWidth-1 DOWNTO 0);
	THRESHOLD: IN STD_LOGIC_VECTOR(wordWidth-1 DOWNTO 0);
	TRIGGER_INIB: IN INTEGER;
	DELAYED_DATA: OUT STD_LOGIC_VECTOR(wordWidth-1 DOWNTO 0);
	DERIVATIVE_DATA: OUT STD_LOGIC_VECTOR(wordWidth-1 DOWNTO 0);
	TRIGGER_OUT: OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
	);
end;


architecture Behavioral of TRIGGER_DERIVATIVEp is
	
	signal iTOT : std_logic := '0';
	signal oTOT : std_logic := '0';
	
	type tMemData is array (0 to data_delay+1) of std_logic_vector(wordWidth-1 downto 0) ;
	type tMemData2 is array (0 to noise_filter+1) of std_logic_vector(wordWidth-1 downto 0);
	
	signal MemOutputDx : tMemData2 := (others => (others => '0'));
	signal MemOutput : tMemData  := (others => (others => '0'));
	
	signal DERIVATIVE : std_logic_vector(wordWidth-1 downto 0) := (others =>'0');

	signal PORT_IN_Dx : std_logic_vector(wordWidth-1 downto 0) := (others =>'0');
	signal iTRIGGER : std_logic_vector(noise_filter downto 0) := (others =>'0');
	signal trigger_kill_counter : integer := 0;
	signal trigger_kill : std_logic := '0';	

	signal iDELAYED_DATA: STD_LOGIC_VECTOR(wordWidth-1 DOWNTO 0) := (others =>'0');
	signal iTRIGGER_OUT: STD_LOGIC_VECTOR(0 DOWNTO 0) := "0";
begin

	DERIVATIVE_DATA <= DERIVATIVE;
	DELAYED_DATA <= iDELAYED_DATA;
	TRIGGER_OUT <= iTRIGGER_OUT;
	l_edge_process: process(CLK)
	begin
	if RESET = "1" then
		iTOT <= '0';
		iTRIGGER_OUT <= "0";
		iDELAYED_DATA <= (others =>'0');
		DERIVATIVE <= (others =>'0');
		trigger_kill_counter <= 0;
		trigger_kill <= '0';
	elsif rising_edge(CLK(0)) and CE = "1"  then
		iTRIGGER_OUT <= "0";
		MemOutputDx(noise_filter) <= PORT_IN;
		PORT_IN_Dx <= MemOutputDx(0);
		for I in 0 to noise_filter-1 loop
			MemOutputDx(I) <= MemOutputDx(I+1);
		end loop;
		
		if data_delay > 0 then
			for I in 0 to data_delay-1 loop
				MemOutput(I) <= MemOutput(I + 1);
			end loop;
			MemOutput(data_delay) <= PORT_IN;
			iDELAYED_DATA <= MemOutput(0);
		else
			MemOutput(0) <= PORT_IN;
			iDELAYED_DATA <= MemOutput(0);
		end if;
	
		DERIVATIVE <= PORT_IN - PORT_IN_Dx;
		if POLARITY= "1" then
			if DERIVATIVE >= THRESHOLD then
				iTOT <= '1';
			else
				iTOT <= '0';
			end if;
		else
			if DERIVATIVE >= THRESHOLD then
				iTOT <= '1';
			else
				iTOT <= '0';
			end if;		
		end if;
		
		oTOT <= iTOT;
		


		if trigger_kill_counter = 0 then
			trigger_kill <= '0';
			if iTOT = '1' and oTOT ='0' and trigger_kill='0' then
				iTRIGGER_OUT <= "1";
				trigger_kill_counter <= TRIGGER_INIB;
				trigger_kill <= '1';
			end if;
		else
			trigger_kill_counter <= trigger_kill_counter -1;
		end if;
		
	end if;
	end process;
end Behavioral; 