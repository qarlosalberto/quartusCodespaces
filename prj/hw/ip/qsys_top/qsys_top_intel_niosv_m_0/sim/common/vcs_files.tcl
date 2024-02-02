
namespace eval qsys_top_intel_niosv_m_0 {
  proc get_memory_files {QSYS_SIMDIR} {
    set memory_files [list]
    lappend memory_files "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/csr_mlab.mif"
    lappend memory_files "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/debug_rom.mif"
    return $memory_files
  }
  
  proc get_common_design_files {QSYS_SIMDIR} {
    set design_files [dict create]
    return $design_files
  }
  
  proc get_design_files {QSYS_SIMDIR} {
    set design_files [dict create]
    dict set design_files "altera_reset_controller.v"                                  "$QSYS_SIMDIR/../altera_reset_controller_1922/sim/altera_reset_controller.v"                           
    dict set design_files "altera_reset_synchronizer.v"                                "$QSYS_SIMDIR/../altera_reset_controller_1922/sim/altera_reset_synchronizer.v"                         
    dict set design_files "niosv_reset_controller.v"                                   "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/niosv_reset_controller.v"                                 
    dict set design_files "niosv_opcode_def.sv"                                        "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/synopsys/niosv_opcode_def.sv"                             
    dict set design_files "niosv_mem_op_state.sv"                                      "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/synopsys/niosv_mem_op_state.sv"                           
    dict set design_files "niosv_ram.sv"                                               "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/synopsys/niosv_ram.sv"                                    
    dict set design_files "niosv_reg_file.sv"                                          "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/synopsys/niosv_reg_file.sv"                               
    dict set design_files "niosv_csr.sv"                                               "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/synopsys/niosv_csr.sv"                                    
    dict set design_files "niosv_interrupt_handler.sv"                                 "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/synopsys/niosv_interrupt_handler.sv"                      
    dict set design_files "niosv_instr_buffer.sv"                                      "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/synopsys/niosv_instr_buffer.sv"                           
    dict set design_files "niosv_bus_req.sv"                                           "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/synopsys/niosv_bus_req.sv"                                
    dict set design_files "niosv_shift.sv"                                             "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/synopsys/niosv_shift.sv"                                  
    dict set design_files "niosv_c_alu.sv"                                             "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/synopsys/niosv_c_alu.sv"                                  
    dict set design_files "niosv_c_decoder.sv"                                         "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/synopsys/niosv_c_decoder.sv"                              
    dict set design_files "niosv_c_lsu.sv"                                             "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/synopsys/niosv_c_lsu.sv"                                  
    dict set design_files "niosv_c_core.sv"                                            "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/synopsys/niosv_c_core.sv"                                 
    dict set design_files "niosv_c_csr.sv"                                             "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/synopsys/niosv_c_csr.sv"                                  
    dict set design_files "niosv_m_top.sv"                                             "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/synopsys/niosv_m_top.sv"                                  
    dict set design_files "niosv_m_alu.sv"                                             "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/synopsys/niosv_m_alu.sv"                                  
    dict set design_files "niosv_m_decoder.sv"                                         "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/synopsys/niosv_m_decoder.sv"                              
    dict set design_files "niosv_m_lsu.sv"                                             "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/synopsys/niosv_m_lsu.sv"                                  
    dict set design_files "niosv_m_core.sv"                                            "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/synopsys/niosv_m_core.sv"                                 
    dict set design_files "niosv_m_instr_prefetch.sv"                                  "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/synopsys/niosv_m_instr_prefetch.sv"                       
    dict set design_files "niosv_m_shift_module.sv"                                    "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/synopsys/niosv_m_shift_module.sv"                         
    dict set design_files "niosv_timer_msip.sv"                                        "$QSYS_SIMDIR/../intel_niosv_timer_msip_120/sim/synopsys/niosv_timer_msip.sv"                          
    dict set design_files "niosv_dm_def.sv"                                            "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/synopsys/niosv_dm_def.sv"                                 
    dict set design_files "niosv_ram.sv"                                               "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/synopsys/niosv_ram.sv"                                    
    dict set design_files "niosv_dm_jtag2mm.sv"                                        "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/synopsys/niosv_dm_jtag2mm.sv"                             
    dict set design_files "niosv_dm_top.sv"                                            "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/synopsys/niosv_dm_top.sv"                                 
    dict set design_files "niosv_debug_module.sv"                                      "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/synopsys/niosv_debug_module.sv"                           
    dict set design_files "altera_std_synchronizer_bundle.v"                           "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/altera_std_synchronizer_bundle.v"                         
    dict set design_files "altera_std_synchronizer_nocut.v"                            "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/altera_std_synchronizer_nocut.v"                          
    dict set design_files "altera_std_synchronizer.v"                                  "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/altera_std_synchronizer.v"                                
    dict set design_files "altera_avalon_st_clock_crosser.v"                           "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/altera_avalon_st_clock_crosser.v"                         
    dict set design_files "altera_avalon_st_handshake_clock_crosser.v"                 "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/altera_avalon_st_handshake_clock_crosser.v"               
    dict set design_files "altera_avalon_st_pipeline_base.v"                           "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/altera_avalon_st_pipeline_base.v"                         
    dict set design_files "altera_avalon_st_pipeline_stage.sv"                         "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/altera_avalon_st_pipeline_stage.sv"                       
    dict set design_files "altera_reset_synchronizer.v"                                "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/altera_reset_synchronizer.v"                              
    dict set design_files "altera_reset_controller.v"                                  "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/altera_reset_controller.v"                                
    dict set design_files "qsys_top_intel_niosv_m_0_altera_irq_mapper_2001_3jqx4ly.sv" "$QSYS_SIMDIR/../altera_irq_mapper_2001/sim/qsys_top_intel_niosv_m_0_altera_irq_mapper_2001_3jqx4ly.sv"
    dict set design_files "qsys_top_intel_niosv_m_0_intel_niosv_m_2310_dxns7li.v"      "$QSYS_SIMDIR/../intel_niosv_m_2310/sim/qsys_top_intel_niosv_m_0_intel_niosv_m_2310_dxns7li.v"         
    dict set design_files "qsys_top_intel_niosv_m_0.v"                                 "$QSYS_SIMDIR/qsys_top_intel_niosv_m_0.v"                                                              
    return $design_files
  }
  
  proc get_elab_options {SIMULATOR_TOOL_BITNESS} {
    set ELAB_OPTIONS ""
    if ![ string match "bit_64" $SIMULATOR_TOOL_BITNESS ] {
    } else {
    }
    return $ELAB_OPTIONS
  }
  
  
  proc get_sim_options {SIMULATOR_TOOL_BITNESS} {
    set SIM_OPTIONS ""
    if ![ string match "bit_64" $SIMULATOR_TOOL_BITNESS ] {
    } else {
    }
    return $SIM_OPTIONS
  }
  
  
  proc get_env_variables {SIMULATOR_TOOL_BITNESS} {
    set ENV_VARIABLES [dict create]
    set LD_LIBRARY_PATH [dict create]
    dict set ENV_VARIABLES "LD_LIBRARY_PATH" $LD_LIBRARY_PATH
    if ![ string match "bit_64" $SIMULATOR_TOOL_BITNESS ] {
    } else {
    }
    return $ENV_VARIABLES
  }
  
  
  proc get_dpi_libraries {QSYS_SIMDIR} {
    set libraries [dict create]
    
    return $libraries
  }
  
}
