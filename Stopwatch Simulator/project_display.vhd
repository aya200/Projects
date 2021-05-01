------------------------------------------------------------------------------------
---- Company: 
---- Engineer: 
---- 
---- Create Date: 11/27/2018 10:27:30 AM
---- Design Name: 
---- Module Name: project_display - Behavioral
---- Project Name: 
---- Target Devices: 
---- Tool Versions: 
---- Description: 
---- 
---- Dependencies: 
---- 
---- Revision:
---- Revision 0.01 - File Created
---- Additional Comments:
---- 
------------------------------------------------------------------------------------


--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;

---- Uncomment the following library declaration if using
---- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;


---- Uncomment the following library declaration if instantiating
---- any Xilinx leaf cells in this code.
----library UNISIM;
----use UNISIM.VComponents.all;

--entity project_display is
--    Port ( clock_reset : in STD_LOGIC;
--           clock_num1 : in STD_LOGIC;
--           switch : in STD_LOGIC_VECTOR (3 downto 0);
--           anode : out STD_LOGIC_VECTOR (7 downto 0);
--           cathode : out STD_LOGIC_VECTOR (7 downto 0));
--end project_display;

--architecture Behavioral of project_display is

--    signal enable : std_logic:= '0';
--    signal start_button, sig1_button, lap_display : integer:= 0;
--    signal count_a, count_b, count_c, count_d, disp_1, disp_2, disp_3, disp_4 : integer := 0;
 
--begin process (clock_reset, clock_num1, switch, enable) is
--begin
--    if (switch(1) = '1' and enable = '0') then
--        disp_1 <= 0;
--        disp_2 <= 0;
--        disp_3 <= 0;
--        disp_4 <= 0;
--        count_a <= 0;
--        count_b <= 0;
--        count_c <= 0;
--        count_d <= 0;
--    end if;
    
--    if (clock_num1='1' and clock_num1'event) then
--        if (enable = '1') then
--            disp_1 <= count_a;
--            disp_2 <= count_b;
--            disp_3 <= count_c;
--            disp_4 <=count_d;

            
--            count_a <= count_a + 1;
--            if (count_a = 9) then
--                count_a <= 0;
--                count_b <= count_b + 1;
--                if (count_b = 9) then
--                    count_b <= 0;
--                    count_c <= count_c + 1;
--                        if (count_c = 9) then
--                            count_c <= 0;
--                           count_d <=count_d + 1;
--                                if (count_d = 9) then
--                                   count_d <= 0;
--                                end if;
--                        end if;
--                end if;
--            end if;
--        end if;
--    end if;  
--end process;

--process (clock_reset)

--variable digit : unsigned (1 downto 0) := "00";

--begin
--    if (clock_reset='1' and clock_reset'event) then
--        case digit is
--            when "00" =>
--                case (disp_1) is
--                    when 0 =>
--                        anode <= "11111110";
--                        cathode <= "11000000";
--                    when 1 =>
--                        anode <= "11111110";
--                        cathode <= "11111001";
--                    when 2 =>
--                        anode <= "11111110";
--                        cathode <= "10100100";
--                    when 3 =>
--                        anode <= "11111110";
--                        cathode <= "10110000";
--                    when 4 =>
--                        anode <= "11111110";
--                        cathode <= "10011001";
--                    when 5 =>
--                        anode <= "11111110";
--                        cathode <= "10010010";
--                    when 6 =>
--                        anode <= "11111110";
--                        cathode <= "10000010";
--                    when 7 =>
--                        anode <= "11111110";
--                        cathode <= "11111000";
--                    when 8 =>
--                        anode <= "11111110";
--                        cathode <= "10000000";
--                    when 9 =>
--                        anode <= "11111110";
--                        cathode <= "10010000";
--                    when others =>
--                        anode <= "11111110";
--                        cathode <= "11111111";
--                end case;
                
--            when "01" =>
--                case (disp_2) is
--                    when 0 =>
--                        anode <= "11111101";
--                        cathode <= "11000000";
--                    when 1 =>
--                        anode <= "11111101";
--                        cathode <= "11111001";
--                    when 2 =>
--                        anode <= "11111101";
--                        cathode <= "10100100";
--                    when 3 =>
--                        anode <= "11111101";
--                        cathode <= "10110000";
--                    when 4 =>
--                        anode <= "11111101";
--                        cathode <= "10011001";
--                    when 5 =>
--                        anode <= "11111101";
--                        cathode <= "10010010";
--                    when 6 =>
--                        anode <= "11111101";
--                        cathode <= "10000010";
--                    when 7 =>
--                        anode <= "11111101";
--                        cathode <= "11111000";
--                    when 8 =>
--                        anode <= "11111101";
--                        cathode <= "10000000";
--                    when 9 =>
--                        anode <= "11111101";
--                        cathode <= "10010000";
--                    when others =>
--                        anode <= "11111101";
--                        cathode <= "11111111";
--                end case;
                
--            when "10" =>
--                case (disp_3) is
--                    when 0 =>
--                        anode <= "11111011";
--                        cathode <= "01000000";
--                    when 1 =>
--                        anode <= "11111011";
--                        cathode <= "01111001";
--                    when 2 =>
--                        anode <= "11111011";
--                        cathode <= "00100100";
--                    when 3 =>
--                        anode <= "11111011";
--                        cathode <= "00110000";
--                    when 4 =>
--                        anode <= "11111011";
--                        cathode <= "00011001";
--                    when 5 =>
--                        anode <= "11111011";
--                        cathode <= "00010010";
--                    when 6 =>
--                        anode <= "11111011";
--                        cathode <= "00000010";
--                    when 7 =>
--                        anode <= "11111011";
--                        cathode <= "01111000";
--                    when 8 =>
--                        anode <= "11111011";
--                        cathode <= "00000000";
--                    when 9 =>
--                        anode <= "11111011";
--                        cathode <= "00010000";
--                    when others =>
--                        anode <= "11111011";
--                        cathode <= "01111111";
--                end case;
                
--            when "11" =>
--                case (disp_4) is
--                    when 0 =>
--                        anode <= "11110111";
--                        cathode <= "11000000";
--                    when 1 =>
--                        anode <= "11110111";
--                        cathode <= "11111001";
--                    when 2 =>
--                        anode <= "11110111";
--                        cathode <= "10100100";
--                    when 3 =>
--                        anode <= "11110111";
--                        cathode <= "10110000";
--                    when 4 =>
--                        anode <= "11110111";
--                        cathode <= "10011001";
--                    when 5 =>
--                        anode <= "11110111";
--                        cathode <= "10010010";
--                    when 6 =>
--                        anode <= "11110111";
--                        cathode <= "10000010";
--                    when 7 =>
--                        anode <= "11110111";
--                        cathode <= "11111000";
--                    when 8 =>
--                        anode <= "11110111";
--                        cathode <= "10000000";
--                    when 9 =>
--                        anode <= "11110111";
--                        cathode <= "10010000";
--                    when others =>
--                        anode <= "11110111";
--                        cathode <= "11111111";
--                end case;
--        end case;
        
--        digit := digit + 1;
--    end if;
--end process;

--process(count_a)
--begin

--    if (clock_num1='1' and clock_num1'event) then
--        if (switch(0) = '1') then
--            start_button <= 1;
--        elsif (switch(0) = '0') then
--            start_button <= 0;
--        end if;
--        sig1_button <= start_button;
--        if (sig1_button = 0 and start_button = 1) then
--            enable <= not enable;
--            lap_display <= 0;
--        end if;
--    end if;
--end process;

--end Behavioral;
