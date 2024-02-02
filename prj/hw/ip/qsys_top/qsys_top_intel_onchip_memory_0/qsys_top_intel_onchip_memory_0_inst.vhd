	component qsys_top_intel_onchip_memory_0 is
		port (
			clk        : in  std_logic                     := 'X';             -- clk
			s1_arid    : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- arid
			s1_araddr  : in  std_logic_vector(19 downto 0) := (others => 'X'); -- araddr
			s1_arlen   : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- arlen
			s1_arsize  : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- arsize
			s1_arburst : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- arburst
			s1_arready : out std_logic;                                        -- arready
			s1_arvalid : in  std_logic                     := 'X';             -- arvalid
			s1_awid    : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- awid
			s1_awaddr  : in  std_logic_vector(19 downto 0) := (others => 'X'); -- awaddr
			s1_awlen   : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- awlen
			s1_awsize  : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- awsize
			s1_awburst : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- awburst
			s1_awready : out std_logic;                                        -- awready
			s1_awvalid : in  std_logic                     := 'X';             -- awvalid
			s1_rid     : out std_logic_vector(1 downto 0);                     -- rid
			s1_rdata   : out std_logic_vector(31 downto 0);                    -- rdata
			s1_rlast   : out std_logic;                                        -- rlast
			s1_rready  : in  std_logic                     := 'X';             -- rready
			s1_rvalid  : out std_logic;                                        -- rvalid
			s1_rresp   : out std_logic_vector(1 downto 0);                     -- rresp
			s1_wdata   : in  std_logic_vector(31 downto 0) := (others => 'X'); -- wdata
			s1_wstrb   : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- wstrb
			s1_wlast   : in  std_logic                     := 'X';             -- wlast
			s1_wready  : out std_logic;                                        -- wready
			s1_wvalid  : in  std_logic                     := 'X';             -- wvalid
			s1_bid     : out std_logic_vector(1 downto 0);                     -- bid
			s1_bresp   : out std_logic_vector(1 downto 0);                     -- bresp
			s1_bready  : in  std_logic                     := 'X';             -- bready
			s1_bvalid  : out std_logic;                                        -- bvalid
			reset      : in  std_logic                     := 'X';             -- reset
			reset_req  : in  std_logic                     := 'X'              -- reset_req
		);
	end component qsys_top_intel_onchip_memory_0;

	u0 : component qsys_top_intel_onchip_memory_0
		port map (
			clk        => CONNECTED_TO_clk,        --   clk1.clk
			s1_arid    => CONNECTED_TO_s1_arid,    -- axi_s1.arid
			s1_araddr  => CONNECTED_TO_s1_araddr,  --       .araddr
			s1_arlen   => CONNECTED_TO_s1_arlen,   --       .arlen
			s1_arsize  => CONNECTED_TO_s1_arsize,  --       .arsize
			s1_arburst => CONNECTED_TO_s1_arburst, --       .arburst
			s1_arready => CONNECTED_TO_s1_arready, --       .arready
			s1_arvalid => CONNECTED_TO_s1_arvalid, --       .arvalid
			s1_awid    => CONNECTED_TO_s1_awid,    --       .awid
			s1_awaddr  => CONNECTED_TO_s1_awaddr,  --       .awaddr
			s1_awlen   => CONNECTED_TO_s1_awlen,   --       .awlen
			s1_awsize  => CONNECTED_TO_s1_awsize,  --       .awsize
			s1_awburst => CONNECTED_TO_s1_awburst, --       .awburst
			s1_awready => CONNECTED_TO_s1_awready, --       .awready
			s1_awvalid => CONNECTED_TO_s1_awvalid, --       .awvalid
			s1_rid     => CONNECTED_TO_s1_rid,     --       .rid
			s1_rdata   => CONNECTED_TO_s1_rdata,   --       .rdata
			s1_rlast   => CONNECTED_TO_s1_rlast,   --       .rlast
			s1_rready  => CONNECTED_TO_s1_rready,  --       .rready
			s1_rvalid  => CONNECTED_TO_s1_rvalid,  --       .rvalid
			s1_rresp   => CONNECTED_TO_s1_rresp,   --       .rresp
			s1_wdata   => CONNECTED_TO_s1_wdata,   --       .wdata
			s1_wstrb   => CONNECTED_TO_s1_wstrb,   --       .wstrb
			s1_wlast   => CONNECTED_TO_s1_wlast,   --       .wlast
			s1_wready  => CONNECTED_TO_s1_wready,  --       .wready
			s1_wvalid  => CONNECTED_TO_s1_wvalid,  --       .wvalid
			s1_bid     => CONNECTED_TO_s1_bid,     --       .bid
			s1_bresp   => CONNECTED_TO_s1_bresp,   --       .bresp
			s1_bready  => CONNECTED_TO_s1_bready,  --       .bready
			s1_bvalid  => CONNECTED_TO_s1_bvalid,  --       .bvalid
			reset      => CONNECTED_TO_reset,      -- reset1.reset
			reset_req  => CONNECTED_TO_reset_req   --       .reset_req
		);

