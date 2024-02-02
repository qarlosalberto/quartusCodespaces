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

module  qsys_top_intel_onchip_memory_0_intel_onchip_memory_147_hqcwqki_axi_bursting_adapter  #(
    parameter  DATA_WIDTH       = 32,
    parameter  AXI_ID_WIDTH     = 1,
    localparam BYTE_WIDTH       = DATA_WIDTH/8,
    localparam ADDR_LSB         = log2(BYTE_WIDTH),
    localparam ADDR_MSB         = 19 - ADDR_LSB
)(
    input                               clk,
    input                               reset,
    input        [19:0]           	araddr,
    input        [1:0]                  arburst,
    input        [AXI_ID_WIDTH-1:0]     arid,
    input        [7:0]                  arlen,
    output logic                        arready,
    input        [2:0]                  arsize,
    input                               arvalid,

    input        [19:0]           	awaddr,
    input        [1:0]                  awburst,
    input        [AXI_ID_WIDTH-1:0]     awid,
    input        [7:0]                  awlen,
    output logic                        awready,
    input        [2:0]                  awsize,
    input                               awvalid,

    output logic [AXI_ID_WIDTH-1:0]     bid,
    input                               bready,
    output logic [1:0]                  bresp,
    output logic                        bvalid,

    output logic [DATA_WIDTH-1:0]       rdata,
    output logic [AXI_ID_WIDTH-1:0]     rid,
    output logic                        rlast,
    input                               rready,
    output logic [1:0]                  rresp,
    output logic                        rvalid,
    input        [DATA_WIDTH-1:0]       wdata,
    input                               wlast,
    output logic                        wready,
    input        [BYTE_WIDTH-1:0]       wstrb,
    input                               wvalid,

// altera_syncram (word-addressing)
    output logic [ADDR_MSB:0]           w_ram_word_wraddr,
    output logic                        r_ram_wren,
    output logic [DATA_WIDTH-1:0]       r_ram_wrdata,
    output logic [BYTE_WIDTH-1:0]       r_ram_byteen,
    output logic                        r_ram_wlast,
    output logic [ADDR_MSB:0]           w_ram_word_rdaddr,
    output logic                        ram_rden,
    input        [DATA_WIDTH-1:0]       w_ram_rddata,

    output logic                        w_bresp_read,
    input                               w_ram_wready,
    input                               w_ram_rready
);

logic r_wraddr_preset, w_wraddr_write, r_wraddr_write, r_ram_wraddr_ld, r_wrtrans_busy, w_wrtrans_done, w_wrdata_lat;
logic [19:0] r_ram_wraddr, r_wraddr_lat, w_wraplow_wraddr, r_wraplow_wraddr_lat, r_wraplow_wraddr_lat2;
logic [19:0] w_wrapup_wraddr, r_wrapup_wraddr_lat, r_wrapup_wraddr_lat2;
logic [AXI_ID_WIDTH-1:0] r_bid_lat, r_bid_lat2, r_bid_lat3, r_bid_lat4;
logic [11:0] w_awcontainer_size;
logic [7:0]  w_awburstsize, r_awburstsize_lat, r_incr_wraddr;
logic [2:0]  r_awid_queue, w_awlen_encode;
logic [1:0]  r_awbursttype_lat, r_awbursttype_lat2, r_bresp_queue, r_bresp_lat, r_bresp_lat2, r_bresp_lat3, r_bresp_lat4, pre_bresp;

logic r_rdaddr_preset, w_rdaddr_write, r_rdaddr_reset, w_ram_rdaddr_ld, ram_rdaddr_ld_nxt, ram_rdaddr_ld_nxt2;
logic r_rdaddr_busy, w_rdaddr_done, r_rdtrans_busy, w_rdtrans_done;
logic w_rdtrans_valid, w_rden, w_ram_rden, rddata_valid_nxt, rddata_valid_nxt2, rddata_valid_nxt3;
logic [19:0] r_rdaddr_count, w_current_rdaddr, w_ram_rdaddr, r_ram_rdaddr, r_rdaddr_lat;
logic [19:0] w_wraplow_rdaddr, r_wraplow_rdaddr_lat, r_wraplow_rdaddr_lat2, w_current_wraplow_rdaddr;
logic [19:0] w_wrapup_rdaddr, r_wrapup_rdaddr_lat, r_wrapup_rdaddr_lat2, w_current_wrapup_rdaddr;
logic [DATA_WIDTH-1:0]   r_ram_rddata, r_lvl1_rddata, r_lvl2_rddata, pre_rdata;
logic [AXI_ID_WIDTH-1:0] r_rid_lat, r_rid_lat2, r_rid_lat3, pre_rid;
logic [11:0] w_arcontainer_size;
logic [7:0]  w_arburstsize, r_arburstsize_lat, r_incr_rdaddr;
logic [7:0]  w_current_arburstlen, r_arburstlen_lat, r_arburstlen_lat2, r_arburstlen_lat3, rdtrans_count, rden_count;
logic [7:0]  pre_rlen, r_rlen_lat, r_rlen_lat2, r_rlen_lat3;
logic [2:0]  w_arlen_encode;
logic [1:0]  r_arbursttype_lat, r_arbursttype_lat2, w_current_arbursttype, r_rresp_lat, r_rresp_lat2, r_rresp_lat3, pre_rresp, ecc_rresp;
logic [1:0] r_rid_queue, rdata_queue;
logic count_preset;


// Ceiling of log2(N) function
function integer log2;
    input integer x;
    begin
        x = x-1;
        for(log2=0; x>0; log2=log2+1)
            x = x>>1;
    end
endfunction


// Burst size encoding
always_comb
    case (awsize)
        3'b000: w_awburstsize = 8'd1;
        3'b001: w_awburstsize = 8'd2;
        3'b010: w_awburstsize = 8'd4;
        3'b011: w_awburstsize = 8'd8;
        3'b100: w_awburstsize = 8'd16;
        3'b101: w_awburstsize = 8'd32;
        3'b110: w_awburstsize = 8'd64;
        3'b111: w_awburstsize = 8'd128;
       default: w_awburstsize = 8'd0;
    endcase

always_comb
    case (arsize)
        3'b000: w_arburstsize = 8'd1;
        3'b001: w_arburstsize = 8'd2;
        3'b010: w_arburstsize = 8'd4;
        3'b011: w_arburstsize = 8'd8;
        3'b100: w_arburstsize = 8'd16;
        3'b101: w_arburstsize = 8'd32;
        3'b110: w_arburstsize = 8'd64;
        3'b111: w_arburstsize = 8'd128;
       default: w_arburstsize = 8'd0;
    endcase

// WRAP
always_comb
    case (awlen)
        8'd1 : w_awlen_encode = 3'b001;
        8'd3 : w_awlen_encode = 3'b010;
        8'd7 : w_awlen_encode = 3'b011;
        8'd15: w_awlen_encode = 3'b100;
      default: w_awlen_encode = 3'b000;
    endcase

always_comb
    case (arlen)
        8'd1 : w_arlen_encode = 3'b001;
        8'd3 : w_arlen_encode = 3'b010;
        8'd7 : w_arlen_encode = 3'b011;
        8'd15: w_arlen_encode = 3'b100;
      default: w_arlen_encode = 3'b000;
    endcase

// Container size = (Burst size * Burst length)
always_comb
    case (awsize + w_awlen_encode)
        4'b0001: w_awcontainer_size = 12'd1;
        4'b0010: w_awcontainer_size = 12'd3;
        4'b0011: w_awcontainer_size = 12'd7;
        4'b0100: w_awcontainer_size = 12'd15;
        4'b0101: w_awcontainer_size = 12'd31;
        4'b0110: w_awcontainer_size = 12'd63;
        4'b0111: w_awcontainer_size = 12'd127;
        4'b1000: w_awcontainer_size = 12'd255;
        4'b1001: w_awcontainer_size = 12'd511;
        4'b1010: w_awcontainer_size = 12'd1023;
        4'b1011: w_awcontainer_size = 12'd2047;
        default: w_awcontainer_size = 12'd0;
    endcase

always_comb
    case (arsize + w_arlen_encode)
        4'b0001: w_arcontainer_size = 12'd1;
        4'b0010: w_arcontainer_size = 12'd3;
        4'b0011: w_arcontainer_size = 12'd7;
        4'b0100: w_arcontainer_size = 12'd15;
        4'b0101: w_arcontainer_size = 12'd31;
        4'b0110: w_arcontainer_size = 12'd63;
        4'b0111: w_arcontainer_size = 12'd127;
        4'b1000: w_arcontainer_size = 12'd255;
        4'b1001: w_arcontainer_size = 12'd511;
        4'b1010: w_arcontainer_size = 12'd1023;
        4'b1011: w_arcontainer_size = 12'd2047;
        default: w_arcontainer_size = 12'd0;
    endcase

assign w_wraplow_wraddr = awaddr & ~(w_awcontainer_size);
assign w_wrapup_wraddr  = w_wraplow_wraddr + w_awcontainer_size - w_awburstsize;

assign w_wraplow_rdaddr = araddr & ~(w_arcontainer_size);
assign w_wrapup_rdaddr  = w_wraplow_rdaddr + w_arcontainer_size - w_arburstsize;

//-----------------Write address------------------------------------------------------------------------------
// AXI output: awready
assign awready = ~r_wraddr_preset;

// write addr preset
always @(posedge clk) begin
    if (reset)
        r_wraddr_preset <= 1'b0;
    else if (w_wraddr_write)        // consumed AXI write addr, de-assert awready
        r_wraddr_preset <= 1'b1;
    else if (r_ram_wraddr_ld)       // load write addr to RAM, re-assert awready
        r_wraddr_preset <= 1'b0;
end

// AXI write addr is consumed
assign w_wraddr_write = awvalid & awready;

// write addr latency - 1st level pipeline
always @(posedge clk) begin
    if (reset) begin
        r_wraddr_lat            <=  'h0;
        r_awburstsize_lat       <= 8'h0;
        r_awbursttype_lat       <= 2'h0;
        r_wraplow_wraddr_lat    <=  'h0;
        r_wrapup_wraddr_lat     <=  'h0;
    end
    else if (w_wraddr_write) begin
        r_wraddr_lat            <= awaddr;
        r_awburstsize_lat       <= w_awburstsize;
        r_awbursttype_lat       <= awburst;
        r_wraplow_wraddr_lat    <= w_wraplow_wraddr;
        r_wrapup_wraddr_lat     <= w_wrapup_wraddr;
    end
end

// load write addr to RAM wraddr
always @(posedge clk) begin
    if (reset)
        r_ram_wraddr_ld <= 1'b0;
    else if ( (r_wrtrans_busy==0 && w_wraddr_write) ||
              (w_wrtrans_done && (w_wraddr_write || (r_wraddr_preset && r_ram_wraddr_ld==0) )) )
        r_ram_wraddr_ld <= 1'b1;
    else
        r_ram_wraddr_ld <= 1'b0;
end

// output to RAM: wraddr (word addressing)
assign w_ram_word_wraddr = r_ram_wraddr[19:ADDR_LSB];

// write addr latency - 2nd level pipeline
always @(posedge clk) begin
    if (reset) begin
        r_ram_wraddr            <=  'h0;
        r_incr_wraddr           <=  'h0;
        r_awbursttype_lat2      <= 2'h0;
        r_wraplow_wraddr_lat2   <=  'h0;
        r_wrapup_wraddr_lat2    <=  'h0;
    end
    else if (r_ram_wraddr_ld) begin                     // load start addr
        r_ram_wraddr            <= r_wraddr_lat;
        r_incr_wraddr           <= r_awburstsize_lat;
        r_awbursttype_lat2      <= r_awbursttype_lat;
        r_wraplow_wraddr_lat2   <= r_wraplow_wraddr_lat;
        r_wrapup_wraddr_lat2    <= r_wrapup_wraddr_lat;
    end
    else if (r_ram_wren) begin                          // load next addr
        if ((r_awbursttype_lat2 == 2'b10) && (r_ram_wraddr > r_wrapup_wraddr_lat2))   // WRAP
            r_ram_wraddr <= r_wraplow_wraddr_lat2;
        else
            r_ram_wraddr <= r_ram_wraddr + r_incr_wraddr;                             // INCR
    end
end

//----------------Write data--------------------------------------------------------------------------------
// AXI write data is consumed
assign w_wrdata_lat = wvalid & wready;

// output to RAM: wren
always @(posedge clk) begin
    if (reset)
        r_ram_wren  <= 1'b0;
    else
        r_ram_wren  <= w_wrdata_lat;
end

// output to RAM: write data and byteenable
always @(posedge clk) begin
    if (reset) begin
        r_ram_wrdata <= 'h0;
        r_ram_byteen <= 'b0;
        r_ram_wlast  <= 1'b0;
    end
    else if (w_wrdata_lat) begin
        r_ram_wrdata <= wdata;
        r_ram_byteen <= wstrb;
        r_ram_wlast  <= wlast;
    end
end

// AXI output: wready
always @(posedge clk) begin
    if (reset)
            wready <= 1'b0;
    else if (wready == 0) begin
        if ( ((w_wraddr_write && r_bresp_queue<2) ||
              (w_bresp_read && r_wrtrans_busy)    ||
              (r_wrtrans_busy && r_bresp_queue<2))
             && w_ram_wready )
            wready <= 1'b1;
    end
    else begin
        if ((w_wrtrans_done &&
             ( (r_bresp_queue>0  && w_bresp_read==0 && (w_wraddr_write || (r_wraddr_preset && r_ram_wraddr_ld==0))) ||
               ((r_wraddr_preset==0 && w_wraddr_write==0) || r_ram_wraddr_ld) ))
            || w_ram_wready==0 )
            wready <= 1'b0;
    end
end

always @(posedge clk) begin
    if (reset)
        r_wrtrans_busy <= 1'b0;
    else if ( (r_wrtrans_busy==0 && w_wraddr_write) || (r_wrtrans_busy==0 && r_wraddr_preset) )
        r_wrtrans_busy <= 1'b1;
    else if ( w_wrtrans_done && (w_wraddr_write==0 && (r_wraddr_preset==0 || r_ram_wraddr_ld)) )
        r_wrtrans_busy <= 1'b0;
end

assign w_wrtrans_done = wlast & wready & wvalid;

//-----------------Write Response-----------------------------------------------------------------------------
// AXI Write response is consumed
assign w_bresp_read = bready & bvalid;

// AXI output: bvalid
always @(posedge clk) begin
    if (reset)
        bvalid <= 1'b0;
    else if (w_wrtrans_done)
        bvalid <= 1'b1;
    else if (w_wrtrans_done==0 && w_bresp_read && r_bresp_queue==1)
        bvalid <= 1'b0;
end

// AXI output: bresp
assign bresp = pre_bresp;

// bresp - 1st level pipeline
always @(posedge clk) begin
    if (reset)
        r_bresp_lat  <= 2'b00;
     else if (w_wraddr_write) begin
        if ((w_awburstsize > BYTE_WIDTH) || (awburst == 0 || awburst == 3))                        	// Not support burst size larger than data width
        r_bresp_lat  <= 2'b10;                                                                     	// Not supported burst type (FIXED and reserved)
        else if (awburst == 2 && !((awlen == 1 )||(awlen == 3 )||(awlen == 7 )||(awlen == 15 )) )  	// Not supported burst length for WRAP
        r_bresp_lat  <= 2'b10;
        else
        r_bresp_lat  <= 2'b00;
    end
end

// bid - 1st level pipeline
always @(posedge clk) begin
    if (reset)
        r_bid_lat  <= 'b0;
     else if (w_wraddr_write)
        r_bid_lat  <= awid;
end

always @(posedge clk) begin
    if (reset) begin
        r_bresp_lat2    <= 2'b00;
        r_bresp_lat3    <= 2'b00;
        r_bresp_lat4    <= 2'b00;
        r_bid_lat2      <=  'd0;
        r_bid_lat3      <=  'd0;
        r_bid_lat4      <=  'd0;
    end
    else if (w_wraddr_write) begin
        r_bresp_lat2    <= r_bresp_lat;
        r_bresp_lat3    <= r_bresp_lat2;
        r_bresp_lat4    <= r_bresp_lat3;
        r_bid_lat2      <= r_bid_lat;
        r_bid_lat3      <= r_bid_lat2;
        r_bid_lat4      <= r_bid_lat3;
    end
end

// First Write event during idle.
always @(posedge clk) begin
    if (reset) begin
        r_wraddr_write <= 1'b0;
    end else begin
        r_wraddr_write <= w_wraddr_write;
    end
end

// AXI output: bid
always @(posedge clk) begin
    if (reset) begin
    pre_bresp   <= 2'b00;
        bid     <=  'b0;
    end else if (w_bresp_read) begin
        case (r_awid_queue)
            3'b010 : begin
                    pre_bresp   <= r_bresp_lat;
                        bid     <= r_bid_lat;
                    end
            3'b011 : begin
                    pre_bresp   <= r_bresp_lat2;
                        bid     <= r_bid_lat2;
                    end
            3'b100 : begin
                    pre_bresp   <= r_bresp_lat3;
                        bid     <= r_bid_lat3;
                    end
            default: begin
                    pre_bresp   <= 2'b11;
                        bid     <= {AXI_ID_WIDTH{1'b1}};
                      end
        endcase
    end else if (r_wraddr_write) begin
        case (r_awid_queue)
            3'b001 : begin
                    pre_bresp   <= r_bresp_lat;
                        bid     <= r_bid_lat;
                    end
            3'b010 : begin
                    pre_bresp   <= r_bresp_lat2;
                        bid     <= r_bid_lat2;
                    end
            3'b011 : begin
                    pre_bresp   <= r_bresp_lat3;
                        bid     <= r_bid_lat3;
                    end
            3'b100 : begin
                    pre_bresp   <= r_bresp_lat4;
                        bid     <= r_bid_lat4;
                    end
            default : begin
                    pre_bresp   <= 2'b11;
                        bid     <= {AXI_ID_WIDTH{1'b1}};
                      end
        endcase
    end
end

// Outstanding bresp count
always @(posedge clk) begin
    if (reset)
        r_bresp_queue <= 2'b00;
    else if (w_wrtrans_done && w_bresp_read)
        r_bresp_queue <= r_bresp_queue;
    else if (w_wrtrans_done)
        r_bresp_queue <= r_bresp_queue + 2'b01;
    else if (w_bresp_read)
        r_bresp_queue <= r_bresp_queue - 2'b01;
end

// Outstanding AWID to be clear count
always @(posedge clk) begin
    if (reset)
        r_awid_queue <= 3'b00;
    else if (w_wraddr_write && w_bresp_read)
        r_awid_queue <= r_awid_queue;
    else if (w_wraddr_write)
        r_awid_queue <= r_awid_queue + 3'b01;
    else if (w_bresp_read)
        r_awid_queue <= r_awid_queue - 3'b01;
end


//----------------Read Address---------------------------------------------------------------------------------------
// output: AXI arready
assign arready = w_ram_rready & ~r_rdaddr_preset;

// read addr preset
always @(posedge clk) begin
    if (reset)
        r_rdaddr_preset <= 1'b0;
    else if (w_rdaddr_write)                    // consumed AXI read addr, de-assert arready
        r_rdaddr_preset <= 1'b1;
    else if (w_ram_rdaddr_ld || r_rdaddr_reset) // re-assert arready
        r_rdaddr_preset <= 1'b0;
end

always @(posedge clk) begin
    if (reset)
        r_rdaddr_reset <= 1'b0;
    else if (w_rdaddr_write && w_ram_rdaddr_ld)
        r_rdaddr_reset <= 1'b1;
    else
        r_rdaddr_reset <= 1'b0;
end

// AXI read addr is consumed
assign w_rdaddr_write = arvalid & arready;

// read addr latency - 1st level pipeline
always @(posedge clk) begin
    if (reset) begin
        r_rdaddr_lat            <=  'h0;
        r_arburstsize_lat       <= 8'd0;
        r_arburstlen_lat        <= 8'h0;
        r_arbursttype_lat       <= 2'b00;
        r_wraplow_rdaddr_lat    <=  'h0;
        r_wrapup_rdaddr_lat     <=  'h0;

    end
    else if (w_rdaddr_write) begin
        r_rdaddr_lat            <= araddr;
        r_arburstsize_lat       <= w_arburstsize;
        r_arburstlen_lat        <= arlen;
        r_arbursttype_lat       <= arburst;
        r_wraplow_rdaddr_lat    <= w_wraplow_rdaddr;
        r_wrapup_rdaddr_lat     <= w_wrapup_rdaddr;
    end
end

// load read addr to RAM rdaddr
assign w_ram_rdaddr_ld = (~r_rdaddr_busy & w_rdaddr_write) | (w_rdaddr_done & (w_rdaddr_write | (r_rdaddr_preset & ~r_rdaddr_reset)) );

// output to RAM: rdaddr (word-addressing)
assign w_ram_word_rdaddr = w_ram_rdaddr[19:ADDR_LSB];

// RAM rdaddr - no latency
assign w_ram_rdaddr = (w_rdaddr_write && (r_rdaddr_busy==0 || w_rdaddr_done))? araddr : (w_ram_rdaddr_ld ? r_rdaddr_lat : r_rdaddr_count);


// next RAM rdaddr
always @(posedge clk) begin
    if (reset)
        r_rdaddr_count <= 'h0;
    else if (w_ram_rden && ((w_current_arbursttype == 2'b10) && (w_current_rdaddr > w_current_wrapup_rdaddr))) // check WRAP
        r_rdaddr_count <= w_current_wraplow_rdaddr;
    else begin
        if (w_rdaddr_write && (r_rdaddr_busy==0 || w_rdaddr_done))      // 2nd addr : start addr + burstsize from AXI
            r_rdaddr_count <= araddr + w_arburstsize;
        else if (w_ram_rdaddr_ld)                                       // 2nd addr : start addr + burstsize from 1st level pipeline reg
            r_rdaddr_count <= r_rdaddr_lat + r_arburstsize_lat;
        else if (w_ram_rden)                                            // 3rd addr onwards
            r_rdaddr_count <= r_rdaddr_count + r_incr_rdaddr;
    end
end

// check WRAP - combi
always_comb begin
    if (w_rdaddr_write && (r_rdaddr_busy==0 || w_rdaddr_done)) begin    //check 2nd addr
        w_current_rdaddr            = araddr;
        w_current_arburstlen        = arlen;
        w_current_arbursttype       = arburst;
        w_current_wraplow_rdaddr    = w_wraplow_rdaddr;
        w_current_wrapup_rdaddr     = w_wrapup_rdaddr;
    end
    else if (w_ram_rdaddr_ld) begin                                     //check 2nd addr
        w_current_rdaddr            = r_rdaddr_lat;
        w_current_arburstlen        = r_arburstlen_lat;
        w_current_arbursttype       = r_arbursttype_lat;
        w_current_wraplow_rdaddr    = r_wraplow_rdaddr_lat;
        w_current_wrapup_rdaddr     = r_wrapup_rdaddr_lat;
    end
    else begin                                                          //check 3rd addr onwards
        w_current_rdaddr            = r_rdaddr_count;
        w_current_arburstlen        = r_arburstlen_lat2;
        w_current_arbursttype       = r_arbursttype_lat2;
        w_current_wraplow_rdaddr    = r_wraplow_rdaddr_lat2;
        w_current_wrapup_rdaddr     = r_wrapup_rdaddr_lat2;
    end
end

always @(posedge clk) begin
    if (reset) begin
        r_incr_rdaddr           <=  'h0;
        r_arburstlen_lat2       <= 8'h0;
        r_arbursttype_lat2      <= 2'b00;
        r_wraplow_rdaddr_lat2   <=  'h0;
        r_wrapup_rdaddr_lat2    <=  'h0;
    end
    else if (w_rdaddr_write && (r_rdaddr_busy==0 || w_rdaddr_done)) begin
        r_incr_rdaddr           <= w_arburstsize;
        r_arburstlen_lat2       <= arlen;
        r_arbursttype_lat2      <= arburst;
        r_wraplow_rdaddr_lat2   <= w_wraplow_rdaddr;
        r_wrapup_rdaddr_lat2    <= w_wrapup_rdaddr;
    end
    // read addr latency - 2nd level pipeline
    else if (w_ram_rdaddr_ld) begin
        r_incr_rdaddr           <= r_arburstsize_lat;
        r_arburstlen_lat2       <= r_arburstlen_lat;
        r_arbursttype_lat2      <= r_arbursttype_lat;
        r_wraplow_rdaddr_lat2   <= r_wraplow_rdaddr_lat;
        r_wrapup_rdaddr_lat2    <= r_wrapup_rdaddr_lat;
    end
end


assign w_rdaddr_done = ~(|rden_count) & rready & w_ram_rready;

always @(posedge clk) begin
    if (reset)
        r_rdaddr_busy <= 1'b0;
    else if (w_ram_rdaddr_ld)
        r_rdaddr_busy <= 1'b1;
    else if (w_rdaddr_done)
        r_rdaddr_busy <= 1'b0;
end

// output to RAM: rden
assign ram_rden = w_ram_rden;

assign w_ram_rden = w_ram_rdaddr_ld | (w_rden & w_ram_rready);
assign w_rden = (rden_count==0)? 1'b0 : (rready & r_rdaddr_busy);

// w_ram_rden counter
always @(posedge clk) begin
    if (reset)
        rden_count <= 8'hFF;
    else if (w_ram_rdaddr_ld)
        rden_count <= w_current_arburstlen;
    else if (w_ram_rden)
        rden_count <= rden_count - 1'b1;
    else if (w_rdaddr_done)
        rden_count <= 8'hFF;
end

//-----------------Read Data--------------------------------------------------------------
// AXI read data is consumed
assign w_rdtrans_valid = rvalid & rready;



// AXI output: rvalid
always @(posedge clk) begin
    if (reset)
        rvalid <= 1'b0;
    else if (w_ram_rden)
        rvalid <= 1'b1;
    else if (w_rdtrans_valid)
        rvalid <= 1'b0;
end


// AXI output: rdata
assign rdata = w_ram_rddata;



// AXI output: rlast
assign rlast = ~(|rdtrans_count) & rvalid;

// rlast counter
always @(posedge clk) begin
    if (reset)
        rdtrans_count <= 8'hFF;
    else if ((w_ram_rdaddr_ld && r_rdtrans_busy==0 )|| w_rdtrans_done)
        rdtrans_count <= w_current_arburstlen;
    else if (w_rdtrans_valid)
        rdtrans_count <= rdtrans_count - 1'b1;
    else if (w_rdtrans_done)
        rdtrans_count <= 8'hFF;
end

assign w_rdtrans_done = rlast & w_rdtrans_valid;


always @(posedge clk) begin
    if (reset)
        r_rdtrans_busy <= 1'b0;
    else if (w_ram_rdaddr_ld)
        r_rdtrans_busy <= 1'b1;
    else if (w_rdtrans_done)
        r_rdtrans_busy <= 1'b0;
end

//----------------Read Response---------------------------------------------------------------------------------------
// AXI output: rresp
assign rresp = r_rresp_lat2 | ecc_rresp;

// rresp - 1st level pipeline
always @(posedge clk) begin
    if (reset)
        r_rresp_lat  <= 2'b00;
     else if (w_rdaddr_write) begin
        if (w_arburstsize > BYTE_WIDTH)  // Not support burst size larger than data width
        r_rresp_lat  <= 2'b10;
        else if (arburst == 0 || arburst == 3 )   // Not support burst type (FIXED and reserved)
        r_rresp_lat  <= 2'b10;
        else if (arburst == 2 && !((arlen == 1 )||(arlen == 3 )||(arlen == 7 )||(arlen == 15 )) )   // Not supported burst length for WRAP
        r_rresp_lat  <= 2'b10;
        else
        r_rresp_lat  <= 2'b00;
    end
end

always @(posedge clk) begin
    if (reset)
        r_rresp_lat2 <= 2'b00;
    else if (w_rdaddr_write && (r_rdtrans_busy==0 || w_rdtrans_done)) begin
        if (w_arburstsize > BYTE_WIDTH)  // Not support burst size larger than data width
        r_rresp_lat2  <= 2'b10;
        else if (arburst == 0 || arburst == 3 )   // Not support burst type (FIXED and reserved)
        r_rresp_lat2  <= 2'b10;
        else if (arburst == 2 && !((arlen == 1 )||(arlen == 3 )||(arlen == 7 )||(arlen == 15 )) )      // Not supported burst length for WRAP
        r_rresp_lat2  <= 2'b10;
        else
        r_rresp_lat2  <= 2'b00;
    end
    // rresp - 2nd level pipeline
    else if (w_ram_rdaddr_ld)
        r_rresp_lat2 <= r_rresp_lat;
end


// AXI output: rid
assign rid = r_rid_lat2;

always @(posedge clk) begin
    if (reset)
        r_rid_lat  <= 'b0;
    else if (w_rdaddr_write)
        r_rid_lat  <= arid;
end

always @(posedge clk) begin
    if (reset)
        r_rid_lat2  <= 'b0;
    else if (w_rdaddr_write && (r_rdtrans_busy==0 || w_rdtrans_done))
        r_rid_lat2  <= arid;
    else if (w_ram_rdaddr_ld)
        r_rid_lat2  <= r_rid_lat;
end


    assign ecc_rresp = 2'b00;


endmodule

