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


module intel_configuration_reset_release_for_debug
#(
   parameter DEVICE_FAMILY_ID = 2
)
(
   output wire conf_reset
);
   if(DEVICE_FAMILY_ID == 2) begin: s10 //stratix 10
      fourteennm_lsm_gpio_out 
      #(
         .bitpos       (19),
         .role         ("postuser"),
         .timingseq    (0)
      ) 
      lsm_gpo_out_user_reset 
      (
         .gpio_o        (conf_reset)
      );
   end
   else if(DEVICE_FAMILY_ID == 3) begin: ag //agilex
        fourteennm_sdm_gpio_out 
        #(
           .bitpos       (14),
           .role         ("USER_RESET")
        ) 
        sdm_gpo_out_user_reset 
        (
           .gpio_o        (conf_reset)
        );
   end
   else begin: universal
      lcell lc
      ( 
         .in(1'b0), 
         .out(conf_reset) 
      )/* synthesis altera_attribute = "-name PRESERVE_FANOUT_FREE_WYSIWYG ON" */;
   end
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "EI+J4SMLm58ANRP9hKJM1KSZ2Ct9l21ol47NGGxpl0K3asW2Nkbac2HhS/DUQV4s7zMna8JfID/uBsZDxnzwF7QqpkqW3IQQTeUDO7rK0S+eSD/b9h27HjWAM8GO9TOKRl4jEYZ0QJXw5XTWwDwujdp+uXwV96mrEe4agKWt4vT9klQL5XoNEirGHSV/ITQ3lIZSPdBdkyfkra/6k2Cp4Fcm9YgowdTHib0q/1CxUOtErseFzDT+5GPpbThaL6HmdCrnSsMMvfu45MFQUa7dPSzu8gFqexiC4cny0QJ3fzr+u3zdPbcBS3P0aBhXg702R9TWqpXZSKIfQqvCm69LsuAznO/K/LImxFvrU61NLb4ppEOO0U4m8qBRYYJEtY/dCEuNQ6sBaCeQ8RtzpCaar/1MJu0SE5w0G/OZjVG5Q/LHfjAjsE62u0S7zuiXDiwkXXJ9LY+IR5HM/gZN8CZHt3zZG2cTC9NSl+eM4LONd8UurAS0qOPIw3pJ/hPhOhBOcmjlR/UJ2VSvAeLqjnrGxRj4FqBzhVE1KawxvEgWxJdRU7udjl+Hhz3kjgl8qtjyV1ZYWQinpTF1CSmkpy5X+YdXkBAByR9BSSqKNm14JeIhK3IbjmAzgvSdbbcqqb9in+JonqUL+XsMowggTEmWdG4qVzT/RvFtZYE+HrWYWHdYUaCp9/aIIYSg3CFe0oU2aUdXk89aXbeKLasCu/iTD2PAu2KDmRESrwqWU0L+P+IDmooHiMvRWWU5i2lj06pmg357ZWtYPQtiCEwDxFdLHml4IcHZAzbdNmGr6wkqFGoRf3y37We1ShKn6wEiVbh4TkegshQ9iTNybSY+mw/3r3adA3B8HXEiDfLh0+tk/Ba7YfKQG7S9FjUI1c31Qjx3egc+LxcyKe4vLyG0t14t8a9BGoVbTSRIpkMFQxmRpEYXkk2sYZWxiH1jSfEkDykZZ7UDhXON3ueMljMlDPcQtkR+9iUFoZYoI8v+TLyoPELM/EPBJkL0rK1bYUwc0OEH"
`endif