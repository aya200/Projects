----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/28/2016 01:05:36 PM
-- Design Name: 
-- Module Name: traffic - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity traffic is
    Port ( clk : in STD_LOGIC;
           hold: in STD_LOGIC;
           night : in STD_LOGIC;
           traffic_led : out STD_LOGIC_VECTOR (5 downto 0);
           anode : out STD_LOGIC_VECTOR(7 downto 0);
           c_a : out STD_LOGIC_VECTOR (7 downto 0));
end traffic;

architecture Behavioral of traffic is
signal zen: STD_LOGIC_VECTOR(26 downto 0):="000000000000000000000000000";
signal dami: STD_LOGIC :='1';
signal twait: STD_LOGIC_VECTOR(7 downto 0):= "00000000";
signal t_wait: STD_LOGIC_VECTOR(2 downto 0):= "000";
signal nzen: STD_LOGIC_VECTOR(27 downto 0):="0000000000000000000000000000";
signal bob: STD_LOGIC_VECTOR(2 downto 0):="000";
type state_type is (S0,S1,S2,S3,S4,S5);
signal state_reg, state_next: state_type;

begin
process (clk)
 begin
        if ( clk='1' and clk'event) then    
           zen <= zen + 1 ;
        if night = '0' then  
        if zen = "101111101011110000100000000" then 
           bob <= bob + 1 ;
        end if;
        end if;   
        if night ='1' then
           nzen <= nzen + 1;
        if nzen = "1111111111111111111111111111" then 
           bob <= bob + 1 ;     
     end if;
     end if;
     end if;
end process;

process(clk)
 begin    
        if(clk ='1' and clk'event) then
            state_reg <= state_next;
        end if;
        
          case state_reg is 
                 when S0 =>
                   if (bob = "101") then 
                       state_next <= S1;
                   else 
                       state_next <= S0; 
                   end if;
                 when S1 =>
                   if (bob ="110") then 
                       state_next <= S2;
                   else 
                       state_next <= S1;
                   end if;
                 when S2 =>
                   if (hold = '0') then 
                       state_next <= S3;
                   else 
                       state_next <= S2;
                   end if;
                 when S3 =>
                   if (bob = "101") then
                       state_next <= S4;
                   else
                       state_next <= S3;
                   end if;
                 when S4 =>
                   if (bob = "110") then
                       state_next <= S5;
                   else 
                       state_next <= S4;
                   end if;
                 When S5 =>
                   if (hold ='0') then
                       state_next <= S0;
                   else
                       state_next <= S5;
                   end if;
                 when others =>
                       state_next <= S0;
          end case;
end process;
              
process(state_reg)
 begin
                  case state_reg is
                      when S0 => 
                          traffic_led <="100001";
                          dami <='1';
                      When S1 =>
                          traffic_led <= "010001";
                          dami <='1';
                      when S2 =>
                          traffic_led <="001001";
                          dami <='1';
                      when S3 =>
                          traffic_led <="001100";
                          dami <='0';
                      when S4 =>
                          traffic_led <="001010";
                          dami <='0';
                      When S5 =>
                          traffic_led <="001001";
                          dami <='0';
                      when others => 
                          traffic_led <= "100001";    
                      end case;
end process;
                   
process(clk)
begin
  if ( clk='1' and clk'event) then    
   twait <= twait + 1 ;
 
  if twait = "11111111" then 
   t_wait <= t_wait + 1;
end if;
  if dami= '1' or hold = '1' then
        case t_wait is
           when "000" => anode <= "11111110";
             c_a <= "10001100";
           when "001" => anode <= "11111101";
             c_a <= "11000000";
           when "010" => anode <= "11111011";
             c_a <= "11001110";
           when "011" => anode <= "11110111";
             c_a <= "10010010";
           when others => anode <= "11111111";
               c_a <= "00000000";
           end case;
  end if;
  if dami ='0' or hold = '1' then         
          case t_wait is
           when "000" => anode <= "11101111";
             c_a <= "10001100";
           when "001" => anode <= "11011111";
             c_a <= "11000000";
           when "010" => anode <= "10111111";
             c_a <= "11001110";
           when "011" => anode <= "01111111";
             c_a <= "10010010";
           when others => anode <= "11111111";
             c_a <= "00000000";
           end case;
 end if;          
 end if;
end process;

end Behavioral;
