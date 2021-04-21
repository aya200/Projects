 ----------------------------------------------------------------------------------
-- Name: Ufuoma Aya
-- SID: 200327306
-- Course: ENEL 489
-- Project: Neural Network 
-- Module Name: nn_tb
-- Target Device: Zedboard 
 ----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.nn_package.all;

entity nn_tb is
--  Port ( );
end nn_tb;

architecture Behavioral of nn_tb is

component nn is
    Port ( 
            clk : in std_logic;
            x_in : in x_array;
            y_out : out y_array);
end component;

    constant Time_delta: time := 5 ns;
    constant Time_delta1: time := 15 ns;
    signal clk : STD_LOGIC;
    signal x_in : x_array;
    signal y_out : y_array;

begin
    ct: nn port map( x_in => x_in, y_out => y_out, clk => clk);
    process
    begin
        CLK <= '0';
        wait for time_delta;
        CLK <= '1';
        wait for time_delta;
    end process;

    process
    begin
        --x_in <= ("0110110000100101","0101111010011000","0000000000110000","0110110010100010","0101111001101111","0000000000110001");
        x_in <= ("0000011011000010","0000010111101001","0000000000000011","0000011011001010","0000010111100110","0000000000000011");
                  
        wait for time_delta;
    end process;

end Behavioral;