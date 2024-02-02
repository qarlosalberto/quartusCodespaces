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


`timescale 1 ns / 1 ns
module altera_s10_user_rst_clkgate (
	output logic ninit_done
);

	localparam USER_RESET_DELAY = 0;
	
	initial begin
		#0 ninit_done = 1;
		#1 ninit_done = 0;
	end
					
	
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "xMZgyV34pPO7hMPrYnhgActLJKzbBWiZRW1pe4/E/5zgtQml8xXtizmgBc9AGQX5XsK+8g88LWp8Vh5Pv+llm1VHLp04JYEwMs1FlbdeY/AVkoBGmdhfzOzMGFGDDRKbhmnqbp2g4frwFdSzvYbTTnixlk7VWmCuAXPDEDhGjs7WFBZz4pYy4byfXpoFX/LkJIEoy+jB4ZIOEyfbhOk1c3QpQDZ8Nh1LIfvs501bOQHnHpXo1lXaMuT23bZK94l0DSxyuuekwYjYzB9kAfSemZlBX4CcSVNS7sDkgs0SfJJFKr/Ev/mb7Ds+eMIPsft0xxEft7MfjKdq4jaeue1m8SpLJN2eq0Zu/nXUOjKqaiPM+XQMuKSalZjBRQMYcULdczSAXezVDPQ7In7eS3/QyADVYTM9zNC02gxvNgubCClMon6GvGPBek5I7+nxYv+7C0bNVaci7JzbHq+Yo20e0x61wXlaAK+h+MIQJInHPu8byOcKSB19Y2rY3KftWKKrvJEQ2Twc0fg2gc1byBxBtcDgqd7oyUedUUUGbrfCPKBA0wjRcgK+q83PRHlzpIHiJAak8tVst1hf283gSq9MFzjbdH+8Mf4qDG3u/+m8MKeS5NEj1dNmrhmwy+pgdmnnpbNb1l4QvG4tHYad5KSShSlKTC8EMHJz1FutXu583L8hxBv8x8AZlQSUacfbaZ0kP+DJ4ixytHnnzD8KlCQbjUIkLVhM3ZDcemV801G+8dMkOGeEhftp57sQXmhO29wwcfeBE86fq2PgCyHou1+NRAYq0nA/tKFN0cfuJPh7poiIWNguPhCxzUipK4Az5oIXhBKnseLKTEQboR0+nPM5NJNo7k/Szol1UayZtTMWqw+H0w9Ix899VfULZ4QTSzWaKM6PbDyYgTP22otmXQgHZwWqIvrP4PxKwnHDqlCRgD1CFoQFxdVMphG0nNl6m1yILqdF3bbsLzoCPqI1z93MX07CH54g5mIM2cd+Q59B46eo51s3OQZM0GWSYj+uNsxd"
`endif