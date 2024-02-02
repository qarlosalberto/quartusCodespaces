// (C) 2001-2023 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


`timescale 1 ps / 1 ps

module  qsys_top_intel_onchip_memory_0_intel_onchip_memory_147_hqcwqki  (
    clk,
    reset,
    reset_req,
    s1_araddr,
    s1_arburst,
    s1_arid,
    s1_arlen,
    s1_arready,
    s1_arsize,
    s1_arvalid,
    s1_awaddr,
    s1_awburst,
    s1_awid,
    s1_awlen,
    s1_awready,
    s1_awsize,
    s1_awvalid,
    s1_bid,
    s1_bready,
    s1_bresp,
    s1_bvalid,
    s1_rdata,
    s1_rid,
    s1_rlast,
    s1_rready,
    s1_rresp,
    s1_rvalid,
    s1_wdata,
    s1_wlast,
    s1_wready,
    s1_wstrb,
    s1_wvalid
    );

    parameter INIT_FILE = "onchip_mem.hex";

    input        	clk;
    input        	reset;
    input        	reset_req;
    input  [19:0]	s1_araddr;
    input  [1:0]	s1_arburst;
    input  [1:0]	s1_arid;
    input  [7:0]	s1_arlen;
    output        	s1_arready;
    input  [2:0]	s1_arsize;
    input        	s1_arvalid;
    input  [19:0]	s1_awaddr;
    input  [1:0]	s1_awburst;
    input  [1:0]	s1_awid;
    input  [7:0]	s1_awlen;
    output        	s1_awready;
    input  [2:0]	s1_awsize;
    input        	s1_awvalid;
    output [1:0]	s1_bid;
    input        	s1_bready;
    output [1:0]	s1_bresp;
    output        	s1_bvalid;
    output [31:0]	s1_rdata;
    output [1:0]	s1_rid;
    output        	s1_rlast;
    input        	s1_rready;
    output [1:0]	s1_rresp;
    output        	s1_rvalid;
    input  [31:0]	s1_wdata;
    input        	s1_wlast;
    output        	s1_wready;
    input  [3:0]	s1_wstrb;
    input        	s1_wvalid;

    wire    [17:0]	s1_ram_rdaddr;
    wire    [17:0]	s1_ram_wraddr;
    wire        	s1_ram_rden;
    wire    [31:0]	s1_ram_rddata;
    wire        	s1_ram_wren;
    wire    [31:0]	s1_ram_wrdata;
    wire    [3:0]	s1_ram_byteen;
    wire        	s1_ram_wlast;
    wire        	clken_int;
    wire        	ram_clocken0;
    wire        	ram_wready;
    wire        	w_bresp_read;
    wire        	ram_rready;



    qsys_top_intel_onchip_memory_0_intel_onchip_memory_147_hqcwqki_axi_bursting_adapter  #(
        .DATA_WIDTH(32),
        .AXI_ID_WIDTH(2)
    ) s1_axi_bursting_adapter (
        .clk                (clk),
        .reset              (reset),
        .araddr             (s1_araddr),
        .arburst            (s1_arburst),
        .arid               (s1_arid),
        .arlen              (s1_arlen),
        .arready            (s1_arready),
        .arsize             (s1_arsize),
        .arvalid            (s1_arvalid),
        .awaddr             (s1_awaddr),
        .awburst            (s1_awburst),
        .awid               (s1_awid),
        .awlen              (s1_awlen),
        .awready            (s1_awready),
        .awsize             (s1_awsize),
        .awvalid            (s1_awvalid),
        .bready             (s1_bready),
        .bid                (s1_bid),
        .bresp              (s1_bresp),
        .bvalid             (s1_bvalid),
        .rdata              (s1_rdata),
        .rid                (s1_rid),
        .rlast              (s1_rlast),
        .rready             (s1_rready),
        .rresp              (s1_rresp),
        .rvalid             (s1_rvalid),
        .wready             (s1_wready),
        .wdata              (s1_wdata),
        .wlast              (s1_wlast),
        .wstrb              (s1_wstrb),
        .wvalid             (s1_wvalid),
        .w_ram_word_wraddr  (s1_ram_wraddr),
        .r_ram_wren         (s1_ram_wren),
        .r_ram_wrdata       (s1_ram_wrdata),
        .r_ram_byteen       (s1_ram_byteen),
        .r_ram_wlast        (s1_ram_wlast),
        .w_ram_wready       (ram_wready),
        .w_bresp_read       (w_bresp_read),
        .w_ram_word_rdaddr  (s1_ram_rdaddr),
        .ram_rden           (s1_ram_rden),
        .w_ram_rddata       (s1_ram_rddata),
        .w_ram_rready       (ram_rready)
    );


    assign ram_wready = 1'b1;
    assign ram_rready = 1'b1;


    assign clken_int = ~reset_req;



    assign ram_clocken0 = clken_int;



    altera_syncram  altera_syncram_component (
                .address_a    	(s1_ram_wraddr),
                .address_b    	(s1_ram_rdaddr),
                .byteena_a    	(s1_ram_byteen),
                .clock0    	(clk),
                .clocken0    	(ram_clocken0),
                .data_a    	(s1_ram_wrdata),
                .q_b    	(s1_ram_rddata),
                .rden_b    	(s1_ram_rden),
                .wren_a    	(s1_ram_wren),
                .aclr0    	(1'b0),
                .aclr1    	(1'b0),
                .address2_a    	(1'b1),
                .address2_b    	(1'b1),
                .addressstall_a    	(1'b0),
                .addressstall_b    	(1'b0),
                .byteena_b    	(1'b1),
                .clock1    	(1'b1),
                .clocken1    	(1'b1),
                .clocken2    	(1'b1),
                .clocken3    	(1'b1),
                .data_b    	({32{1'b1}}),
                .eccencbypass    	(1'b0),
                .eccencparity    	(8'b0),
                .eccstatus    	(),
                .q_a    	(),
                .rden_a    	(1'b1),
                .sclr    	(1'b0),
                .wren_b    	(1'b0)
                );

    defparam
        altera_syncram_component.intended_device_family  	= "Agilex 7",
        altera_syncram_component.lpm_type  	= "altera_syncram",
        altera_syncram_component.operation_mode  	= "DUAL_PORT",
        altera_syncram_component.ram_block_type  	= "AUTO",
        altera_syncram_component.byte_size  	= 8,
        altera_syncram_component.numwords_a  	= 262144,
        altera_syncram_component.numwords_b  	= 262144,
        altera_syncram_component.width_a  	= 32,
        altera_syncram_component.width_b  	= 32,
        altera_syncram_component.widthad_a  	= 18,
        altera_syncram_component.widthad_b  	= 18,
        altera_syncram_component.width_byteena_a  	= 4,
        altera_syncram_component.address_reg_b  	= "CLOCK0",
        altera_syncram_component.rdcontrol_reg_b  	= "CLOCK0",
        altera_syncram_component.outdata_reg_b  	= "UNREGISTERED",
        altera_syncram_component.outdata_aclr_b  	= "NONE",
        altera_syncram_component.outdata_sclr_b  	= "NONE",
        altera_syncram_component.clock_enable_input_a  	= "NORMAL",
        altera_syncram_component.clock_enable_output_a  	= "BYPASS",
        altera_syncram_component.clock_enable_input_b  	= "NORMAL",
        altera_syncram_component.clock_enable_output_b  	= "BYPASS",
        altera_syncram_component.read_during_write_mode_mixed_ports  	= "DONT_CARE",
        altera_syncram_component.init_file  	= INIT_FILE,
        altera_syncram_component.init_file_layout  	= "Port_A";



endmodule
