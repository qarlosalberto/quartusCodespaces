module qsys_top_intel_niosv_m_0 (
		input  wire        clk,                          //                 clk.clk
		input  wire        reset_reset,                  //               reset.reset
		input  wire [15:0] platform_irq_rx_irq,          //     platform_irq_rx.irq
		output wire [31:0] instruction_manager_awaddr,   // instruction_manager.awaddr
		output wire [2:0]  instruction_manager_awprot,   //                    .awprot
		output wire        instruction_manager_awvalid,  //                    .awvalid
		input  wire        instruction_manager_awready,  //                    .awready
		output wire [31:0] instruction_manager_wdata,    //                    .wdata
		output wire [3:0]  instruction_manager_wstrb,    //                    .wstrb
		output wire        instruction_manager_wvalid,   //                    .wvalid
		input  wire        instruction_manager_wready,   //                    .wready
		input  wire [1:0]  instruction_manager_bresp,    //                    .bresp
		input  wire        instruction_manager_bvalid,   //                    .bvalid
		output wire        instruction_manager_bready,   //                    .bready
		output wire [31:0] instruction_manager_araddr,   //                    .araddr
		output wire [2:0]  instruction_manager_arprot,   //                    .arprot
		output wire        instruction_manager_arvalid,  //                    .arvalid
		input  wire        instruction_manager_arready,  //                    .arready
		input  wire [31:0] instruction_manager_rdata,    //                    .rdata
		input  wire [1:0]  instruction_manager_rresp,    //                    .rresp
		input  wire        instruction_manager_rvalid,   //                    .rvalid
		output wire        instruction_manager_rready,   //                    .rready
		output wire [31:0] data_manager_awaddr,          //        data_manager.awaddr
		output wire [2:0]  data_manager_awprot,          //                    .awprot
		output wire        data_manager_awvalid,         //                    .awvalid
		input  wire        data_manager_awready,         //                    .awready
		output wire [31:0] data_manager_wdata,           //                    .wdata
		output wire [3:0]  data_manager_wstrb,           //                    .wstrb
		output wire        data_manager_wvalid,          //                    .wvalid
		input  wire        data_manager_wready,          //                    .wready
		input  wire [1:0]  data_manager_bresp,           //                    .bresp
		input  wire        data_manager_bvalid,          //                    .bvalid
		output wire        data_manager_bready,          //                    .bready
		output wire [31:0] data_manager_araddr,          //                    .araddr
		output wire [2:0]  data_manager_arprot,          //                    .arprot
		output wire        data_manager_arvalid,         //                    .arvalid
		input  wire        data_manager_arready,         //                    .arready
		input  wire [31:0] data_manager_rdata,           //                    .rdata
		input  wire [1:0]  data_manager_rresp,           //                    .rresp
		input  wire        data_manager_rvalid,          //                    .rvalid
		output wire        data_manager_rready,          //                    .rready
		input  wire        timer_sw_agent_write,         //      timer_sw_agent.write
		input  wire [31:0] timer_sw_agent_writedata,     //                    .writedata
		input  wire [3:0]  timer_sw_agent_byteenable,    //                    .byteenable
		input  wire [5:0]  timer_sw_agent_address,       //                    .address
		input  wire        timer_sw_agent_read,          //                    .read
		output wire [31:0] timer_sw_agent_readdata,      //                    .readdata
		output wire        timer_sw_agent_readdatavalid, //                    .readdatavalid
		output wire        timer_sw_agent_waitrequest,   //                    .waitrequest
		input  wire        dm_agent_write,               //            dm_agent.write
		input  wire [31:0] dm_agent_writedata,           //                    .writedata
		input  wire [15:0] dm_agent_address,             //                    .address
		input  wire        dm_agent_read,                //                    .read
		output wire [31:0] dm_agent_readdata,            //                    .readdata
		output wire        dm_agent_readdatavalid,       //                    .readdatavalid
		output wire        dm_agent_waitrequest          //                    .waitrequest
	);
endmodule

