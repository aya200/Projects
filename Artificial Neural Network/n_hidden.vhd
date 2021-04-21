 ----------------------------------------------------------------------------------
-- Name: Ufuoma Aya
-- SID: 200327306
-- Course: ENEL 489
-- Project: Neural Network 
-- Module Name: n_hidden
-- Target Device: Zedboard 
 ----------------------------------------------------------------------------------
 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.nn_package.all;

entity n_hidden is
    Port (  clk : in std_logic; 
            x, w : in x_array;
            bi : in signed(N-1 downto 0);
            sum_out : out signed(N-1 downto 0));
end n_hidden;

architecture Behavioral of n_hidden is
    component mult
        port(   a : in signed(N-1 downto 0);
                b : in signed(N-1 downto 0);
                c : out signed(N-1 downto 0));
    end component;
    
    signal mult_array : x_array;
    signal sum : signed(N-1 downto 0);

begin
    multGEN_0: for i in 0 to NUM_X-1 generate
    begin
        mult_0: mult port map(a => x(i), b => w(i), c => mult_array(i));
    end generate;
	
	process (clk)
	variable sum_1 : signed(15 downto 0);
	begin 
	   if rising_edge(clk) then
	       sum_1  := (others=>'0');
	
        sumGEN_0: for i in 0 to NUM_X-1 loop
        --begin
            sum_1 := mult_array(i) + sum_1; 
        end loop;
        
        sum_1 := sum_1 + bi;
        end if;
     
        sum <= sum_1;
    end process;
   
    sum_out <= resize(sum, N);

end Behavioral;