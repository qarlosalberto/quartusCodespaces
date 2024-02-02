module alt_sld_fab_0_intel_agilex_reset_release_from_sdm_203_bv4oeci
(
    output wire conf_reset_out_0
);
    wire reset_sig;
    intel_agilex_reset_release_from_sdm_atom
    user_reset
    (
        .conf_reset(reset_sig)
    );
    assign conf_reset_out_0 = reset_sig;
endmodule

