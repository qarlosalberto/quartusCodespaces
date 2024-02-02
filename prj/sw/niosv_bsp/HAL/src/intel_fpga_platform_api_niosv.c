#include "intel_fpga_platform_api.h"
#include "sys/intel_fpga_api_cmn_dfl.h"
#include "sys/intel_fpga_api_cmn_inf.h"

#if INTEL_FPGA_USE_DFL_WALKER == 1

static uint64_t niosv_dfl_base_addr_decoder(uint64_t base_addr)
{
    uint64_t ret = base_addr;

    return ret;
}


bool fpga_platform_init(unsigned int, const char *[])
{
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wint-to-pointer-cast"
    common_dfl_scan_multi_interfaces((void *)INTEL_FPGA_DFL_START_ADDRESS, niosv_dfl_base_addr_decoder);
#pragma GCC diagnostic pop

    return true;
}

void fpga_platform_cleanup()
{
    if (common_fpga_interface_info_vec_size() > 0)
    {
        common_fpga_interface_info_vec_resize(0);
    }
}

#endif
