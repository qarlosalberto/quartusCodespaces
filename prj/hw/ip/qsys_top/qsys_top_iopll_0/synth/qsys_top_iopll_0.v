// qsys_top_iopll_0.v

// Generated using ACDS version 23.4 66

`timescale 1 ps / 1 ps
module qsys_top_iopll_0 (
		input  wire  refclk,   //  refclk.clk
		output wire  locked,   //  locked.export
		input  wire  rst,      //   reset.reset
		output wire  outclk_0  // outclk0.clk
	);

	qsys_top_iopll_0_altera_iopll_1931_nie5y4y iopll_0 (
		.refclk   (refclk),   //   input,  width = 1,  refclk.clk
		.locked   (locked),   //  output,  width = 1,  locked.export
		.rst      (rst),      //   input,  width = 1,   reset.reset
		.outclk_0 (outclk_0)  //  output,  width = 1, outclk0.clk
	);

endmodule
