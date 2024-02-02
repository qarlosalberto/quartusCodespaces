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


// (C) 2001-2018 Intel Corporation. All rights reserved.
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


// $File: //acds/rel/23.4/ip/iconnect/avalon_st/altera_avalon_st_pipeline_stage/altera_avalon_st_pipeline_base.v $
// $Revision: #1 $
// $Date: 2023/10/12 $
// $Author: psgswbuild $
//------------------------------------------------------------------------------

`timescale 1ns / 1ns

module altera_avalon_st_pipeline_base (
                                       clk,
                                       reset,
                                       in_ready,
                                       in_valid,
                                       in_data,
                                       out_ready,
                                       out_valid,
                                       out_data
                                       );

   parameter  SYMBOLS_PER_BEAT  = 1;
   parameter  BITS_PER_SYMBOL   = 8;
   parameter  PIPELINE_READY    = 1;
   parameter  SYNC_RESET        = 0;
   parameter  BACKPRESSURE_DURING_RESET = 0;
   localparam DATA_WIDTH = SYMBOLS_PER_BEAT * BITS_PER_SYMBOL;
   
   input clk;
   input reset;
   
   output in_ready;
   input  in_valid;
   input [DATA_WIDTH-1:0] in_data;
   
   input                  out_ready;
   output                 out_valid;
   output [DATA_WIDTH-1:0] out_data;
   
   reg                     full0;
   reg                     full1;
   reg [DATA_WIDTH-1:0]    data0;
   reg [DATA_WIDTH-1:0]    data1;

   assign out_valid = full1;
   assign out_data  = data1;    
   
   // Generation of internal reset synchronization
   reg internal_sclr;
   generate if (SYNC_RESET == 1) begin : rst_syncronizer
      always @ (posedge clk) begin
         internal_sclr <= reset;
      end
   end
   endgenerate

   generate if (PIPELINE_READY == 1) 
     begin : REGISTERED_READY_PLINE
        
        assign in_ready  = !full0;

        always @(posedge clk) begin
              // ----------------------------
              // always load the second slot if we can
              // ----------------------------
              if (~full0)
                data0 <= in_data;
              // ----------------------------
              // first slot is loaded either from the second,
              // or with new data
              // ----------------------------
              if (~full1 || (out_ready && out_valid)) begin
                 if (full0)
                   data1 <= data0;
                 else
                   data1 <= in_data;
              end
        end
       
        if (SYNC_RESET == 0) begin : async_rst0 
           always @(posedge clk or posedge reset) begin
              if (reset) begin
                 full0    <= BACKPRESSURE_DURING_RESET ? 1'b1 : 1'b0;
                 full1    <= 1'b0;
              end else begin
                 // out of reset. 
                 if(~full1 & full0)begin
                     full0 <= 1'b0;
                 end

                 // no data in pipeline
                 if (~full0 & ~full1) begin
                    if (in_valid) begin
                       full1 <= 1'b1;
                    end
                 end // ~f1 & ~f0

                 // one datum in pipeline 
                 if (full1 & ~full0) begin
                    if (in_valid & ~out_ready) begin
                       full0 <= 1'b1;
                    end
                    // back to empty
                    if (~in_valid & out_ready) begin
                       full1 <= 1'b0;
                    end
                 end // f1 & ~f0
                 
                 // two data in pipeline 
                 if (full1 & full0) begin
                    // go back to one datum state
                    if (out_ready) begin
                       full0 <= 1'b0;
                    end
                 end // end go back to one datum stage
              end
           end
       end // async_rst0
       else begin // sync_rst0
           always @(posedge clk ) begin
              if (internal_sclr) begin
                 full0    <= BACKPRESSURE_DURING_RESET ? 1'b1 : 1'b0;
                 full1    <= 1'b0;
              end else begin
                 // out of reset. 
                 if(~full1 & full0)begin
                     full0 <= 1'b0;
                 end

                 // no data in pipeline
                 if (~full0 & ~full1) begin
                    if (in_valid) begin
                       full1 <= 1'b1;
                    end
                 end // ~f1 & ~f0

                 // one datum in pipeline 
                 if (full1 & ~full0) begin
                    if (in_valid & ~out_ready) begin
                       full0 <= 1'b1;
                    end
                    // back to empty
                    if (~in_valid & out_ready) begin
                       full1 <= 1'b0;
                    end
                 end // f1 & ~f0
                 
                 // two data in pipeline 
                 if (full1 & full0) begin
                    // go back to one datum state
                    if (out_ready) begin
                       full0 <= 1'b0;
                    end
                 end // end go back to one datum stage
              end
           end
       end // sync_rst0
     end 
   else 
     begin : UNREGISTERED_READY_PLINE
	
	// in_ready will be a pass through of the out_ready signal as it is not registered
	assign in_ready = (~full1) | out_ready;

   if (SYNC_RESET == 0) begin : async_rst1	
	   always @(posedge clk or posedge reset) begin
	      if (reset) begin
	         data1 <= 'b0;
	         full1 <= BACKPRESSURE_DURING_RESET ? 1'b1 : 1'b0;
	      end
	      else begin
	         if (in_ready) begin
	   	 data1 <= in_data;
	   	 full1 <= in_valid;
	         end
	      end
	   end
   end // async_rst1
   else begin // sync_rst1
      always @(posedge clk ) begin
	      if (internal_sclr) begin
	         data1 <= 'b0;
	         full1 <= BACKPRESSURE_DURING_RESET ? 1'b1 : 1'b0;
	      end
	      else begin
	         if (in_ready) begin
	   	 data1 <= in_data;
	   	 full1 <= in_valid;
	         end
	      end
	   end
	end // sync_rst1	
     end
   endgenerate
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "wEh4/1C5vcg942USVRBz9oJMLws6IY5FuN/rjPjMiZELR8vneIwP+kSk0fbb5bTQ6x5bM0l8YQQhfqUY1HzXR2+FBhjwDfv+khdS0YYTRyzLn3D0AUKVBDLC95ZYcguOgLWQf4PJOZlY2wRZlbn5vrzCeWf3KR9ydWJrgM6D1eR+JqFDolbsDZ2BDSnXsuSDnROVpwM5kNfG5ylyH7Io1dGabLuIfYJH6os7bXoWXIvCp9y0FMDo7DQDCTh8W+eJh7lEb2io3scxexU/eRMMUUjF6hB8J0/oPRpfnJ0aFGcjyvONZ4HoKucYTd8r6+2bjeh8ACIBS4fYGIQ1VuzPSMzF2dByifwtTwi24R/tySIH5GI+KWqljqMVgwdHXCyXlOl4WizYkxW15CwgwDwU2I21any0PsMqfD3EfSwyxpWEQieNSnX9OTWWTPioc1ZfDzYK5eIduM8aApLGVF4n/QCIzxP/+uA3dnNfMH/jEMrsMFqWJ28yGRr74lMVm4e+AFNAakK5ZNJ/7NY7NZatFgglCemO+YKXcbwsIblyUHfnVLaSuvaKPuS9yS1rU8g8DGSFKUXHUmKZwREjDJXqCuO31Lp4ToUE44dkSeROZ/qJwhpg/CD6xs41QRz4rknCHPdkEqTDM5pEjhmHXv1/vyjxU5YT6OTkBO92gWrKvUOlWJtmq6Dx9D8U8XUGNQWaGIE8q9zltQHKoufQtWEvB+NwWEQQYd/UoFtQiSACKmqXKLIgD3jVRaVcaF22vnMx84wqJZebOOTEthuoI51V9/5PbFILiv0B6KkqnoR+V1mrLZu+bE+VO9va93loVrGoYsSA1Rdr8APiLN0KCfTnoqIOUEtUpooYnKzsUDDAVtoePsD59SxdjoMYKUirPOYKj2Z3EVhzwx88b7T7w6pEc9KvePyWunmPkc//pY/cNLW45rHHW6wcLpJ11XkLOPuQwmqW+R45CAWlx7DU7Z/N9VsesLmdrydbMQH9TBqo8CwAar2m1R117wsK9Nsd8brP"
`endif