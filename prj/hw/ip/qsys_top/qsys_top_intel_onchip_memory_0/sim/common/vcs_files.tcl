
namespace eval qsys_top_intel_onchip_memory_0 {
  proc get_memory_files {QSYS_SIMDIR} {
    set memory_files [list]
    return $memory_files
  }
  
  proc get_common_design_files {QSYS_SIMDIR} {
    set design_files [dict create]
    return $design_files
  }
  
  proc get_design_files {QSYS_SIMDIR} {
    set design_files [dict create]
    dict set design_files "qsys_top_intel_onchip_memory_0_intel_onchip_memory_147_hqcwqki.sv"                      "$QSYS_SIMDIR/../intel_onchip_memory_147/sim/qsys_top_intel_onchip_memory_0_intel_onchip_memory_147_hqcwqki.sv"                     
    dict set design_files "qsys_top_intel_onchip_memory_0_intel_onchip_memory_147_hqcwqki_axi_bursting_adapter.sv" "$QSYS_SIMDIR/../intel_onchip_memory_147/sim/qsys_top_intel_onchip_memory_0_intel_onchip_memory_147_hqcwqki_axi_bursting_adapter.sv"
    dict set design_files "qsys_top_intel_onchip_memory_0.v"                                                       "$QSYS_SIMDIR/qsys_top_intel_onchip_memory_0.v"                                                                                     
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
