----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/28/2018 05:16:16 PM
-- Design Name: 
-- Module Name: gran_velocidad - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity gran_velocidad is
    Port ( pb_control : in STD_LOGIC_VECTOR (3 downto 0);
           CLK : in STD_LOGIC;
           anode : out STD_LOGIC_VECTOR (7 downto 0);
           cathode : out STD_LOGIC_VECTOR (6 downto 0);
           led : out STD_LOGIC;
           enable_led : out STD_LOGIC;
           enable_1 : in STD_LOGIC;
           enable : in STD_LOGIC);
end gran_velocidad;

architecture Behavioral of gran_velocidad is

signal count : STD_LOGIC_VECTOR(3 downto 0) := "0000";
signal seconds : STD_LOGIC_VECTOR (15 downto 0);

begin process (CLK)
begin
    if (CLK = '1' and CLK'event) then
        if enable = '1' then
            seconds <= seconds + 1;
            
            if seconds = "1111111111111111" then
                count <= count + 1;
            end if;
        end if;
    end if;

end process;
                                                                                                                                                                                                                             

end Behavioral;
