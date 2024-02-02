	qsys_top_intel_onchip_memory_0 u0 (
		.clk        (_connected_to_clk_),        //   input,   width = 1,   clk1.clk
		.s1_arid    (_connected_to_s1_arid_),    //   input,   width = 2, axi_s1.arid
		.s1_araddr  (_connected_to_s1_araddr_),  //   input,  width = 20,       .araddr
		.s1_arlen   (_connected_to_s1_arlen_),   //   input,   width = 8,       .arlen
		.s1_arsize  (_connected_to_s1_arsize_),  //   input,   width = 3,       .arsize
		.s1_arburst (_connected_to_s1_arburst_), //   input,   width = 2,       .arburst
		.s1_arready (_connected_to_s1_arready_), //  output,   width = 1,       .arready
		.s1_arvalid (_connected_to_s1_arvalid_), //   input,   width = 1,       .arvalid
		.s1_awid    (_connected_to_s1_awid_),    //   input,   width = 2,       .awid
		.s1_awaddr  (_connected_to_s1_awaddr_),  //   input,  width = 20,       .awaddr
		.s1_awlen   (_connected_to_s1_awlen_),   //   input,   width = 8,       .awlen
		.s1_awsize  (_connected_to_s1_awsize_),  //   input,   width = 3,       .awsize
		.s1_awburst (_connected_to_s1_awburst_), //   input,   width = 2,       .awburst
		.s1_awready (_connected_to_s1_awready_), //  output,   width = 1,       .awready
		.s1_awvalid (_connected_to_s1_awvalid_), //   input,   width = 1,       .awvalid
		.s1_rid     (_connected_to_s1_rid_),     //  output,   width = 2,       .rid
		.s1_rdata   (_connected_to_s1_rdata_),   //  output,  width = 32,       .rdata
		.s1_rlast   (_connected_to_s1_rlast_),   //  output,   width = 1,       .rlast
		.s1_rready  (_connected_to_s1_rready_),  //   input,   width = 1,       .rready
		.s1_rvalid  (_connected_to_s1_rvalid_),  //  output,   width = 1,       .rvalid
		.s1_rresp   (_connected_to_s1_rresp_),   //  output,   width = 2,       .rresp
		.s1_wdata   (_connected_to_s1_wdata_),   //   input,  width = 32,       .wdata
		.s1_wstrb   (_connected_to_s1_wstrb_),   //   input,   width = 4,       .wstrb
		.s1_wlast   (_connected_to_s1_wlast_),   //   input,   width = 1,       .wlast
		.s1_wready  (_connected_to_s1_wready_),  //  output,   width = 1,       .wready
		.s1_wvalid  (_connected_to_s1_wvalid_),  //   input,   width = 1,       .wvalid
		.s1_bid     (_connected_to_s1_bid_),     //  output,   width = 2,       .bid
		.s1_bresp   (_connected_to_s1_bresp_),   //  output,   width = 2,       .bresp
		.s1_bready  (_connected_to_s1_bready_),  //   input,   width = 1,       .bready
		.s1_bvalid  (_connected_to_s1_bvalid_),  //  output,   width = 1,       .bvalid
		.reset      (_connected_to_reset_),      //   input,   width = 1, reset1.reset
		.reset_req  (_connected_to_reset_req_)   //   input,   width = 1,       .reset_req
	);

