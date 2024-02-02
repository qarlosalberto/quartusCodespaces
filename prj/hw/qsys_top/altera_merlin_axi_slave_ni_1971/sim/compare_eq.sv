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


`timescale 1ps/1ps

module compare_eq #(
    parameter WIDTH=10
) (
    input [WIDTH-1:0]  in_a,
    input [WIDTH-1:0]  in_b,
    output             equal
);

assign equal = (in_a==in_b);

endmodule 
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "Fxa9eAwhQKyO7BU1/7bjPmgblZpHoz21mtM7rIFgCFhck45imyhj1aygbIZX4iOJ9XcC7PKfIH6legSE8rrIUjTLPqMpgY+fQIC16h3M6ixbDYqXaW0ZKpowYwc7rqii1SA7ng/CPytWN5BMekAHsa2v8bs5vJW8nkIB7dPVcFMAmC8nM8o+LY9Axe3OJFJP51uvRhIHEWU0Opo70NaOx3ZsYwzEUl1jLKHqa0OWzwWapNZWC74hLBF6ugkv4gdZAbHnm0XvmW/vvqkLQPXMstJinCLVFLL8upASLw9ZswfnnDv5LpC0fFAK8HUThrFBQ18njQGXZ9Ar9WNC5JY2uWb5+CJ7Xy9L7emjq5DkXo4XZxkhBi/o08HVPAYxyAONhKbT4vunP70d/uLveJ9sdBbJ9qOlLoAHcbsORL5MM5lwrsQSW2iYJRxU81906QvCirWAMliqjotY+4+1W/2CZrP9xtUFZyQ0dUPcpYzKmcBFrEisX9ksk709gyOlHMqdId0DsJUdFuSFWjKPdxjDzZJJb8VPSIqtIqQMGhj0qYesDoFIG4QYscgtv5FjDYvVkf2/AZNfgRLbDFjh+P2ng0tjNLlVLl5QxJpsU0mEkw+1wXCZWl7fcSEz0PZBM4wDVUtrzAw66uKKlEr8pec2SYUwlDhRY4aqViR6Ht2JTae1ngkSDorBI+N4AYw35BIVV/n1ZxMs3IVbSztI3zpBMuR/qthvJoTTBs4mHu0YXsLTtftLh37WIN+6Lk/i7GRclfSXZPqlaTfdnGnnFkLoVGWRpjwLLSR5nfUrWNumLYjwYvllupnDnpmDPBgwKmXfZQAzcODmTy628F8fID4lV3Qz1u1dbQ+jV1q4vKAJH5V842WrZ8h8fBwAsXePRWKa8gr2lfLk/KmZ4a7cL3fIBIJd1jmVfQ95u2ogGy73uHfjAluwmp1h965ffnP/BHDxHq1LU7rvTme9B6VdXNy1lD6UGNuoFZxWyKqkHM3fdX/EBW7WJcXU4T7dxT4xwZQd"
`endif