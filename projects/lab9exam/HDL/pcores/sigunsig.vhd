----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.03.2019 10:21:47
-- Design Name: 
-- Module Name: sigunsig - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sigunsig is
    Generic (A_SIZE : integer := 16;
            B_SIZE : integer := 32;
            OPERATION : STRING := "unsign_to_unsign"
            );
    Port ( a : in STD_LOGIC_VECTOR (A_SIZE-1 downto 0);
           b : out STD_LOGIC_VECTOR (B_SIZE-1 downto 0));
end sigunsig;

architecture Behavioral of sigunsig is

    signal A_MAX : std_logic_vector (A_SIZE-1 downto 0);
    signal B_MAX : std_logic_vector (B_SIZE-1 downto 0);
    signal B_MAX2 : std_logic_vector (B_SIZE downto 0);

    signal A_MIN : std_logic_vector (A_SIZE-1 downto 0);
    signal B_MIN : std_logic_vector (B_SIZE-1 downto 0);
    signal A_ZERO : std_logic_vector (A_SIZE-1 downto 0) := (others => '0');
    signal B_ZERO : std_logic_vector (B_SIZE-1 downto 0) := (others => '0');
    
begin

IF_unsign_to_unsign:
   if OPERATION = "unsign_to_unsign" generate
      begin
         A_MAX <= (others => '1');
         B_MAX <= (others => '1');
         A_MIN <= (others => '0');
         B_MIN <= (others => '0');
         
         b <= B_MAX when unsigned(a) > unsigned(B_MAX) else 
              std_logic_vector(resize(unsigned(a), B_SIZE));
   end generate;
   
   
IF_sign_to_sign:
  if OPERATION = "sign_to_sign" generate
     begin
        A_MAX <=  ('0', others => '1');
        B_MAX <=  ('0', others => '1');
        A_MIN <=  ('1', others => '0');
        B_MIN <= ('1', others => '0');
        
        b <= B_MAX when signed(a) > signed(B_MAX) else 
             B_MIN when signed(a) < signed(B_MIN) else 
             std_logic_vector(resize(signed(a), B_SIZE));
  end generate;
   
   
IF_sign_to_unsign:
    if OPERATION = "sign_to_unsign" generate
        begin
           A_MAX <=  ('0', others => '1');
           B_MAX <= (others => '1');
           B_MAX2<= ('0', others => '1');
           A_MIN <=  ('1', others => '0');
           B_MIN <= (others => '0');
           
           b <= B_MIN when signed(a) < signed(B_MIN) else
                B_MAX when signed(a) > signed(B_MAX2) else 
                std_logic_vector(resize(unsigned(a), B_SIZE));
    end generate;
      
IF_unsign_to_sign:
    if OPERATION = "unsign_to_sign" generate
        begin
           A_MAX <= ('0', others => '1');
           B_MAX <=  ('0', others => '1');
           A_MIN <= (others => '0');
           B_MIN <=  ('1', others => '0');
           
           b <= B_MAX when unsigned(a) > unsigned(B_MAX) else 
                B_MIN when unsigned(a) < unsigned(B_ZERO) else 
                std_logic_vector(resize(unsigned(a), B_SIZE));
    end generate;
        
end Behavioral;
