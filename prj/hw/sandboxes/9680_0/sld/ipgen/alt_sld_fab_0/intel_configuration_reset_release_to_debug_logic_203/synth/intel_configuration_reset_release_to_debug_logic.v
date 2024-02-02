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


module intel_configuration_reset_release_to_debug_logic
(
    input wire conf_reset
);
    altera_debug_config_reset_release_source_endpoint conf_reset_endpoint
    (
        .conf_reset(conf_reset)
    );
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "EI+J4SMLm58ANRP9hKJM1KSZ2Ct9l21ol47NGGxpl0K3asW2Nkbac2HhS/DUQV4s7zMna8JfID/uBsZDxnzwF7QqpkqW3IQQTeUDO7rK0S+eSD/b9h27HjWAM8GO9TOKRl4jEYZ0QJXw5XTWwDwujdp+uXwV96mrEe4agKWt4vT9klQL5XoNEirGHSV/ITQ3lIZSPdBdkyfkra/6k2Cp4Fcm9YgowdTHib0q/1CxUOtTH5ioMTB5oWWBg9hPfC4JxET+hWScXuzc4vVdMPNE7Ub2FpjMEUwwLNEkD7j1e5vbrckHfBLmRr4IvQSrwC44zD3CYExaskHl9ukVahJgIMIee1wGjz2Gp5fsgPNCmeOaKMRaLzFC2ZFab8/2aZGW2Rq9YE8sZ9Pd6gQJpihj5pCcLdfW3XRmAvjHLSPeaSUMLh89TpJGodHAu4af/ZP6q9XseYARztIpUpjYAifF5twY8eytRHYvDZHSB82Vovo4yPo03s7GImaojmbZVpCjEf7hQr11gbZhjftaIj06rHDxpeqzVNhY0MZaIyt3UEz8M5CU6msTFGgvrwOAHkjjK9iTGAQXEnIUlsWK0gayKL+/RizebLrzX8pP9Rxfwq4ATEih4jvryI7rUFzJNavD2V8/j4qVwPmmskd3VYQxYhCcBIX4NVmdx0ji2FQSyDtUH8RHyXXS+jqs2IZSnjx+fAkackwLXpmxwxSTgJl0+QPeQIQEtUxinFau9wOAm27SsQcltAsF++wwfwM1dW59AIM5/dojk5JW2lH1nJG7+TvWIAU0l/55TFdgy5ovMeHmS//aOBV3224GoAguRrD2VYUxrfHdYpwA7z9wtGqcCO+KgMmxq9tIwYYFbX3ey/U0WZrFd36V/C7ccPt+u/rvTMzx9rXM5OKV2nbNd3E8TyFr71a6UTgm10SIevhpRK4XHn0rNk2/auyT67W41ojTExnXrXEtIDyCxuHLWaKw6EhQLEl31rauUXTHEoXSjRw4LtXUjIqN06uj3HyLPpMg"
`endif