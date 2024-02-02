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


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module altera_avalon_sysid_qsys #(
    parameter ID_VALUE   = 1,
    parameter TIMESTAMP  = 1
)(
    // inputs:
     address,
     clock,
     reset_n,
    
    // outputs:
     readdata
)
;

  output  [ 31: 0] readdata;
  input            address;
  input            clock;
  input            reset_n;

  wire    [ 31: 0] readdata;
  //control_slave, which is an e_avalon_slave
  assign readdata = address ? TIMESTAMP : ID_VALUE;

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mqDXtLzub6gy/XZe+Dsm5ZVWICJsh7Hxwg8vQbRRrM+sf4f1gOYSoKWjcKvTlmri45kxKe63QQ7qxs5NTSps3sEKM246Tz6RtlyzqwgzrV0fYsuDunVPFI8SelQYcaHCvks6EsOdWQ+7+qVpdwSwqBo6fdJOOhMiDsZQpvymJNDwDlxl0NJZgPdNNM3eXtAPXuAPSlmLd0c89yuu8mTmMHG1+3MUHs6MME6Gbtf1D0FzeK4kyRDUWgawBK9a8qOkbDyIAJ2NE/XBRChvbnlW8hwu98KR7S7Sr017ewZXkNVCZhY4QBQRee1CRJlYvR9jILnxaX7A0+wDfMZ+HDkbcUWQ8BjegKk1Mp9gepOu0TKOZF0cWYVanSXLRdVSXFuEJVe0pdnArryjqBT52u1MWocfmuxGFLs6Ec9Vfpi0d3KdNmvn++2pyYotqMFzp1RKvgS5ix6L4Hqdbn1LArT0q0xMfLG2AVWX94XbFRrlglzsfRJBKjitsLIcDZXrYvjFv2oRtuCt0NvWPLtbXG9OWriYhDX/rbQx8s7JdsDdW6srqFOIYgMSYA76EIzNNoTpagL9uI/069KEIjwHsIMTVZQHvIU1RU47C478i1B0VTYPCTQYmI2QmxW12IXy5YmDSEPqZjqfZ/Rg190f2ndZaOCu44TpcCFQNt+PSaxlqP2YmQwYPfr4uUK2hx+po1roW4M05GOJ6TdZ9yA2LdksmbJmRrmiLKBp7Ig1E8vbyIfKMJnJAS7BWCnoJSkqT413YtP9qcuklU8HryFKbm/my1J2u4cNEdWHy0Rj29t3ITkgb0YgZGMOCeP4IcSQfuRNx9P5opKRhDq+mQu+lzd4egSM4ivHg4Rsn0x7gCmX6CNuSoyxbh0Z/QNU1EAFiebkTGCG8/FzJdKLi3Y/w2i1KIvegh1snEWW6ZqBJ9pUTJm747W7NLYwi8GJ+vajY0siGFDTxkeKjcg4bFnUJ3v7mPOf8SOA6o0RVG0Fb0EI/deLl64kYag5PKatT320ZC6q"
`endif