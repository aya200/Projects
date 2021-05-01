----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/27/2018 10:27:30 AM
-- Design Name: 
-- Module Name: project_divider - Behavioral
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

entity project_divider is
    Port ( CLK : in STD_LOGIC;
           clock_reset : out STD_LOGIC;
           clock_num1 : out STD_LOGIC);
end project_divider;

architecture Behavioral of project_divider is

signal count_1: integer :=0;
signal count_2: integer :=0;
signal temp_1: STD_LOGIC :='0';
signal temp_2: STD_LOGIC :='0';

begin

frequencyDivider: process(CLK)
    begin   
    if rising_edge(CLK) then
        count_1 <= count_1 + 1;
        count_2 <= count_2 + 1;
        
        if (count_1 = 208334) then
            temp_1 <= NOT temp_1;
            count_1 <= 0;
        end if;
        
        if (count_2 = 500000) then
           temp_2 <= NOT temp_2;
           count_2 <= 0;
        end if;
    end if;
end process;

clock_reset <= temp_1;
clock_num1 <= temp_2;
        
end Behavioral;
