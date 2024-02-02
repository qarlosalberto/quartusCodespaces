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


module  intel_agilex_reset_release_from_sdm_atom 
(
    output wire conf_reset
);
    fourteennm_sdm_gpio_out 
    #(
        .bitpos       (15),
        .role         ("USER_RESET")
    ) 
    sdm_gpo_out_user_reset 
    (
        .gpio_o        (conf_reset)
    );
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "EI+J4SMLm58ANRP9hKJM1KSZ2Ct9l21ol47NGGxpl0K3asW2Nkbac2HhS/DUQV4s7zMna8JfID/uBsZDxnzwF7QqpkqW3IQQTeUDO7rK0S+eSD/b9h27HjWAM8GO9TOKRl4jEYZ0QJXw5XTWwDwujdp+uXwV96mrEe4agKWt4vT9klQL5XoNEirGHSV/ITQ3lIZSPdBdkyfkra/6k2Cp4Fcm9YgowdTHib0q/1CxUOt+4XA+XXoymrTEiqdHYUDwWAIb8j0jzcAj8JcS0xW3fHB+PV/xh/51mNIH/2WoclxxIBv/mHlqGrlhnzA1qalRq8herJ3NGc8V4Ww+KBXKJK5wiQFXOOOEKosGrwAzP8axDeMrAjAa+QSCaW0HUbqnfQDH7KuPia/1Ua13l8Il6oLvH/GCMTgWXLRatDYH4xUHxin0TQWd0bD7wTwIxiWvEHKD4s9Sb9vBol+djCs74R2vYecdsZBtExECTy4WemYmnhKijGPLG8nriPpJGlyoNgwJ9MzsQCY6auYFCwRwiok7BxpMpsighUNsBVLYlBbsNY38Oq571I0SQS5atADHf1P2h6Rq1MZ18irWBXEp4bYRpC+VQPC8diEWEqtFPF3uzDzgYTn0zSxM9PJY+qeoheqUWg21I2w0KgtUVx1f8jGgl/zEv76CEvJCPwaADccsY1EfuZueelKTf1ZOMS9NkQn8kSCzk0L5xa1IzdVfvEcYlX5T70t8of3m5oQWue08P2BrJ4kPMnttJxqDa00wHqJOJPdgtjImbpMuD5sz9TTup2nHb+51SiP/khE1NxELXFPB8JSSjZxkVyZwXpoWO9Y4suwoI8UoKi28UEsCXY1ftnD+KiZtm57Cbrf0LY6fFiHyU0B9KeR23CS51AbJHGvpTMU6XhXvp0OM5OHrAZp2XQQIEFw2u2GsT/38PKOCU8Mq3PHA2LjMPOniHDGXj3++roHiRAIulLesEgQXSbMj1T6ofbWRqkK/34k8Rc2eLRKIQ+34Fj946oMNHqvQ"
`endif