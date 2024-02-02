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


// $Id: //acds/rel/23.4/ip/iconnect/pd_components/altera_std_synchronizer/altera_std_synchronizer_bundle.v#1 $
// $Revision: #1 $
// $Date: 2023/10/12 $
//----------------------------------------------------------------
//
// File: altera_std_synchronizer_bundle.v
//
// Abstract: Bundle of bit synchronizers. 
//           WARNING: only use this to synchronize a bundle of 
//           *independent* single bit signals or a Gray encoded 
//           bus of signals. Also remember that pulses entering 
//           the synchronizer will be swallowed upon a metastable
//           condition if the pulse width is shorter than twice
//           the synchronizing clock period.
//
// Copyright (C) Altera Corporation 2008, All Rights Reserved
//----------------------------------------------------------------

module altera_std_synchronizer_bundle(
				     clk,
				     reset_n,
				     din,
				     dout
				     );
   parameter width = 1;
   parameter depth = 3;   
   
   input clk;
   input reset_n;
   input [width-1:0] din;
   output [width-1:0] dout;
   
   generate
      genvar i;
      for (i=0; i<width; i=i+1)
	begin : sync
	   altera_std_synchronizer #(.depth(depth))
                                   u (
				      .clk(clk), 
				      .reset_n(reset_n), 
				      .din(din[i]), 
				      .dout(dout[i])
				      );
	end
   endgenerate
   
endmodule 

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "9JT9tWMyqRu1ndGSDnGbUKfWPSNSFGouY0YpmNox2lZuBT0xminaIpwsCdQ5HXMM8QB/laLiBuX68wMRjH2PJuzZZz1NZTJ4mgYJ84nmbAu0Ejndz/Hk4EHzGz/54knnLvE4cSFwWrWywL+xLd49XdWuWqPhJzwdgppiSoIe2AAKH2/jIaegiUu8A+AnNtY9kuSaPTYFdTJ4iAAaDsoaB5yKTsDWRk7zS1rxHPbSXkW77kM9qGW09opZodyQih8PT0t9BmRV5CSHp1+WhnkYPt8ATRZRJt+O/6d2sUbCZKZ0EoIgxeeJSDoX4q3Kd1S0jV2kj7HwQXQapW8nlr/Ulva3s25jGIqugP2895GV8Vwc4dQT+amz9nHYBjZDyL4p91FMn9lu32CZZBnp7zHgoYhjh84n4KJgreybi9+8MYg0ATqJswVwaLuJBO7wolnoWV3J+c1n1Amphy553DkAaNTjHVCe6CSK1/cDeSVJ3BL2FHWi9DoO/EGqqUv+7/Zp6Yt7PdypjlUjFRhnqhBIjnmTwUBYoShN8yQzdVTFg9HhDhzWNaB6v46e3WiaOQa2ynJYOckJgCFNkgSCzC6A71w959PCKUb/2ET9eDxJuBxLeJ8PKK5qKpNkrwyYb6MWKqnX7oRH2OvFS6itrDx/iataymjRmt9f1Xbw3GHUMtKBloko6ITOdljEzYcADPkr4KUK/lsH7NKlKo6z17e4NwnzggU1+AI20iPDdHs1v5zHPLYr4WT3+uqnAOAEDFbIdB/mVkbY+xgk2vgGKvoPPpIRS+kQwSfxEwBkf90ESNM3HicP7X6Htj1tiHPLn1N8y8VL6yQxhn38ejIChFDDNcFR4Cd9I3HD1yBUk5I1czFQaP1Ub5lw1gDh9R5Mw1ckMkWVmcIJa6WTzJEgk7RBvFvcMsFBE2QkU6tVqP2kMcuuwiEKQ7kefftBwfknsWIZAOY6w7H5HE8H82G/PyMJRLxtGvUbM7+ymIPpRfu93DCZa0KaHOfVX7D9nRjc1+QQ"
`endif