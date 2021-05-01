----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/27/2018 10:27:30 AM
-- Design Name: 
-- Module Name: project_display - Behavioral
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

entity project_display is
    Port ( clock_reset : in STD_LOGIC;
           clock_num1 : in STD_LOGIC;
           switch : in STD_LOGIC_VECTOR (3 downto 0);
           anode : out STD_LOGIC_VECTOR (7 downto 0);
           cathode : out STD_LOGIC_VECTOR (7 downto 0));
end project_display;

architecture Behavioral of project_display is

    signal en, lap, displayer : std_logic:= '0';
    signal push_button_sig_start, push_button_sig_save_lap, push_button_sig1,
 push_button_sig2, 
    push_button_sig_display_lap, push_button_sig3, lap_count, lap_display
 : integer:=0;
    signal count_num1, count_num2, count_num3, count_num4, use_1, use_2, use_3, use_4 : integer := 0;
    signal lap_num1, lap_num2, lap_num3, lap_num4, lap_num12, lap_num22, lap_num32, lap_num42,
           lap_num13, lap_num23, lap_num33, lap_num43 : integer := 0;
begin

display : process (clock_reset, clock_num1, switch, en, lap) is

begin

    if (switch(1) = '1' and en = '0') then
        use_1 <= 0;
        use_2 <= 0;
        use_3 <= 0;
        use_4 <= 0;
        count_num1 <= 0;
        count_num2 <= 0;
        count_num3 <= 0;
        count_num4 <= 0;
        lap_num1 <= 0;
        lap_num2 <= 0;
        lap_num3 <= 0;
        lap_num4 <= 0;
        lap_num12 <= 0;
        lap_num22 <= 0;
        lap_num32 <= 0;
        lap_num42 <= 0;
        lap_num13 <= 0;
        lap_num23 <= 0;
        lap_num33 <= 0;
        lap_num43 <= 0;
    end if;
    
    if (displayer = '1' and en = '0') then
        if (lap_display = 1) then
            use_1 <= lap_num1;
            use_2 <= lap_num2;
            use_3 <= lap_num3;
            use_4 <= lap_num4;
            elsif (lap_display = 2) then
            use_1 <= lap_num12;
            use_2 <= lap_num22;
            use_3 <= lap_num32;
            use_4 <= lap_num42;
            elsif (lap_display = 3) then
            use_1 <= lap_num13;
            use_2 <= lap_num23;
            use_3 <= lap_num33;
            use_4 <= lap_num43;
        end if;
    end if;
    if (rising_edge(clock_num1)) then
        if (en = '1') then
            use_1 <= count_num1;
            use_2 <= count_num2;
            use_3 <= count_num3;
            use_4 <= count_num4;
            if (lap = '1') then
                if (lap_count = 1) then
                    lap_num1 <= count_num1;
                    lap_num2 <= count_num2;
                    lap_num3 <= count_num3;
                    lap_num4 <= count_num4;
                elsif (lap_count = 2) then
                    lap_num12 <= count_num1;
                    lap_num22 <= count_num2;
                    lap_num32 <= count_num3;
                    lap_num42 <= count_num4;
                elsif (lap_count = 3) then
                    lap_num13 <= count_num1;
                    lap_num23 <= count_num2;
                    lap_num33 <= count_num3;
                    lap_num43 <= count_num4;
                end if;
            end if;
            
            count_num1 <= count_num1 + 1;
            if (count_num1 = 9) then
                count_num1 <= 0;
                count_num2 <= count_num2 + 1;
                if (count_num2 = 9) then
                    count_num2 <= 0;
                    count_num3 <= count_num3 + 1;
                        if (count_num3 = 9) then
                            count_num3 <= 0;
                            count_num4 <= count_num4 + 1;
                                if (count_num4 = 9) then
                                    count_num4 <= 0;
                                end if;
                        end if;
                end if;
            end if;
        end if;
    end if;
    
end process display;

process (clock_reset)

variable digit : unsigned (1 downto 0) := "00";

begin

    if(rising_edge(clock_reset)) then
        case digit is
            when "00" =>
                case (use_1) is
                    when 0 =>
                        anode <= "11111110";
                        cathode <= "11000000";
                    when 1 =>
                        anode <= "11111110";
                        cathode <= "11111001";
                    when 2 =>
                        anode <= "11111110";
                        cathode <= "10100100";
                    when 3 =>
                        anode <= "11111110";
                        cathode <= "10110000";
                    when 4 =>
                        anode <= "11111110";
                        cathode <= "10011001";
                    when 5 =>
                        anode <= "11111110";
                        cathode <= "10010010";
                    when 6 =>
                        anode <= "11111110";
                        cathode <= "10000010";
                    when 7 =>
                        anode <= "11111110";
                        cathode <= "11111000";
                    when 8 =>
                        anode <= "11111110";
                        cathode <= "10000000";
                    when 9 =>
                        anode <= "11111110";
                        cathode <= "10010000";
                    when others =>
                        anode <= "11111110";
                        cathode <= "11111111";
                end case;
                
            when "01" =>
                case (use_2) is
                    when 0 =>
                        anode <= "11111101";
                        cathode <= "11000000";
                    when 1 =>
                        anode <= "11111101";
                        cathode <= "11111001";
                    when 2 =>
                        anode <= "11111101";
                        cathode <= "10100100";
                    when 3 =>
                        anode <= "11111101";
                        cathode <= "10110000";
                    when 4 =>
                        anode <= "11111101";
                        cathode <= "10011001";
                    when 5 =>
                        anode <= "11111101";
                        cathode <= "10010010";
                    when 6 =>
                        anode <= "11111101";
                        cathode <= "10000010";
                    when 7 =>
                        anode <= "11111101";
                        cathode <= "11111000";
                    when 8 =>
                        anode <= "11111101";
                        cathode <= "10000000";
                    when 9 =>
                        anode <= "11111101";
                        cathode <= "10010000";
                    when others =>
                        anode <= "11111101";
                        cathode <= "11111111";
                end case;
                
            when "10" =>
                case (use_3) is
                    when 0 =>
                        anode <= "11111011";
                        cathode <= "01000000";
                    when 1 =>
                        anode <= "11111011";
                        cathode <= "01111001";
                    when 2 =>
                        anode <= "11111011";
                        cathode <= "00100100";
                    when 3 =>
                        anode <= "11111011";
                        cathode <= "00110000";
                    when 4 =>
                        anode <= "11111011";
                        cathode <= "00011001";
                    when 5 =>
                        anode <= "11111011";
                        cathode <= "00010010";
                    when 6 =>
                        anode <= "11111011";
                        cathode <= "00000010";
                    when 7 =>
                        anode <= "11111011";
                        cathode <= "01111000";
                    when 8 =>
                        anode <= "11111011";
                        cathode <= "00000000";
                    when 9 =>
                        anode <= "11111011";
                        cathode <= "00010000";
                    when others =>
                        anode <= "11111011";
                        cathode <= "01111111";
                end case;
                
            when "11" =>
                case (use_4) is
                    when 0 =>
                        anode <= "11110111";
                        cathode <= "11000000";
                    when 1 =>
                        anode <= "11110111";
                        cathode <= "11111001";
                    when 2 =>
                        anode <= "11110111";
                        cathode <= "10100100";
                    when 3 =>
                        anode <= "11110111";
                        cathode <= "10110000";
                    when 4 =>
                        anode <= "11110111";
                        cathode <= "10011001";
                    when 5 =>
                        anode <= "11110111";
                        cathode <= "10010010";
                    when 6 =>
                        anode <= "11110111";
                        cathode <= "10000010";
                    when 7 =>
                        anode <= "11110111";
                        cathode <= "11111000";
                    when 8 =>
                        anode <= "11110111";
                        cathode <= "10000000";
                    when 9 =>
                        anode <= "11110111";
                        cathode <= "10010000";
                    when others =>
                        anode <= "11110111";
                        cathode <= "11111111";
                end case;
        end case;
        
        digit := digit + 1;
    end if;
end process;

process(count_num1)
begin

    if (rising_edge(clock_num1)) then
        if (switch(3) = '1') then
            push_button_sig_display_lap <= 1;
        elsif (switch(3) = '0') then
            push_button_sig_display_lap <= 0;
    end if;
    
push_button_sig3 <= push_button_sig_display_lap;
    if (push_button_sig3 = 0 and push_button_sig_display_lap = 1) then
        displayer <= '1';
        lap_display <= lap_display + 1;
        if (lap_display = 3) then
            lap_display <= 1;
        end if;
    elsif (push_button_sig3 = 1 and push_button_sig_display_lap = 0) then
        displayer <= '0';
    end if;
    
        if (switch(2) = '1') then
            push_button_sig_save_lap <= 1;
        elsif (switch(2) = '0') then
              push_button_sig_save_lap <= 0;
        end if;
        push_button_sig2 <= push_button_sig_save_lap;
        if (push_button_sig2 = 0 and push_button_sig_save_lap = 1) then
            lap <= '1';
            lap_count <= lap_count + 1;
            if (lap_count = 3) then
                lap_count <= 1;
            end if;
        elsif (push_button_sig2 = 1 and push_button_sig_save_lap = 0) then
            lap <= '0';
        end if;
        
        if (switch(0) = '1') then
            push_button_sig_start <= 1;
        elsif (switch(0) = '0') then
            push_button_sig_start <= 0;
        end if;
        push_button_sig1 <= push_button_sig_start;
        if (push_button_sig1 = 0 and push_button_sig_start = 1) then
            en <= not en;
            lap_display <= 0;
        end if;
        
        if (switch(1) = '1' and en = '0') then
            lap_count <= 0;
            lap_display <= 0;
        end if;
    end if;
end process;
end Behavioral;
