------------------------------------------------------------------
--						Nuclear Instruments						--
--																--
--							SciCompiler							--
--																--
--	Module:				RR ARBITER FIFO (XILINX)				--
--	Version:			1.1										--
--	Creation Data:		7-11-2024								--
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


entity arbiter_round_robbins_fifop is
    Generic (
           nports : integer := 4;
           nbits : integer := 24;
           timemax : integer := 111;
		   fifolength : integer := 128;
           preemtive_rd : string := "true"
           );
           
    Port ( clk : in STD_LOGIC_VECTOR(0 downto 0);
    ce : in STD_LOGIC_VECTOR(0 downto 0);
           reset : in STD_LOGIC_VECTOR(0 downto 0);
           data_in : in STD_LOGIC_VECTOR (nports*nbits-1 downto 0);
           busy : out STD_LOGIC_VECTOR (nports-1 downto 0);
           we : in STD_LOGIC_VECTOR (nports-1 downto 0);
           out_data : out STD_LOGIC_VECTOR (nbits-1 downto 0);
           out_addr : out STD_LOGIC_VECTOR (7 downto 0);
           out_addr_data : out STD_LOGIC_VECTOR (nbits-1+8 downto 0);
           out_full : in STD_LOGIC_VECTOR(0 downto 0);
           out_dv : out STD_LOGIC_VECTOR(0 downto 0));
end arbiter_round_robbins_fifop;

architecture Behavioral of arbiter_round_robbins_fifop is
    type state_type is (s0,s0b, s1,s2);  --type of state machine.
    signal arbiter_sm: state_type;
    signal current_port : integer range 0 to 127 := 0;
    signal timer : integer  := timemax;
    signal ird :  STD_LOGIC_VECTOR (nports-1 downto 0) := (others => '0');
    signal idv :  STD_LOGIC_VECTOR (0 downto 0) := "0";
	

	constant wBits : integer := integer(ceil(log2(real(fifolength))));
	
	signal vld :  STD_LOGIC_VECTOR (nports-1 downto 0);
	signal iEMPTY :  STD_LOGIC_VECTOR (nports-1 downto 0) := (others => '0');
	signal iFULL :  STD_LOGIC_VECTOR (nports-1 downto 0) := (others => '0');
	signal iWRITE :  STD_LOGIC_VECTOR (nports-1 downto 0) := (others => '0');
	signal data_fifo :  STD_LOGIC_VECTOR (nports*nbits-1 downto 0);
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
			data	: IN STD_LOGIC_VECTOR (nbits-1 DOWNTO 0);
			rdclk	: IN STD_LOGIC ;
			rdreq	: IN STD_LOGIC ;
			wrclk	: IN STD_LOGIC ;
			wrreq	: IN STD_LOGIC ;
			q	: OUT STD_LOGIC_VECTOR (nbits-1 DOWNTO 0);
			rdempty	: OUT STD_LOGIC ;
			wrfull	: OUT STD_LOGIC 
	);
	END COMPONENT;	
      
      
        ATTRIBUTE MARK_DEBUG : string;
        
        ATTRIBUTE MARK_DEBUG of iFULL: SIGNAL IS "TRUE";
        ATTRIBUTE MARK_DEBUG of iWRITE: SIGNAL IS "TRUE";
        ATTRIBUTE MARK_DEBUG of iEMPTY: SIGNAL IS "TRUE";
        ATTRIBUTE MARK_DEBUG of vld: SIGNAL IS "TRUE";
        ATTRIBUTE MARK_DEBUG of idv: SIGNAL IS "TRUE";
        ATTRIBUTE MARK_DEBUG of timer: SIGNAL IS "TRUE";
        ATTRIBUTE MARK_DEBUG of current_port: SIGNAL IS "TRUE";
        ATTRIBUTE MARK_DEBUG of arbiter_sm: SIGNAL IS "TRUE"; 	
    
        signal iout_data : STD_LOGIC_VECTOR (nbits-1 downto 0) := (others => '0');
        signal iout_addr : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');  
        signal rd_delay_counter : integer := 0;
begin


GEN_FIFOS  : for I in 0 to nports-1 generate
      begin
	

        xpm_fifo_async_inst : xpm_fifo_async
        generic map (
	        FIFO_MEMORY_TYPE => "auto", --string; "auto", "block", or "distributed";
	        ECC_MODE => "no_ecc", --string; "no_ecc" or "en_ecc";
	        RELATED_CLOCKS => 0, --positive integer; 0 or 1
	        FIFO_WRITE_DEPTH => fifolength, --positive integer
	        WRITE_DATA_WIDTH => nbits, --positive integer
	        WR_DATA_COUNT_WIDTH => wBits, --positive integer
	        PROG_FULL_THRESH => fifolength-5, --positive integer
	        FULL_RESET_VALUE => 0, --positive integer; 0 or 1;
	        READ_MODE => "std", --string; "std" or "fwft";
	        FIFO_READ_LATENCY => 1, --positive integer;
	        READ_DATA_WIDTH => nbits, --positive integer
	        RD_DATA_COUNT_WIDTH => wBits, --positive integer
	        PROG_EMPTY_THRESH => 3, --positive integer
	        DOUT_RESET_VALUE => "0", --string
	        CDC_SYNC_STAGES => 2, --positive integer
	        WAKEUP_TIME => 0 --positive integer; 0 or 2;
        )
        port map (
	        sleep => '0',
	        rst => RESET(0),
	        wr_clk => clk(0),
	        wr_en => iWRITE(I),
	        din =>  data_in((I+1)*nbits-1 downto I*nbits),
	        full => open,
	        overflow => open,
	        wr_rst_busy => open,
	        rd_clk => clk(0),
	        rd_en => iRD(I),
	        dout => data_fifo((I+1)*nbits-1 downto I*nbits),
	        empty => iEMPTY(I),
	        underflow => open,
	        rd_rst_busy => open,
	        prog_full =>  iFULL(I),
	        wr_data_count => open,
	        prog_empty => open,
	        rd_data_count => open,
	        injectsbiterr => '0',
	        injectdbiterr => '0',
	        sbiterr => open,
	        dbiterr => open
        );


		vld(I) <= not iEMPTY(I);
		iWRITE(I) <= we(I);-- and (not iFULL(I));
		busy(I) <= iFULL(I);
   end generate;
			
		



	
    out_data <= iout_data;
    out_addr <= iout_addr;
    out_addr_data <= iout_addr & iout_data ;

	
    
    out_dv <= idv;
    arbiter_proc : process (clk)
    begin
        if rising_edge(clk(0)) then
            ird <= (others =>'0');
            idv <= "0";
            
            
            if reset(0) = '1' then
                current_port <= 0;
            else
                if ce(0) = '1' then
                    if out_full = "0" then
                        if timer > 0 then
                            timer <= timer -1;
                        end if;
                        
                        case arbiter_sm is
                            when s0 =>
                                if vld(current_port) = '1' and timer > 0 then                 --verify if data available
                                    ird(current_port) <= '1';
                                    arbiter_sm <= s0b;
                                else                                            --skip
                                    if current_port < nports-1 then
                                        current_port <= current_port +1;
                                    else
                                        current_port <= 0;
                                    end if;
                                    timer <= timemax;
                                end if;
                                
                            when s0b =>
                                arbiter_sm <= s1;
                            when s1 =>
                                --out data
                                iout_addr <= conv_std_logic_vector(current_port,8);
                                iout_data <= data_fifo((current_port+1)*nbits-1 downto current_port*nbits);
                                idv <= "1";
                                arbiter_sm <= s0;           

                        when others =>   
                            arbiter_sm <= s0;     
                        end case;
                    end if;
                end if;
            end if;
        
        end if;
    
    end process;   


end Behavioral;
