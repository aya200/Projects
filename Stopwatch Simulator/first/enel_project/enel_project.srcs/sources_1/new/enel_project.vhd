----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/26/2018 04:46:27 PM
-- Design Name: 
-- Module Name: enel_project - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity enel_project is
    Port ( clock : in STD_LOGIC;
           enable_1 : in STD_LOGIC;
           enable_led : out STD_LOGIC;
           switch : in STD_LOGIC_VECTOR (3 downto 0);
           enable_2 : in STD_LOGIC;
           led : out STD_LOGIC;
           anode : out STD_LOGIC_VECTOR (7 downto 0);
           cathode : out STD_LOGIC_VECTOR (6 downto 0));
end enel_project;

architecture Behavioral of enel_project is
signal BOB : STD_LOGIC_VECTOR (3 downto 0) := "0000";
signal UFU : STD_LOGIC_VECTOR (15 downto 0);

begin process (clock)

begin
if (clock = '1' and clock'event) then
    if enable_1 = '1' then
        UFU <= UFU + 1;
        
        if UFU = "1111111111111111" then
            BOB <= BOB + 1;
                if (BOB <= switch) then
                    led <= '1';
                else
                    led <= '0';
                end if;
        end if;
    end if; 
end if;

enable_led <= enable_1;

if enable_2 = '1' then
    anode <= "11111110";
else
    anode <= "11111111";
end if;

end process;

with switch select
cathode <= "1000000" when "0000",   --0
           "1111001" when "0001",   --1
           "0100100" when "0010",   --2
           "0110000" when "0011",   --3
           "0011001" when "0100",   --4
           "0010010" when "0101",   --5
           "0000010" when "0110",   --6
           "1111000" when "0111",   --7
           "0000000" when "1000",   --8
           "0010000" when "1001",   --9
           "0001000" when "1010",   --A
           "0000011" when "1011",   --B
           "1000110" when "1100",   --C
           "0100001" when "1101",   --D
           "0000110" when "1110",   --E
           "0001110" when "1111",   --F
           "1111111" when others;

end Behavioral;
