------------------------------------------------------------------
-- Name		   : tb_ser2par.vhd
-- Description : Testbench for ser2par.vhd
-- Designed by : Claudio Avi Chami - FPGA Site
-- Date        : 26/03/2016
-- Version     : 01
-- Remarks     : This testbench uses the par2ser to test the ser2par
------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
	use ieee.numeric_std.ALL;
    
entity tb_ser2par is
end entity;

architecture test of tb_ser2par is

    constant PERIOD  : time   := 20 ns;
    constant DATA_W  : natural := 4;
	
    signal clk       : std_logic := '0';
    signal rst       : std_logic := '1';
    signal load      : std_logic := '0';
    signal busy      : std_logic ;
    signal ser_data  : std_logic ;
    signal rd		 : std_logic ;
    signal data_rdy  : std_logic ;
    signal frame     : std_logic ;
    signal data_in   : std_logic_vector (3 downto 0);
    signal endSim	 : boolean   := false;

    component par2ser  is
	generic (
		DATA_W		: natural := 8
	);
	port (
		clk: 		in std_logic;
		rst: 		in std_logic;
		
		-- inputs
		data_in:	in std_logic_vector (DATA_W-1 downto 0);
		load: 		in std_logic;
		
		-- outputs
		data_out: 	out std_logic;
		busy:		out std_logic;
		frame:		out std_logic
	);
    end component;

    component ser2par  is
	generic (
		DATA_W		: natural := 8
	);
	port (
		clk: 		in std_logic;
		rst: 		in std_logic;

		-- inputs
		data_in: 	in std_logic;
		frame_in:	in std_logic;
		rd:			in std_logic;
		-- outputs
		data_out:	out std_logic_vector (DATA_W-1 downto 0);
		data_rdy: 	out std_logic

	);
    end component;
    

begin
    clk     <= not clk after PERIOD/2;
    rst     <= '0' after  PERIOD*10;

	-- Main simulation process
	process 
	begin
	
		wait until (rst = '0');
		wait until (rising_edge(clk));

		rd		<= '0';
		data_in <= x"a";
		load	<= '1';
		wait until (rising_edge(clk));
		load	<= '0';
		wait until (data_rdy = '1');
		wait until (rising_edge(clk));
		rd <= '1';
		wait until (rising_edge(clk));
		rd <= '0';

		data_in <= x"9";
		load	<= '1';
		wait until (rising_edge(clk));
		load	<= '0';
		wait until (data_rdy = '1');
		wait until (rising_edge(clk));
		rd <= '1';
		wait until (rising_edge(clk));
		rd <= '0';

		data_in <= x"c";
		load	<= '1';
		wait until (rising_edge(clk));
		load	<= '0';
		wait until (data_rdy = '1');
		wait until (rising_edge(clk));
		rd <= '1';
		wait until (rising_edge(clk));
		rd <= '0';
		wait until (rising_edge(clk));
		endSim  <= true;

	end	process;	
		
	-- End the simulation
	process 
	begin
		if (endSim) then
			assert false 
				report "End of simulation." 
				severity failure; 
		end if;
		wait until (rising_edge(clk));
	end process;	

    par2ser_inst : par2ser
    generic map (
		DATA_W	 => DATA_W
	)
    port map (
        clk      => clk,
        rst	     => rst,
		
        data_in  => data_in,
        load     => load,
		
        data_out => ser_data,
        busy     => busy,
		frame	 => frame
    );

    ser2par_inst : ser2par
    generic map (
		DATA_W	 => DATA_W
	)
    port map (
        clk      => clk,
        rst	     => rst,
		
        data_in  => ser_data,
        frame_in => frame,
        rd		 => rd,
		
        data_out => open,
        data_rdy => data_rdy
    );
	
	

end architecture;