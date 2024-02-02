	component qsys_top_inst_clk_bfm_ip is
		generic (
			CLOCK_RATE : positive := 50000000;
			CLOCK_UNIT : positive := 1
		);
		port (
			clk : out std_logic   -- clk
		);
	end component qsys_top_inst_clk_bfm_ip;

	u0 : component qsys_top_inst_clk_bfm_ip
		generic map (
			CLOCK_RATE => POSITIVE_VALUE_FOR_CLOCK_RATE,
			CLOCK_UNIT => POSITIVE_VALUE_FOR_CLOCK_UNIT
		)
		port map (
			clk => CONNECTED_TO_clk  -- clk.clk
		);

