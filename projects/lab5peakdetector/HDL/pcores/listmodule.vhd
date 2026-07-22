------------------------------------------------------------------
--						Nuclear Instruments						--
--																--
--							SciCompiler							--
--																--
--	Module:				FIFO (XILINX)							--
--	Version:			1.2.1.0										--
--	Creation Data:		01-08-2025								--
--																--
--																--
------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_MISC.ALL;
use ieee.math_real.all;
Library xpm;
use xpm.vcomponents.all;



entity LISTMODULE is
  Generic (	
			bitsize : integer := 32;
			channels : integer := 1;
			fifolength : integer := 16);
  port (
	RESET : IN STD_LOGIC_VECTOR (0 DOWNTO 0);
	CLK_READ : IN STD_LOGIC_VECTOR (0 DOWNTO 0);
	CLK_WRITE : IN STD_LOGIC_VECTOR (0 DOWNTO 0);
    DATAIN : IN STD_LOGIC_VECTOR ((channels*bitsize)-1 DOWNTO 0);
	WE : IN STD_LOGIC_VECTOR (0 DOWNTO 0);
	BUSY: OUT STD_LOGIC_VECTOR (0 downto 0);
	FULL: OUT STD_LOGIC_VECTOR (0 downto 0);
	RUNNING: OUT STD_LOGIC_VECTOR (0 downto 0);
	CLEAR: OUT STD_LOGIC_VECTOR (0 downto 0);
	READ_DATA : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	READ_DATAVALID : OUT STD_LOGIC_VECTOR (0 DOWNTO 0);
	READ_NEXT : IN STD_LOGIC_VECTOR (0 DOWNTO 0);
	STATUS : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	CONFIG : IN STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
end;


architecture Behavioral of LISTMODULE is

	constant wBits : integer := integer(ceil(log2(real(fifolength))));
	constant rBits : integer := integer(ceil(log2(real(fifolength * (channels*bitsize)/32))));

	COMPONENT dcfifo_mixed_widths
	GENERIC (
		intended_device_family		: STRING;
		lpm_numwords		: NATURAL;
		lpm_showahead		: STRING;
		lpm_type		: STRING;
		lpm_width		: NATURAL;
		lpm_widthu		: NATURAL;
		lpm_widthu_r		: NATURAL;
		lpm_width_r		: NATURAL;
		overflow_checking		: STRING;
		rdsync_delaypipe		: NATURAL;
		read_aclr_synch		: STRING;
		underflow_checking		: STRING;
		use_eab		: STRING;
		write_aclr_synch		: STRING;
		wrsync_delaypipe		: NATURAL
	);
	PORT (
			aclr	: IN STD_LOGIC ;
			data	: IN STD_LOGIC_VECTOR ((channels*bitsize)-1 DOWNTO 0);
			rdclk	: IN STD_LOGIC ;
			rdreq	: IN STD_LOGIC ;
			wrclk	: IN STD_LOGIC ;
			wrreq	: IN STD_LOGIC ;
			q	: OUT STD_LOGIC_VECTOR (32-1 DOWNTO 0);
			rdempty	: OUT STD_LOGIC ;
			wrfull	: OUT STD_LOGIC 
	);
	END COMPONENT;

	signal iEMPTY : std_logic := '0';
	signal iFULL : std_logic := '0';

	signal iRESET : std_logic := '0';
	signal iWRITE : std_logic := '0';
	signal iREAD_NEXT : std_logic := '0';

	signal AVAL_WORD : std_logic_vector (rBits-1 downto 0) := (others => '0');
	signal AVAL_WORD_SAT : std_logic_vector (rBits-1 downto 0) := (others => '0');
	
	signal CONFIG_RD_DOMAIN :  STD_LOGIC_VECTOR (31 DOWNTO 0):= (others => '0');
	signal STATUS_RD_DOMAIN :  STD_LOGIC_VECTOR (31 DOWNTO 0):= (others => '0');
	signal STATUS_w_DOMAIN :  STD_LOGIC_VECTOR (31 DOWNTO 0):= (others => '0');
begin

	xpm_fifo_async_inst : xpm_fifo_async
	generic map (
	FIFO_MEMORY_TYPE => "auto", --string; "auto", "block", or "distributed";
	ECC_MODE => "no_ecc", --string; "no_ecc" or "en_ecc";
	RELATED_CLOCKS => 0, --positive integer; 0 or 1
	FIFO_WRITE_DEPTH => fifolength, --positive integer
	WRITE_DATA_WIDTH => bitsize*channels, --positive integer
	WR_DATA_COUNT_WIDTH => wBits, --positive integer
	PROG_FULL_THRESH => 5, --positive integer
	FULL_RESET_VALUE => 0, --positive integer; 0 or 1;
	READ_MODE => "std", --string; "std" or "fwft";
	FIFO_READ_LATENCY => 1, --positive integer;
	READ_DATA_WIDTH => 32, --positive integer
	RD_DATA_COUNT_WIDTH => rBits, --positive integer
	PROG_EMPTY_THRESH => 3, --positive integer
	DOUT_RESET_VALUE => "0", --string
	CDC_SYNC_STAGES => 2, --positive integer
	WAKEUP_TIME => 0 --positive integer; 0 or 2;
	)
	port map (
		sleep => '0',
		rst => iRESET,
		wr_clk => CLK_WRITE(0),
		wr_en => iWRITE,
		din =>  DATAIN,
		full => iFULL,
		overflow => open,
		wr_rst_busy => open,
		rd_clk => CLK_READ(0),
		rd_en => iREAD_NEXT,
		dout => READ_DATA,
		empty => open,
		underflow => open,
		rd_rst_busy => open,
		prog_full => open,
		wr_data_count => open,
		prog_empty => iEMPTY,
		rd_data_count => AVAL_WORD,
		injectsbiterr => '0',
		injectdbiterr => '0',
		sbiterr => open,
		dbiterr => open
	);


	

	STATUS_RD_DOMAIN <= ext(AVAL_WORD,24) & x"0" & "00" & "0" & iEMPTY;
	iRESET	<= CONFIG(1) or RESET(0);
	iWRITE	<= CONFIG(0) and WE(0) and (not iFULL);
	iREAD_NEXT <= CONFIG_RD_DOMAIN(0) and READ_NEXT(0);
	BUSY(0) <= not CONFIG(0) or iFULL;
	FULL(0) <= iFULL;
	READ_DATAVALID(0) <= not iEMPTY;
	RUNNING(0) <= CONFIG(0);
	CLEAR(0) <= iRESET;
	
	
	

-- <-----Cut code below this line and paste into the architecture body---->

   -- xpm_cdc_array_single: Single-bit Array Synchronizer
   -- Xilinx Parameterized Macro, version 2020.2

   xpm_cdc_config : xpm_cdc_array_single
   generic map (
      DEST_SYNC_FF => 2,   -- DECIMAL; range: 2-10
      INIT_SYNC_FF => 0,   -- DECIMAL; 0=disable simulation init values, 1=enable simulation init values
      SIM_ASSERT_CHK => 0, -- DECIMAL; 0=disable simulation messages, 1=enable simulation messages
      SRC_INPUT_REG => 1,  -- DECIMAL; 0=do not register input, 1=register input
      WIDTH => 32           -- DECIMAL; range: 1-1024
   )
   port map (
      dest_out => CONFIG_RD_DOMAIN, -- WIDTH-bit output: src_in synchronized to the destination clock domain. This
                            -- output is registered.

      dest_clk => CLK_READ(0), -- 1-bit input: Clock signal for the destination clock domain.
      src_clk => CLK_WRITE(0),   -- 1-bit input: optional; required when SRC_INPUT_REG = 1
      src_in => CONFIG      -- WIDTH-bit input: Input single-bit array to be synchronized to destination clock
                            -- domain. It is assumed that each bit of the array is unrelated to the others.
                            -- This is reflected in the constraints applied to this macro. To transfer a binary
                            -- value losslessly across the two clock domains, use the XPM_CDC_GRAY macro
                            -- instead.

   );
   
   
   STATUS <= STATUS_w_DOMAIN(31 downto 2) & iFULL & STATUS_w_DOMAIN(0);
   
      xpm_cdc_status : xpm_cdc_array_single
   generic map (
      DEST_SYNC_FF => 2,   -- DECIMAL; range: 2-10
      INIT_SYNC_FF => 0,   -- DECIMAL; 0=disable simulation init values, 1=enable simulation init values
      SIM_ASSERT_CHK => 0, -- DECIMAL; 0=disable simulation messages, 1=enable simulation messages
      SRC_INPUT_REG => 1,  -- DECIMAL; 0=do not register input, 1=register input
      WIDTH => 32           -- DECIMAL; range: 1-1024
   )
   port map (
      dest_out => STATUS_w_DOMAIN, -- WIDTH-bit output: src_in synchronized to the destination clock domain. This
                            -- output is registered.

      dest_clk => CLK_WRITE(0), -- 1-bit input: Clock signal for the destination clock domain.
      src_clk => CLK_READ(0),   -- 1-bit input: optional; required when SRC_INPUT_REG = 1
      src_in => STATUS_RD_DOMAIN      -- WIDTH-bit input: Input single-bit array to be synchronized to destination clock
                            -- domain. It is assumed that each bit of the array is unrelated to the others.
                            -- This is reflected in the constraints applied to this macro. To transfer a binary
                            -- value losslessly across the two clock domains, use the XPM_CDC_GRAY macro
                            -- instead.

   );

    

end Behavioral; 