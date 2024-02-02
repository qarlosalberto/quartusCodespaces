
namespace eval qsys_top_intel_niosv_m_0 {
  proc get_design_libraries {} {
    set libraries [dict create]
    dict set libraries altera_reset_controller_1922 1
    dict set libraries intel_niosv_m_unit_2210      1
    dict set libraries intel_niosv_timer_msip_120   1
    dict set libraries intel_niosv_dbg_mod_210      1
    dict set libraries altera_irq_mapper_2001       1
    dict set libraries intel_niosv_m_2310           1
    dict set libraries qsys_top_intel_niosv_m_0     1
    return $libraries
  }
  
  proc get_memory_files {QSYS_SIMDIR} {
    set memory_files [list]
    lappend memory_files "[normalize_path "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/csr_mlab.mif"]"
    lappend memory_files "[normalize_path "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/debug_rom.mif"]"
    return $memory_files
  }
  
  proc get_common_design_files {USER_DEFINED_COMPILE_OPTIONS USER_DEFINED_VERILOG_COMPILE_OPTIONS USER_DEFINED_VHDL_COMPILE_OPTIONS QSYS_SIMDIR} {
    set design_files [dict create]
    return $design_files
  }
  
  proc get_design_files {USER_DEFINED_COMPILE_OPTIONS USER_DEFINED_VERILOG_COMPILE_OPTIONS USER_DEFINED_VHDL_COMPILE_OPTIONS QSYS_SIMDIR} {
    set design_files [list]
    lappend design_files "vlog -v2k5 $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../altera_reset_controller_1922/sim/altera_reset_controller.v"]\"  -work altera_reset_controller_1922"                
    lappend design_files "vlog -v2k5 $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../altera_reset_controller_1922/sim/altera_reset_synchronizer.v"]\"  -work altera_reset_controller_1922"              
    lappend design_files "vlog -v2k5 $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/niosv_reset_controller.v"]\"  -work intel_niosv_m_unit_2210"                           
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/aldec/niosv_opcode_def.sv"]\"  -work intel_niosv_m_unit_2210"                               
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/aldec/niosv_mem_op_state.sv"]\"  -work intel_niosv_m_unit_2210"                             
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/aldec/niosv_ram.sv"]\"  -work intel_niosv_m_unit_2210"                                      
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/aldec/niosv_reg_file.sv"]\"  -work intel_niosv_m_unit_2210"                                 
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/aldec/niosv_csr.sv"]\"  -work intel_niosv_m_unit_2210"                                      
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/aldec/niosv_interrupt_handler.sv"]\"  -work intel_niosv_m_unit_2210"                        
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/aldec/niosv_instr_buffer.sv"]\"  -work intel_niosv_m_unit_2210"                             
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/aldec/niosv_bus_req.sv"]\"  -work intel_niosv_m_unit_2210"                                  
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/aldec/niosv_shift.sv"]\"  -work intel_niosv_m_unit_2210"                                    
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/aldec/niosv_c_alu.sv"]\"  -work intel_niosv_m_unit_2210"                                    
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/aldec/niosv_c_decoder.sv"]\"  -work intel_niosv_m_unit_2210"                                
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/aldec/niosv_c_lsu.sv"]\"  -work intel_niosv_m_unit_2210"                                    
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/aldec/niosv_c_core.sv"]\"  -work intel_niosv_m_unit_2210"                                   
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/aldec/niosv_c_csr.sv"]\"  -work intel_niosv_m_unit_2210"                                    
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/aldec/niosv_m_top.sv"]\"  -work intel_niosv_m_unit_2210"                                    
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/aldec/niosv_m_alu.sv"]\"  -work intel_niosv_m_unit_2210"                                    
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/aldec/niosv_m_decoder.sv"]\"  -work intel_niosv_m_unit_2210"                                
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/aldec/niosv_m_lsu.sv"]\"  -work intel_niosv_m_unit_2210"                                    
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/aldec/niosv_m_core.sv"]\"  -work intel_niosv_m_unit_2210"                                   
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/aldec/niosv_m_instr_prefetch.sv"]\"  -work intel_niosv_m_unit_2210"                         
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_m_unit_2210/sim/aldec/niosv_m_shift_module.sv"]\"  -work intel_niosv_m_unit_2210"                           
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_timer_msip_120/sim/aldec/niosv_timer_msip.sv"]\"  -work intel_niosv_timer_msip_120"                         
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/aldec/niosv_dm_def.sv"]\"  -work intel_niosv_dbg_mod_210"                                   
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/aldec/niosv_ram.sv"]\"  -work intel_niosv_dbg_mod_210"                                      
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/aldec/niosv_dm_jtag2mm.sv"]\"  -work intel_niosv_dbg_mod_210"                               
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/aldec/niosv_dm_top.sv"]\"  -work intel_niosv_dbg_mod_210"                                   
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/aldec/niosv_debug_module.sv"]\"  -work intel_niosv_dbg_mod_210"                             
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/altera_std_synchronizer_bundle.v"]\"  -work intel_niosv_dbg_mod_210"                        
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/altera_std_synchronizer_nocut.v"]\"  -work intel_niosv_dbg_mod_210"                         
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/altera_std_synchronizer.v"]\"  -work intel_niosv_dbg_mod_210"                               
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/altera_avalon_st_clock_crosser.v"]\"  -work intel_niosv_dbg_mod_210"                        
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/altera_avalon_st_handshake_clock_crosser.v"]\"  -work intel_niosv_dbg_mod_210"              
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/altera_avalon_st_pipeline_base.v"]\"  -work intel_niosv_dbg_mod_210"                        
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/altera_avalon_st_pipeline_stage.sv"]\"  -work intel_niosv_dbg_mod_210"                      
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/altera_reset_synchronizer.v"]\"  -work intel_niosv_dbg_mod_210"                             
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_dbg_mod_210/sim/altera_reset_controller.v"]\"  -work intel_niosv_dbg_mod_210"                               
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../altera_irq_mapper_2001/sim/qsys_top_intel_niosv_m_0_altera_irq_mapper_2001_3jqx4ly.sv"]\"  -work altera_irq_mapper_2001"
    lappend design_files "vlog -v2k5 $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_niosv_m_2310/sim/qsys_top_intel_niosv_m_0_intel_niosv_m_2310_dxns7li.v"]\"  -work intel_niosv_m_2310"        
    lappend design_files "vlog -v2k5 $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/qsys_top_intel_niosv_m_0.v"]\"  -work qsys_top_intel_niosv_m_0"                                                       
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
  
  
  proc normalize_path {FILEPATH} {
      if {[catch { package require fileutil } err]} { 
          return $FILEPATH 
      } 
      set path [fileutil::lexnormalize [file join [pwd] $FILEPATH]]  
      if {[file pathtype $FILEPATH] eq "relative"} { 
          set path [fileutil::relative [pwd] $path] 
      } 
      return $path 
  } 
  proc get_dpi_libraries {QSYS_SIMDIR} {
    set libraries [dict create]
    
    return $libraries
  }
  
}
