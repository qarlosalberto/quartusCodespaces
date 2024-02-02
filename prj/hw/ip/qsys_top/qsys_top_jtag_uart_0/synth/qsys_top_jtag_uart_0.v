// qsys_top_jtag_uart_0.v

// Generated using ACDS version 23.4 66

`timescale 1 ps / 1 ps
module qsys_top_jtag_uart_0 (
		input  wire        clk,            //               clk.clk
		input  wire        rst_n,          //             reset.reset_n
		input  wire        av_chipselect,  // avalon_jtag_slave.chipselect
		input  wire        av_address,     //                  .address
		input  wire        av_read_n,      //                  .read_n
		output wire [31:0] av_readdata,    //                  .readdata
		input  wire        av_write_n,     //                  .write_n
		input  wire [31:0] av_writedata,   //                  .writedata
		output wire        av_waitrequest, //                  .waitrequest
		output wire        av_irq          //               irq.irq
	);

	qsys_top_jtag_uart_0_altera_avalon_jtag_uart_1924_2abh6yy jtag_uart_0 (
		.clk            (clk),            //   input,   width = 1,               clk.clk
		.rst_n          (rst_n),          //   input,   width = 1,             reset.reset_n
		.av_chipselect  (av_chipselect),  //   input,   width = 1, avalon_jtag_slave.chipselect
		.av_address     (av_address),     //   input,   width = 1,                  .address
		.av_read_n      (av_read_n),      //   input,   width = 1,                  .read_n
		.av_readdata    (av_readdata),    //  output,  width = 32,                  .readdata
		.av_write_n     (av_write_n),     //   input,   width = 1,                  .write_n
		.av_writedata   (av_writedata),   //   input,  width = 32,                  .writedata
		.av_waitrequest (av_waitrequest), //  output,   width = 1,                  .waitrequest
		.av_irq         (av_irq)          //  output,   width = 1,               irq.irq
	);

endmodule
