// qsys_top_intel_onchip_memory_0.v

// Generated using ACDS version 23.4 66

`timescale 1 ps / 1 ps
module qsys_top_intel_onchip_memory_0 (
		input  wire        clk,        //   clk1.clk
		input  wire [1:0]  s1_arid,    // axi_s1.arid
		input  wire [19:0] s1_araddr,  //       .araddr
		input  wire [7:0]  s1_arlen,   //       .arlen
		input  wire [2:0]  s1_arsize,  //       .arsize
		input  wire [1:0]  s1_arburst, //       .arburst
		output wire        s1_arready, //       .arready
		input  wire        s1_arvalid, //       .arvalid
		input  wire [1:0]  s1_awid,    //       .awid
		input  wire [19:0] s1_awaddr,  //       .awaddr
		input  wire [7:0]  s1_awlen,   //       .awlen
		input  wire [2:0]  s1_awsize,  //       .awsize
		input  wire [1:0]  s1_awburst, //       .awburst
		output wire        s1_awready, //       .awready
		input  wire        s1_awvalid, //       .awvalid
		output wire [1:0]  s1_rid,     //       .rid
		output wire [31:0] s1_rdata,   //       .rdata
		output wire        s1_rlast,   //       .rlast
		input  wire        s1_rready,  //       .rready
		output wire        s1_rvalid,  //       .rvalid
		output wire [1:0]  s1_rresp,   //       .rresp
		input  wire [31:0] s1_wdata,   //       .wdata
		input  wire [3:0]  s1_wstrb,   //       .wstrb
		input  wire        s1_wlast,   //       .wlast
		output wire        s1_wready,  //       .wready
		input  wire        s1_wvalid,  //       .wvalid
		output wire [1:0]  s1_bid,     //       .bid
		output wire [1:0]  s1_bresp,   //       .bresp
		input  wire        s1_bready,  //       .bready
		output wire        s1_bvalid,  //       .bvalid
		input  wire        reset,      // reset1.reset
		input  wire        reset_req   //       .reset_req
	);

	qsys_top_intel_onchip_memory_0_intel_onchip_memory_147_hqcwqki #(
		.INIT_FILE ("onchip_mem.hex")
	) intel_onchip_memory_0 (
		.clk        (clk),        //   input,   width = 1,   clk1.clk
		.s1_arid    (s1_arid),    //   input,   width = 2, axi_s1.arid
		.s1_araddr  (s1_araddr),  //   input,  width = 20,       .araddr
		.s1_arlen   (s1_arlen),   //   input,   width = 8,       .arlen
		.s1_arsize  (s1_arsize),  //   input,   width = 3,       .arsize
		.s1_arburst (s1_arburst), //   input,   width = 2,       .arburst
		.s1_arready (s1_arready), //  output,   width = 1,       .arready
		.s1_arvalid (s1_arvalid), //   input,   width = 1,       .arvalid
		.s1_awid    (s1_awid),    //   input,   width = 2,       .awid
		.s1_awaddr  (s1_awaddr),  //   input,  width = 20,       .awaddr
		.s1_awlen   (s1_awlen),   //   input,   width = 8,       .awlen
		.s1_awsize  (s1_awsize),  //   input,   width = 3,       .awsize
		.s1_awburst (s1_awburst), //   input,   width = 2,       .awburst
		.s1_awready (s1_awready), //  output,   width = 1,       .awready
		.s1_awvalid (s1_awvalid), //   input,   width = 1,       .awvalid
		.s1_rid     (s1_rid),     //  output,   width = 2,       .rid
		.s1_rdata   (s1_rdata),   //  output,  width = 32,       .rdata
		.s1_rlast   (s1_rlast),   //  output,   width = 1,       .rlast
		.s1_rready  (s1_rready),  //   input,   width = 1,       .rready
		.s1_rvalid  (s1_rvalid),  //  output,   width = 1,       .rvalid
		.s1_rresp   (s1_rresp),   //  output,   width = 2,       .rresp
		.s1_wdata   (s1_wdata),   //   input,  width = 32,       .wdata
		.s1_wstrb   (s1_wstrb),   //   input,   width = 4,       .wstrb
		.s1_wlast   (s1_wlast),   //   input,   width = 1,       .wlast
		.s1_wready  (s1_wready),  //  output,   width = 1,       .wready
		.s1_wvalid  (s1_wvalid),  //   input,   width = 1,       .wvalid
		.s1_bid     (s1_bid),     //  output,   width = 2,       .bid
		.s1_bresp   (s1_bresp),   //  output,   width = 2,       .bresp
		.s1_bready  (s1_bready),  //   input,   width = 1,       .bready
		.s1_bvalid  (s1_bvalid),  //  output,   width = 1,       .bvalid
		.reset      (reset),      //   input,   width = 1, reset1.reset
		.reset_req  (reset_req)   //   input,   width = 1,       .reset_req
	);

endmodule