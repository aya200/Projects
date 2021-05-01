----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/27/2018 10:27:30 AM
-- Design Name: 
-- Module Name: project_384 - Behavioral
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

entity project_384 is
    Port ( switch : in STD_LOGIC_VECTOR (3 downto 0);
           CLK : in STD_LOGIC;
           anode : out STD_LOGIC_VECTOR (7 downto 0);
           cathode : out STD_LOGIC_VECTOR (7 downto 0));
end project_384;

architecture Behavioral of project_384 is

component project_divider port (CLK : in STD_LOGIC;
           clock_reset : out STD_LOGIC;
           clock_num1 : out STD_LOGIC);
end component;

signal sig_reset, sig_num1 : STD_LOGIC;

component project_display port (clock_reset, clock_num1 : in STD_LOGIC;
           switch : in STD_LOGIC_VECTOR (3 downto 0);
           anode : out STD_LOGIC_VECTOR (7 downto 0);
           cathode : out STD_LOGIC_VECTOR (7 downto 0));
end component;

begin

part0 : project_divider port map (CLK => CLK, clock_reset => sig_reset, clock_num1 => sig_num1);
part1 : project_display port map (clock_reset => sig_reset, clock_num1 => sig_num1, switch => switch, anode => anode, cathode => cathode);


end Behavioral;
