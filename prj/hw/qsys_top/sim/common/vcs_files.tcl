source [file join [file dirname [info script]] ./../../../ip/qsys_top/qsys_top_s10_user_rst_clkgate_0/sim/common/vcs_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/qsys_top/qsys_top_sysid_qsys_0/sim/common/vcs_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/qsys_top/qsys_top_jtag_uart_0/sim/common/vcs_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/qsys_top/qsys_top_iopll_0/sim/common/vcs_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/qsys_top/qsys_top_intel_onchip_memory_0/sim/common/vcs_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/qsys_top/qsys_top_pio_0/sim/common/vcs_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/qsys_top/qsys_top_clock_in/sim/common/vcs_files.tcl]
source [file join [file dirname [info script]] ./../../../ip/qsys_top/qsys_top_intel_niosv_m_0/sim/common/vcs_files.tcl]

namespace eval qsys_top {
  proc get_memory_files {QSYS_SIMDIR} {
    set memory_files [list]
    set memory_files [concat $memory_files [qsys_top_s10_user_rst_clkgate_0::get_memory_files "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_s10_user_rst_clkgate_0/sim/"]]
    set memory_files [concat $memory_files [qsys_top_sysid_qsys_0::get_memory_files "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_sysid_qsys_0/sim/"]]
    set memory_files [concat $memory_files [qsys_top_jtag_uart_0::get_memory_files "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_jtag_uart_0/sim/"]]
    set memory_files [concat $memory_files [qsys_top_iopll_0::get_memory_files "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_iopll_0/sim/"]]
    set memory_files [concat $memory_files [qsys_top_intel_onchip_memory_0::get_memory_files "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_intel_onchip_memory_0/sim/"]]
    set memory_files [concat $memory_files [qsys_top_pio_0::get_memory_files "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_pio_0/sim/"]]
    set memory_files [concat $memory_files [qsys_top_clock_in::get_memory_files "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_clock_in/sim/"]]
    set memory_files [concat $memory_files [qsys_top_intel_niosv_m_0::get_memory_files "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_intel_niosv_m_0/sim/"]]
    return $memory_files
  }
  
  proc get_common_design_files {QSYS_SIMDIR} {
    set design_files [dict create]
    set design_files [dict merge $design_files [qsys_top_s10_user_rst_clkgate_0::get_common_design_files "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_s10_user_rst_clkgate_0/sim/"]]
    set design_files [dict merge $design_files [qsys_top_sysid_qsys_0::get_common_design_files "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_sysid_qsys_0/sim/"]]
    set design_files [dict merge $design_files [qsys_top_jtag_uart_0::get_common_design_files "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_jtag_uart_0/sim/"]]
    set design_files [dict merge $design_files [qsys_top_iopll_0::get_common_design_files "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_iopll_0/sim/"]]
    set design_files [dict merge $design_files [qsys_top_intel_onchip_memory_0::get_common_design_files "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_intel_onchip_memory_0/sim/"]]
    set design_files [dict merge $design_files [qsys_top_pio_0::get_common_design_files "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_pio_0/sim/"]]
    set design_files [dict merge $design_files [qsys_top_clock_in::get_common_design_files "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_clock_in/sim/"]]
    set design_files [dict merge $design_files [qsys_top_intel_niosv_m_0::get_common_design_files "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_intel_niosv_m_0/sim/"]]
    return $design_files
  }
  
  proc get_design_files {QSYS_SIMDIR} {
    set design_files [dict create]
    set design_files [dict merge $design_files [qsys_top_s10_user_rst_clkgate_0::get_design_files "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_s10_user_rst_clkgate_0/sim/"]]
    set design_files [dict merge $design_files [qsys_top_sysid_qsys_0::get_design_files "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_sysid_qsys_0/sim/"]]
    set design_files [dict merge $design_files [qsys_top_jtag_uart_0::get_design_files "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_jtag_uart_0/sim/"]]
    set design_files [dict merge $design_files [qsys_top_iopll_0::get_design_files "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_iopll_0/sim/"]]
    set design_files [dict merge $design_files [qsys_top_intel_onchip_memory_0::get_design_files "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_intel_onchip_memory_0/sim/"]]
    set design_files [dict merge $design_files [qsys_top_pio_0::get_design_files "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_pio_0/sim/"]]
    set design_files [dict merge $design_files [qsys_top_clock_in::get_design_files "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_clock_in/sim/"]]
    set design_files [dict merge $design_files [qsys_top_intel_niosv_m_0::get_design_files "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_intel_niosv_m_0/sim/"]]
    dict set design_files "qsys_top_altera_merlin_slave_translator_191_x56fcki.sv"                             "$QSYS_SIMDIR/../altera_merlin_slave_translator_191/sim/qsys_top_altera_merlin_slave_translator_191_x56fcki.sv"                         
    dict set design_files "qsys_top_altera_merlin_axi_translator_1931_d46vvwa.sv"                              "$QSYS_SIMDIR/../altera_merlin_axi_translator_1931/sim/qsys_top_altera_merlin_axi_translator_1931_d46vvwa.sv"                           
    dict set design_files "altera_merlin_address_alignment.sv"                                                 "$QSYS_SIMDIR/../altera_merlin_axi_master_ni_1962/sim/altera_merlin_address_alignment.sv"                                               
    dict set design_files "qsys_top_altera_merlin_axi_master_ni_1962_2kryw2a.sv"                               "$QSYS_SIMDIR/../altera_merlin_axi_master_ni_1962/sim/qsys_top_altera_merlin_axi_master_ni_1962_2kryw2a.sv"                             
    dict set design_files "qsys_top_altera_merlin_slave_agent_1921_b6r3djy.sv"                                 "$QSYS_SIMDIR/../altera_merlin_slave_agent_1921/sim/qsys_top_altera_merlin_slave_agent_1921_b6r3djy.sv"                                 
    dict set design_files "altera_merlin_burst_uncompressor.sv"                                                "$QSYS_SIMDIR/../altera_merlin_slave_agent_1921/sim/altera_merlin_burst_uncompressor.sv"                                                
    dict set design_files "qsys_top_altera_avalon_sc_fifo_1931_vhmcgqy.v"                                      "$QSYS_SIMDIR/../altera_avalon_sc_fifo_1931/sim/qsys_top_altera_avalon_sc_fifo_1931_vhmcgqy.v"                                          
    dict set design_files "qsys_top_altera_merlin_axi_slave_ni_altera_avalon_sc_fifo_1971_rppzhri.v"           "$QSYS_SIMDIR/../altera_merlin_axi_slave_ni_1971/sim/qsys_top_altera_merlin_axi_slave_ni_altera_avalon_sc_fifo_1971_rppzhri.v"          
    dict set design_files "qsys_top_altera_avalon_st_pipeline_stage_1930_bv2ucky.sv"                           "$QSYS_SIMDIR/../altera_avalon_st_pipeline_stage_1930/sim/qsys_top_altera_avalon_st_pipeline_stage_1930_bv2ucky.sv"                     
    dict set design_files "altera_avalon_st_pipeline_base.v"                                                   "$QSYS_SIMDIR/../altera_avalon_st_pipeline_stage_1930/sim/altera_avalon_st_pipeline_base.v"                                             
    dict set design_files "qsys_top_altera_merlin_axi_slave_ni_altera_avalon_st_pipeline_stage_1971_3ngnl2a.v" "$QSYS_SIMDIR/../altera_merlin_axi_slave_ni_1971/sim/qsys_top_altera_merlin_axi_slave_ni_altera_avalon_st_pipeline_stage_1971_3ngnl2a.v"
    dict set design_files "qsys_top_altera_merlin_axi_slave_ni_altera_avalon_st_pipeline_stage_1971_t7ranli.v" "$QSYS_SIMDIR/../altera_merlin_axi_slave_ni_1971/sim/qsys_top_altera_merlin_axi_slave_ni_altera_avalon_st_pipeline_stage_1971_t7ranli.v"
    dict set design_files "qsys_top_altera_merlin_axi_slave_ni_altera_avalon_st_pipeline_stage_1971_t2kzqjy.v" "$QSYS_SIMDIR/../altera_merlin_axi_slave_ni_1971/sim/qsys_top_altera_merlin_axi_slave_ni_altera_avalon_st_pipeline_stage_1971_t2kzqjy.v"
    dict set design_files "altera_merlin_burst_uncompressor.sv"                                                "$QSYS_SIMDIR/../altera_merlin_axi_slave_ni_1971/sim/altera_merlin_burst_uncompressor.sv"                                               
    dict set design_files "altera_merlin_address_alignment.sv"                                                 "$QSYS_SIMDIR/../altera_merlin_axi_slave_ni_1971/sim/altera_merlin_address_alignment.sv"                                                
    dict set design_files "compare_eq.sv"                                                                      "$QSYS_SIMDIR/../altera_merlin_axi_slave_ni_1971/sim/compare_eq.sv"                                                                     
    dict set design_files "rd_response_mem_c6ig3wy.sv"                                                         "$QSYS_SIMDIR/../altera_merlin_axi_slave_ni_1971/sim/rd_response_mem_c6ig3wy.sv"                                                        
    dict set design_files "rd_comp_sel_c6ig3wy.sv"                                                             "$QSYS_SIMDIR/../altera_merlin_axi_slave_ni_1971/sim/rd_comp_sel_c6ig3wy.sv"                                                            
    dict set design_files "rd_pri_mux_c6ig3wy.sv"                                                              "$QSYS_SIMDIR/../altera_merlin_axi_slave_ni_1971/sim/rd_pri_mux_c6ig3wy.sv"                                                             
    dict set design_files "rd_sipo_plus_c6ig3wy.sv"                                                            "$QSYS_SIMDIR/../altera_merlin_axi_slave_ni_1971/sim/rd_sipo_plus_c6ig3wy.sv"                                                           
    dict set design_files "wr_response_mem_c6ig3wy.sv"                                                         "$QSYS_SIMDIR/../altera_merlin_axi_slave_ni_1971/sim/wr_response_mem_c6ig3wy.sv"                                                        
    dict set design_files "wr_comp_sel_c6ig3wy.sv"                                                             "$QSYS_SIMDIR/../altera_merlin_axi_slave_ni_1971/sim/wr_comp_sel_c6ig3wy.sv"                                                            
    dict set design_files "wr_pri_mux_c6ig3wy.sv"                                                              "$QSYS_SIMDIR/../altera_merlin_axi_slave_ni_1971/sim/wr_pri_mux_c6ig3wy.sv"                                                             
    dict set design_files "wr_sipo_plus_c6ig3wy.sv"                                                            "$QSYS_SIMDIR/../altera_merlin_axi_slave_ni_1971/sim/wr_sipo_plus_c6ig3wy.sv"                                                           
    dict set design_files "qsys_top_altera_merlin_axi_slave_ni_1971_c6ig3wy.sv"                                "$QSYS_SIMDIR/../altera_merlin_axi_slave_ni_1971/sim/qsys_top_altera_merlin_axi_slave_ni_1971_c6ig3wy.sv"                               
    dict set design_files "qsys_top_altera_merlin_router_1921_utv3xty.sv"                                      "$QSYS_SIMDIR/../altera_merlin_router_1921/sim/qsys_top_altera_merlin_router_1921_utv3xty.sv"                                           
    dict set design_files "qsys_top_altera_merlin_router_1921_zl5jwpa.sv"                                      "$QSYS_SIMDIR/../altera_merlin_router_1921/sim/qsys_top_altera_merlin_router_1921_zl5jwpa.sv"                                           
    dict set design_files "qsys_top_altera_merlin_router_1921_kr7tdby.sv"                                      "$QSYS_SIMDIR/../altera_merlin_router_1921/sim/qsys_top_altera_merlin_router_1921_kr7tdby.sv"                                           
    dict set design_files "qsys_top_altera_merlin_router_1921_ximin2q.sv"                                      "$QSYS_SIMDIR/../altera_merlin_router_1921/sim/qsys_top_altera_merlin_router_1921_ximin2q.sv"                                           
    dict set design_files "qsys_top_altera_merlin_router_1921_u3zwzza.sv"                                      "$QSYS_SIMDIR/../altera_merlin_router_1921/sim/qsys_top_altera_merlin_router_1921_u3zwzza.sv"                                           
    dict set design_files "qsys_top_altera_merlin_router_1921_dimnyca.sv"                                      "$QSYS_SIMDIR/../altera_merlin_router_1921/sim/qsys_top_altera_merlin_router_1921_dimnyca.sv"                                           
    dict set design_files "qsys_top_altera_merlin_router_1921_jtwzolq.sv"                                      "$QSYS_SIMDIR/../altera_merlin_router_1921/sim/qsys_top_altera_merlin_router_1921_jtwzolq.sv"                                           
    dict set design_files "qsys_top_altera_merlin_router_1921_4swavfy.sv"                                      "$QSYS_SIMDIR/../altera_merlin_router_1921/sim/qsys_top_altera_merlin_router_1921_4swavfy.sv"                                           
    dict set design_files "qsys_top_altera_merlin_traffic_limiter_altera_avalon_sc_fifo_1921_4a23ufy.v"        "$QSYS_SIMDIR/../altera_merlin_traffic_limiter_1921/sim/qsys_top_altera_merlin_traffic_limiter_altera_avalon_sc_fifo_1921_4a23ufy.v"    
    dict set design_files "altera_merlin_reorder_memory.sv"                                                    "$QSYS_SIMDIR/../altera_merlin_traffic_limiter_1921/sim/altera_merlin_reorder_memory.sv"                                                
    dict set design_files "altera_avalon_st_pipeline_base.v"                                                   "$QSYS_SIMDIR/../altera_merlin_traffic_limiter_1921/sim/altera_avalon_st_pipeline_base.v"                                               
    dict set design_files "qsys_top_altera_merlin_traffic_limiter_1921_ggluely.sv"                             "$QSYS_SIMDIR/../altera_merlin_traffic_limiter_1921/sim/qsys_top_altera_merlin_traffic_limiter_1921_ggluely.sv"                         
    dict set design_files "qsys_top_altera_merlin_demultiplexer_1921_ug4puiy.sv"                               "$QSYS_SIMDIR/../altera_merlin_demultiplexer_1921/sim/qsys_top_altera_merlin_demultiplexer_1921_ug4puiy.sv"                             
    dict set design_files "qsys_top_altera_merlin_demultiplexer_1921_ieuwgoi.sv"                               "$QSYS_SIMDIR/../altera_merlin_demultiplexer_1921/sim/qsys_top_altera_merlin_demultiplexer_1921_ieuwgoi.sv"                             
    dict set design_files "qsys_top_altera_merlin_multiplexer_1922_6ealezi.sv"                                 "$QSYS_SIMDIR/../altera_merlin_multiplexer_1922/sim/qsys_top_altera_merlin_multiplexer_1922_6ealezi.sv"                                 
    dict set design_files "altera_merlin_arbitrator.sv"                                                        "$QSYS_SIMDIR/../altera_merlin_multiplexer_1922/sim/altera_merlin_arbitrator.sv"                                                        
    dict set design_files "qsys_top_altera_merlin_multiplexer_1922_lv5gxfa.sv"                                 "$QSYS_SIMDIR/../altera_merlin_multiplexer_1922/sim/qsys_top_altera_merlin_multiplexer_1922_lv5gxfa.sv"                                 
    dict set design_files "altera_merlin_arbitrator.sv"                                                        "$QSYS_SIMDIR/../altera_merlin_multiplexer_1922/sim/altera_merlin_arbitrator.sv"                                                        
    dict set design_files "qsys_top_altera_merlin_demultiplexer_1921_gq7ft5i.sv"                               "$QSYS_SIMDIR/../altera_merlin_demultiplexer_1921/sim/qsys_top_altera_merlin_demultiplexer_1921_gq7ft5i.sv"                             
    dict set design_files "qsys_top_altera_merlin_demultiplexer_1921_h5fh4xa.sv"                               "$QSYS_SIMDIR/../altera_merlin_demultiplexer_1921/sim/qsys_top_altera_merlin_demultiplexer_1921_h5fh4xa.sv"                             
    dict set design_files "qsys_top_altera_merlin_multiplexer_1922_bwmblcq.sv"                                 "$QSYS_SIMDIR/../altera_merlin_multiplexer_1922/sim/qsys_top_altera_merlin_multiplexer_1922_bwmblcq.sv"                                 
    dict set design_files "altera_merlin_arbitrator.sv"                                                        "$QSYS_SIMDIR/../altera_merlin_multiplexer_1922/sim/altera_merlin_arbitrator.sv"                                                        
    dict set design_files "qsys_top_altera_merlin_multiplexer_1922_humqmaa.sv"                                 "$QSYS_SIMDIR/../altera_merlin_multiplexer_1922/sim/qsys_top_altera_merlin_multiplexer_1922_humqmaa.sv"                                 
    dict set design_files "altera_merlin_arbitrator.sv"                                                        "$QSYS_SIMDIR/../altera_merlin_multiplexer_1922/sim/altera_merlin_arbitrator.sv"                                                        
    dict set design_files "qsys_top_altera_mm_interconnect_1920_fimi64y.v"                                     "$QSYS_SIMDIR/../altera_mm_interconnect_1920/sim/qsys_top_altera_mm_interconnect_1920_fimi64y.v"                                        
    dict set design_files "qsys_top_altera_irq_mapper_2001_ghcid5i.sv"                                         "$QSYS_SIMDIR/../altera_irq_mapper_2001/sim/qsys_top_altera_irq_mapper_2001_ghcid5i.sv"                                                 
    dict set design_files "altera_reset_controller.v"                                                          "$QSYS_SIMDIR/../altera_reset_controller_1922/sim/altera_reset_controller.v"                                                            
    dict set design_files "altera_reset_synchronizer.v"                                                        "$QSYS_SIMDIR/../altera_reset_controller_1922/sim/altera_reset_synchronizer.v"                                                          
    dict set design_files "qsys_top.v"                                                                         "$QSYS_SIMDIR/qsys_top.v"                                                                                                               
    return $design_files
  }
  
  proc get_elab_options {SIMULATOR_TOOL_BITNESS} {
    set ELAB_OPTIONS ""
    append ELAB_OPTIONS [qsys_top_s10_user_rst_clkgate_0::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [qsys_top_sysid_qsys_0::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [qsys_top_jtag_uart_0::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [qsys_top_iopll_0::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [qsys_top_intel_onchip_memory_0::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [qsys_top_pio_0::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [qsys_top_clock_in::get_elab_options $SIMULATOR_TOOL_BITNESS]
    append ELAB_OPTIONS [qsys_top_intel_niosv_m_0::get_elab_options $SIMULATOR_TOOL_BITNESS]
    if ![ string match "bit_64" $SIMULATOR_TOOL_BITNESS ] {
    } else {
    }
    return $ELAB_OPTIONS
  }
  
  
  proc get_sim_options {SIMULATOR_TOOL_BITNESS} {
    set SIM_OPTIONS ""
    append SIM_OPTIONS [qsys_top_s10_user_rst_clkgate_0::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [qsys_top_sysid_qsys_0::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [qsys_top_jtag_uart_0::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [qsys_top_iopll_0::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [qsys_top_intel_onchip_memory_0::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [qsys_top_pio_0::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [qsys_top_clock_in::get_sim_options $SIMULATOR_TOOL_BITNESS]
    append SIM_OPTIONS [qsys_top_intel_niosv_m_0::get_sim_options $SIMULATOR_TOOL_BITNESS]
    if ![ string match "bit_64" $SIMULATOR_TOOL_BITNESS ] {
    } else {
    }
    return $SIM_OPTIONS
  }
  
  
  proc get_env_variables {SIMULATOR_TOOL_BITNESS} {
    set ENV_VARIABLES [dict create]
    set LD_LIBRARY_PATH [dict create]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [qsys_top_s10_user_rst_clkgate_0::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [qsys_top_sysid_qsys_0::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [qsys_top_jtag_uart_0::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [qsys_top_iopll_0::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [qsys_top_intel_onchip_memory_0::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [qsys_top_pio_0::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [qsys_top_clock_in::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [qsys_top_intel_niosv_m_0::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
    dict set ENV_VARIABLES "LD_LIBRARY_PATH" $LD_LIBRARY_PATH
    if ![ string match "bit_64" $SIMULATOR_TOOL_BITNESS ] {
    } else {
    }
    return $ENV_VARIABLES
  }
  
  
  proc get_dpi_libraries {QSYS_SIMDIR} {
    set libraries [dict create]
    set libraries [dict merge $libraries [qsys_top_s10_user_rst_clkgate_0::get_dpi_libraries "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_s10_user_rst_clkgate_0/sim/"]]
    set libraries [dict merge $libraries [qsys_top_sysid_qsys_0::get_dpi_libraries "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_sysid_qsys_0/sim/"]]
    set libraries [dict merge $libraries [qsys_top_jtag_uart_0::get_dpi_libraries "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_jtag_uart_0/sim/"]]
    set libraries [dict merge $libraries [qsys_top_iopll_0::get_dpi_libraries "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_iopll_0/sim/"]]
    set libraries [dict merge $libraries [qsys_top_intel_onchip_memory_0::get_dpi_libraries "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_intel_onchip_memory_0/sim/"]]
    set libraries [dict merge $libraries [qsys_top_pio_0::get_dpi_libraries "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_pio_0/sim/"]]
    set libraries [dict merge $libraries [qsys_top_clock_in::get_dpi_libraries "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_clock_in/sim/"]]
    set libraries [dict merge $libraries [qsys_top_intel_niosv_m_0::get_dpi_libraries "$QSYS_SIMDIR/../../ip/qsys_top/qsys_top_intel_niosv_m_0/sim/"]]
    
    return $libraries
  }
  
}
