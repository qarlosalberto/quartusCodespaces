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


// $Id: //acds/rel/23.4/ip/iconnect/pd_components/altera_std_synchronizer/altera_std_synchronizer.v#1 $
// $Revision: #1 $
// $Date: 2023/10/12 $
// $Author: psgswbuild $
//-----------------------------------------------------------------------------
//
// File: altera_std_synchronizer.v
//
// Abstract: Single bit clock domain crossing synchronizer. 
//           Composed of two or more flip flops connected in series.
//           Random metastable condition is simulated when the 
//           __ALTERA_STD__METASTABLE_SIM macro is defined.
//           Use +define+__ALTERA_STD__METASTABLE_SIM argument 
//           on the Verilog simulator compiler command line to 
//           enable this mode. In addition, dfine the macro
//           __ALTERA_STD__METASTABLE_SIM_VERBOSE to get console output 
//           with every metastable event generated in the synchronizer.
//
// Copyright (C) Altera Corporation 2009, All Rights Reserved
//-----------------------------------------------------------------------------

`timescale 1ns / 1ns

module altera_std_synchronizer (
				clk, 
				reset_n, 
				din, 
				dout
				);

   parameter depth = 3; // This value must be >= 2 !
     
   input   clk;
   input   reset_n;    
   input   din;
   output  dout;

   // QuartusII synthesis directives:
   //     1. Preserve all registers ie. do not touch them.
   //     2. Do not merge other flip-flops with synchronizer flip-flops.
   // QuartusII TimeQuest directives:
   //     1. Identify all flip-flops in this module as members of the synchronizer 
   //        to enable automatic metastability MTBF analysis.
   //     2. Cut all timing paths terminating on data input pin of the first flop din_s1.

   (* altera_attribute = {"-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW; -name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS; -name DONT_MERGE_REGISTER ON; -name PRESERVE_REGISTER ON; -name SDC_STATEMENT \"set_false_path -to [get_keepers {*altera_std_synchronizer:*|din_s1}]\" "} *) reg din_s1;

   (* altera_attribute = {"-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW; -name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS; -name DONT_MERGE_REGISTER ON; -name PRESERVE_REGISTER ON"} *) reg [depth-2:0] dreg;    
   
   //synthesis translate_off
   initial begin
      if (depth <2) begin
	 $display("%m: Error: synchronizer length: %0d less than 2.", depth);
      end
   end

   // the first synchronizer register is either a simple D flop for synthesis
   // and non-metastable simulation or a D flop with a method to inject random
   // metastable events resulting in random delay of [0,1] cycles
   
`ifdef __ALTERA_STD__METASTABLE_SIM

   reg[31:0]  RANDOM_SEED = 123456;      
   wire  next_din_s1;
   wire  dout;
   reg   din_last;
   reg 	 random;
   event metastable_event; // hook for debug monitoring

   initial begin
      $display("%m: Info: Metastable event injection simulation mode enabled");
   end
   
   always @(posedge clk) begin
      if (reset_n == 0)
	random <= $random(RANDOM_SEED);
      else
	random <= $random;
   end

   assign next_din_s1 = (din_last ^ din) ? random : din;   

   always @(posedge clk or negedge reset_n) begin
       if (reset_n == 0) 
	 din_last <= 1'b0;
       else
	 din_last <= din;
   end

   always @(posedge clk or negedge reset_n) begin
       if (reset_n == 0) 
	 din_s1 <= 1'b0;
       else
	 din_s1 <= next_din_s1;
   end
   
`else 

   //synthesis translate_on   
   always @(posedge clk or negedge reset_n) begin
       if (reset_n == 0) 
	 din_s1 <= 1'b0;
       else
	 din_s1 <= din;
   end
   //synthesis translate_off      

`endif

`ifdef __ALTERA_STD__METASTABLE_SIM_VERBOSE
   always @(*) begin
      if (reset_n && (din_last != din) && (random != din)) begin
	 $display("%m: Verbose Info: metastable event @ time %t", $time);
	 ->metastable_event;
      end
   end      
`endif

   //synthesis translate_on

   // the remaining synchronizer registers form a simple shift register
   // of length depth-1
   generate
      if (depth < 3) begin
	 always @(posedge clk or negedge reset_n) begin
	    if (reset_n == 0) 
	      dreg <= {depth-1{1'b0}};	    
	    else
	      dreg <= din_s1;
	 end	 
      end else begin
	 always @(posedge clk or negedge reset_n) begin
	    if (reset_n == 0) 
	      dreg <= {depth-1{1'b0}};
	    else
	      dreg <= {dreg[depth-3:0], din_s1};
	 end
      end
   endgenerate

   assign dout = dreg[depth-2];
   
endmodule 


			
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "9JT9tWMyqRu1ndGSDnGbUKfWPSNSFGouY0YpmNox2lZuBT0xminaIpwsCdQ5HXMM8QB/laLiBuX68wMRjH2PJuzZZz1NZTJ4mgYJ84nmbAu0Ejndz/Hk4EHzGz/54knnLvE4cSFwWrWywL+xLd49XdWuWqPhJzwdgppiSoIe2AAKH2/jIaegiUu8A+AnNtY9kuSaPTYFdTJ4iAAaDsoaB5yKTsDWRk7zS1rxHPbSXkV8ZO+xpYvMqjllCntVLca6Qub8vkFgKvlP6jZkkUmH4C2qjgeyG6K3cs9YeNn84teeG1+APJZy2Bn9p7PJovR5u9W66CFPTwMknZGYAXzH4auylM8B/dNMVoqkFv4s9FcRj+dQuNgkEm0xMtSVN5QQyW/N+L5NWXmTV881hXjg8HjjUHHebgCStwcIBplhF4EdmlwtkRgzC56L93Gd+4TaNpsxaAEL5RMGuwKEKHPsAN5LVxOeNUcs11cG4tMASvt4qIRI3njg1gPEYeisgr7GMTWHa5woMGuHhbN3JaHcEIBFSeec9hZYIVsYj6RVKBYJ/FHpbKUfg/Jh60aGzc8kCkIgl0G/agfRFhhRBYXczURLc/NFAcjTIHc4p6stxdNj6C2KIYnaAluDuu2f2Pz0rCgHuv3sW9kk/5qGsYRnIEC+BvLvM/jMBADj88g0/vjARtpp6PglaN3Q/gsq4/yW52i/CcHuyGhZvcxhRAyVIZiVb0dndrDpbaQxkANcVMvHB2ZrVmMxaGBxussR0xzoTe+/Gw6NE6snfEfBEPpVDtM47zPzCgz492FyZkQL38r7T7xebk1M2WrWHSJ3W7zwJ7aBwgvZaAZWyj6wChCaVS03trIX9r34TNFANjy4b2Edtr/YTANNY5BXcCkVWgSL3S0iZJXt4x8F2CEqfPDXchPRJE828upO9ANAjEd9WhI1Il2f/by2m++GqPv5AoD4qmSBeX2JD6WGltzlVJCkjF+vQ2MXdPGl3uMZpWXWo1EglylyLlIScP4qq2L+mV6d"
`endif