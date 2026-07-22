----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.03.2019 15:43:42
-- Design Name: 
-- Module Name: avalon_wrapper - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity subdesign_1_pmc is
    Port (  clk : in STD_LOGIC;
            reset : in STD_LOGIC;
			
	        -- Register interface          
		REG_THRESHOLD_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_THRESHOLD_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_THRESHOLD_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_THRESHOLD_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_DELTA_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_DELTA_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_DELTA_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		INT_DELTA_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
	BUS_Spectrum_0_READ_ADDRESS : OUT STD_LOGIC_VECTOR(15 downto 0); 
	BUS_Spectrum_0_READ_DATA : IN STD_LOGIC_VECTOR(31 downto 0); 
	BUS_Spectrum_0_WRITE_DATA : OUT STD_LOGIC_VECTOR(31 downto 0); 
	BUS_Spectrum_0_W_INT : OUT STD_LOGIC_VECTOR(0 downto 0); 
	BUS_Spectrum_0_R_INT : OUT STD_LOGIC_VECTOR(0 downto 0); 
	BUS_Spectrum_0_VLD : IN STD_LOGIC_VECTOR(0 downto 0); 
		REG_Spectrum_0_STATUS_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		INT_Spectrum_0_STATUS_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_Spectrum_0_CONFIG_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_Spectrum_0_CONFIG_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_Spectrum_0_CONFIG_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_Spectrum_0_CONFIG_LIMIT_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_Spectrum_0_CONFIG_LIMIT_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_Spectrum_0_CONFIG_LIMIT_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_Spectrum_0_CONFIG_REBIN_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_Spectrum_0_CONFIG_REBIN_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_Spectrum_0_CONFIG_REBIN_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_Spectrum_0_CONFIG_MIN_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_Spectrum_0_CONFIG_MIN_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_Spectrum_0_CONFIG_MIN_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_Spectrum_0_CONFIG_MAX_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_Spectrum_0_CONFIG_MAX_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_Spectrum_0_CONFIG_MAX_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
	BUS_Oscilloscope_0_READ_ADDRESS : OUT STD_LOGIC_VECTOR(11 downto 0); 
	BUS_Oscilloscope_0_READ_DATA : IN STD_LOGIC_VECTOR(31 downto 0); 
	BUS_Oscilloscope_0_WRITE_DATA : OUT STD_LOGIC_VECTOR(31 downto 0); 
	BUS_Oscilloscope_0_W_INT : OUT STD_LOGIC_VECTOR(0 downto 0); 
	BUS_Oscilloscope_0_R_INT : OUT STD_LOGIC_VECTOR(0 downto 0); 
	BUS_Oscilloscope_0_VLD : IN STD_LOGIC_VECTOR(0 downto 0); 
		REG_Oscilloscope_0_READ_STATUS_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		INT_Oscilloscope_0_READ_STATUS_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_Oscilloscope_0_READ_POSITION_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		INT_Oscilloscope_0_READ_POSITION_RD : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_Oscilloscope_0_CONFIG_TRIGGER_MODE_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_Oscilloscope_0_CONFIG_TRIGGER_MODE_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_Oscilloscope_0_CONFIG_TRIGGER_MODE_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_Oscilloscope_0_CONFIG_PRETRIGGER_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_Oscilloscope_0_CONFIG_PRETRIGGER_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_Oscilloscope_0_CONFIG_PRETRIGGER_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_Oscilloscope_0_CONFIG_TRIGGER_LEVEL_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_Oscilloscope_0_CONFIG_TRIGGER_LEVEL_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_Oscilloscope_0_CONFIG_TRIGGER_LEVEL_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_Oscilloscope_0_CONFIG_ARM_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_Oscilloscope_0_CONFIG_ARM_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_Oscilloscope_0_CONFIG_ARM_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
		REG_Oscilloscope_0_CONFIG_DECIMATOR_WR : OUT STD_LOGIC_VECTOR(31 downto 0); 
		INT_Oscilloscope_0_CONFIG_DECIMATOR_WR : OUT STD_LOGIC_VECTOR(0 downto 0); 
		REG_Oscilloscope_0_CONFIG_DECIMATOR_RD : IN STD_LOGIC_VECTOR(31 downto 0); 
	

            BUS_READ_DATA : OUT STD_LOGIC_VECTOR(31 downto 0);
			BUS_ADDRESS : IN STD_LOGIC_VECTOR(31 downto 0); 
			BUS_WRITE_DATA : IN STD_LOGIC_VECTOR(31 downto 0); 
			BUS_INT_RD : IN STD_LOGIC_VECTOR(0 downto 0); 
			BUS_INT_WR : IN STD_LOGIC_VECTOR(0 downto 0); 
			BUS_VLD : OUT STD_LOGIC_VECTOR(0 downto 0)        


    );
end subdesign_1_pmc;

architecture Behavioral of subdesign_1_pmc is
    --DA FPGA A PC
	signal f_BUS_INT_RD 	 :  STD_LOGIC;						--INTERRUPT DI LETTURA
	signal f_BUS_DATASTROBE  :  STD_LOGIC;						--CONFERMA CHE I DATI RICHIESTI SONO DISPONIBILI
	signal f_BUS_DATASTROBE_REG  :  STD_LOGIC;						--CONFERMA CHE I DATI RICHIESTI SONO DISPONIBILI (REGISTRI)
	signal f_BUS_DATA_RD	 :  STD_LOGIC_VECTOR(31 downto 0);	--DATI DA INVIARE AL PC
	signal f_BUS_DATA_RD_REG :  STD_LOGIC_VECTOR(31 downto 0);	--DATI DA INVIARE AL PC (REGISTRI)
	signal BUS_ADDR :  STD_LOGIC_VECTOR(31 downto 0);	         --INDIRIZZI
	
	--DA PC A FPGA
	signal f_BUS_INT_WR 	 :  STD_LOGIC;						--INTERRUPT DI SCRITTURA
	signal f_BUS_DATA_WR	 :  STD_LOGIC_VECTOR(31 downto 0);	--DATI DA INVIATI DAL PC
	signal wreg				 :  STD_LOGIC_VECTOR(31 downto 0);
	signal addr 			 : STD_LOGIC_VECTOR(31 downto 0);
	
	attribute keep : string;  
	attribute keep of BUS_ADDR: signal is "true"; 
	
begin


    
BUS_Spectrum_0_R_INT(0) <= f_BUS_INT_RD when (addr >= x"00010000" And addr < x"00020000") else '0';
BUS_Spectrum_0_READ_ADDRESS <= addr(15 downto 0) when (addr >= x"00010000" And addr < x"00020000") Else (others => '0');BUS_Oscilloscope_0_R_INT(0) <= f_BUS_INT_RD when (addr >= x"00021000" And addr < x"00022000") else '0';
BUS_Oscilloscope_0_READ_ADDRESS <= addr(11 downto 0) when (addr >= x"00021000" And addr < x"00022000") Else (others => '0');
f_BUS_DATA_RD <= BUS_Spectrum_0_READ_DATA  when  addr >= x"00010000" and addr < x"00020000" else 
BUS_Oscilloscope_0_READ_DATA  when  addr >= x"00021000" and addr < x"00022000" else 
 f_BUS_DATA_RD_REG;
 f_BUS_DATASTROBE <= BUS_Spectrum_0_VLD(0) when  addr >= x"00010000" and addr < x"00020000" else 
 BUS_Oscilloscope_0_VLD(0) when  addr >= x"00021000" and addr < x"00022000" else 
 f_BUS_DATASTROBE_REG;    

        
    addr <= BUS_ADDRESS;
    wreg <= BUS_WRITE_DATA;
        
        register_manager : process(clk)
            variable rreg    :  STD_LOGIC_VECTOR(31 downto 0);
        begin
            if reset='1' then
--                		REG_THRESHOLD_WR <= (others => '0');
		INT_THRESHOLD_WR <= "0";
		INT_THRESHOLD_RD <= "0";
		REG_DELTA_WR <= (others => '0');
		INT_DELTA_WR <= "0";
		INT_DELTA_RD <= "0";
	BUS_Spectrum_0_W_INT <= "0";
		INT_Spectrum_0_STATUS_RD <= "0";
		REG_Spectrum_0_CONFIG_WR <= (others => '0');
		INT_Spectrum_0_CONFIG_WR <= "0";
		REG_Spectrum_0_CONFIG_LIMIT_WR <= (others => '0');
		INT_Spectrum_0_CONFIG_LIMIT_WR <= "0";
		REG_Spectrum_0_CONFIG_REBIN_WR <= (others => '0');
		INT_Spectrum_0_CONFIG_REBIN_WR <= "0";
		REG_Spectrum_0_CONFIG_MIN_WR <= (others => '0');
		INT_Spectrum_0_CONFIG_MIN_WR <= "0";
		REG_Spectrum_0_CONFIG_MAX_WR <= (others => '0');
		INT_Spectrum_0_CONFIG_MAX_WR <= "0";
	BUS_Oscilloscope_0_W_INT <= "0";
		INT_Oscilloscope_0_READ_STATUS_RD <= "0";
		INT_Oscilloscope_0_READ_POSITION_RD <= "0";
		REG_Oscilloscope_0_CONFIG_TRIGGER_MODE_WR <= (others => '0');
		INT_Oscilloscope_0_CONFIG_TRIGGER_MODE_WR <= "0";
		REG_Oscilloscope_0_CONFIG_PRETRIGGER_WR <= (others => '0');
		INT_Oscilloscope_0_CONFIG_PRETRIGGER_WR <= "0";
		REG_Oscilloscope_0_CONFIG_TRIGGER_LEVEL_WR <= (others => '0');
		INT_Oscilloscope_0_CONFIG_TRIGGER_LEVEL_WR <= "0";
		REG_Oscilloscope_0_CONFIG_ARM_WR <= (others => '0');
		INT_Oscilloscope_0_CONFIG_ARM_WR <= "0";
		REG_Oscilloscope_0_CONFIG_DECIMATOR_WR <= (others => '0');
		INT_Oscilloscope_0_CONFIG_DECIMATOR_WR <= "0";
            
                f_BUS_DATASTROBE_REG <= '0';
            elsif rising_edge(clk) then

    		INT_THRESHOLD_WR <= "0";
		INT_THRESHOLD_RD <= "0";
		INT_DELTA_WR <= "0";
		INT_DELTA_RD <= "0";
	BUS_Spectrum_0_W_INT <= "0";
		INT_Spectrum_0_STATUS_RD <= "0";
		INT_Spectrum_0_CONFIG_WR <= "0";
		INT_Spectrum_0_CONFIG_LIMIT_WR <= "0";
		INT_Spectrum_0_CONFIG_REBIN_WR <= "0";
		INT_Spectrum_0_CONFIG_MIN_WR <= "0";
		INT_Spectrum_0_CONFIG_MAX_WR <= "0";
	BUS_Oscilloscope_0_W_INT <= "0";
		INT_Oscilloscope_0_READ_STATUS_RD <= "0";
		INT_Oscilloscope_0_READ_POSITION_RD <= "0";
		INT_Oscilloscope_0_CONFIG_TRIGGER_MODE_WR <= "0";
		INT_Oscilloscope_0_CONFIG_PRETRIGGER_WR <= "0";
		INT_Oscilloscope_0_CONFIG_TRIGGER_LEVEL_WR <= "0";
		INT_Oscilloscope_0_CONFIG_ARM_WR <= "0";
		INT_Oscilloscope_0_CONFIG_DECIMATOR_WR <= "0";
  
               f_BUS_DATASTROBE_REG <= '1';
                
               if f_BUS_INT_WR = '1' then
    		if addr = x"00000000" then
			REG_THRESHOLD_WR <= wreg; 
			INT_THRESHOLD_WR <= "1"; 
		end if;
		if addr = x"00000001" then
			REG_DELTA_WR <= wreg; 
			INT_DELTA_WR <= "1"; 
		end if;
		If addr >= x"00010000" And addr < x"00020000" Then
			BUS_Spectrum_0_WRITE_DATA <= wreg; 
			BUS_Spectrum_0_W_INT <= "1"; 
		End If;
		if addr = x"00020001" then
			REG_Spectrum_0_CONFIG_WR <= wreg; 
			INT_Spectrum_0_CONFIG_WR <= "1"; 
		end if;
		if addr = x"00020002" then
			REG_Spectrum_0_CONFIG_LIMIT_WR <= wreg; 
			INT_Spectrum_0_CONFIG_LIMIT_WR <= "1"; 
		end if;
		if addr = x"00020003" then
			REG_Spectrum_0_CONFIG_REBIN_WR <= wreg; 
			INT_Spectrum_0_CONFIG_REBIN_WR <= "1"; 
		end if;
		if addr = x"00020004" then
			REG_Spectrum_0_CONFIG_MIN_WR <= wreg; 
			INT_Spectrum_0_CONFIG_MIN_WR <= "1"; 
		end if;
		if addr = x"00020005" then
			REG_Spectrum_0_CONFIG_MAX_WR <= wreg; 
			INT_Spectrum_0_CONFIG_MAX_WR <= "1"; 
		end if;
		If addr >= x"00021000" And addr < x"00022000" Then
			BUS_Oscilloscope_0_WRITE_DATA <= wreg; 
			BUS_Oscilloscope_0_W_INT <= "1"; 
		End If;
		if addr = x"00022002" then
			REG_Oscilloscope_0_CONFIG_TRIGGER_MODE_WR <= wreg; 
			INT_Oscilloscope_0_CONFIG_TRIGGER_MODE_WR <= "1"; 
		end if;
		if addr = x"00022003" then
			REG_Oscilloscope_0_CONFIG_PRETRIGGER_WR <= wreg; 
			INT_Oscilloscope_0_CONFIG_PRETRIGGER_WR <= "1"; 
		end if;
		if addr = x"00022004" then
			REG_Oscilloscope_0_CONFIG_TRIGGER_LEVEL_WR <= wreg; 
			INT_Oscilloscope_0_CONFIG_TRIGGER_LEVEL_WR <= "1"; 
		end if;
		if addr = x"00022005" then
			REG_Oscilloscope_0_CONFIG_ARM_WR <= wreg; 
			INT_Oscilloscope_0_CONFIG_ARM_WR <= "1"; 
		end if;
		if addr = x"00022006" then
			REG_Oscilloscope_0_CONFIG_DECIMATOR_WR <= wreg; 
			INT_Oscilloscope_0_CONFIG_DECIMATOR_WR <= "1"; 
		end if;

                end if;
        
        
                if f_BUS_INT_RD = '1' then
  --                  f_BUS_DATASTROBE_REG <= '1';
                    rreg := x"DEADBEEF";
    
    		if addr = x"00000000" then
			rreg := REG_THRESHOLD_RD; 
		End If;
		if addr = x"00000001" then
			rreg := REG_DELTA_RD; 
		End If;
		if addr = x"00020000" then
			rreg := REG_Spectrum_0_STATUS_RD; 
		End If;
		if addr = x"00020001" then
			rreg := REG_Spectrum_0_CONFIG_RD; 
		End If;
		if addr = x"00020002" then
			rreg := REG_Spectrum_0_CONFIG_LIMIT_RD; 
		End If;
		if addr = x"00020003" then
			rreg := REG_Spectrum_0_CONFIG_REBIN_RD; 
		End If;
		if addr = x"00020004" then
			rreg := REG_Spectrum_0_CONFIG_MIN_RD; 
		End If;
		if addr = x"00020005" then
			rreg := REG_Spectrum_0_CONFIG_MAX_RD; 
		End If;
		if addr = x"00022000" then
			rreg := REG_Oscilloscope_0_READ_STATUS_RD; 
		End If;
		if addr = x"00022001" then
			rreg := REG_Oscilloscope_0_READ_POSITION_RD; 
		End If;
		if addr = x"00022002" then
			rreg := REG_Oscilloscope_0_CONFIG_TRIGGER_MODE_RD; 
		End If;
		if addr = x"00022003" then
			rreg := REG_Oscilloscope_0_CONFIG_PRETRIGGER_RD; 
		End If;
		if addr = x"00022004" then
			rreg := REG_Oscilloscope_0_CONFIG_TRIGGER_LEVEL_RD; 
		End If;
		if addr = x"00022005" then
			rreg := REG_Oscilloscope_0_CONFIG_ARM_RD; 
		End If;
		if addr = x"00022006" then
			rreg := REG_Oscilloscope_0_CONFIG_DECIMATOR_RD; 
		End If;
    
                   

                    f_BUS_DATA_RD_REG <= rreg;
                    

                end if;
    
            end if;
        end process;
            

    

    f_BUS_INT_RD <= BUS_INT_RD(0);
    f_BUS_INT_WR <= BUS_INT_WR(0);
    BUS_READ_DATA <= f_BUS_DATA_RD;
    f_BUS_DATA_WR <= BUS_WRITE_DATA;
	 BUS_VLD(0) <=f_BUS_DATASTROBE;
    

end Behavioral;
