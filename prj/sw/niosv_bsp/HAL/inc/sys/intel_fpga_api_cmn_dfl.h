// Copyright(c) 2021, Intel Corporation
//
// Redistribution  and  use  in source  and  binary  forms,  with  or  without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of  source code  must retain the  above copyright notice,
//   this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
// * Neither the name  of Intel Corporation  nor the names of its contributors
//   may be used to  endorse or promote  products derived  from this  software
//   without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,  BUT NOT LIMITED TO,  THE
// IMPLIED WARRANTIES OF  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED.  IN NO EVENT  SHALL THE COPYRIGHT OWNER  OR CONTRIBUTORS BE
// LIABLE  FOR  ANY  DIRECT,  INDIRECT,  INCIDENTAL,  SPECIAL,  EXEMPLARY,  OR
// CONSEQUENTIAL  DAMAGES  (INCLUDING,  BUT  NOT LIMITED  TO,  PROCUREMENT  OF
// SUBSTITUTE GOODS OR SERVICES;  LOSS OF USE,  DATA, OR PROFITS;  OR BUSINESS
// INTERRUPTION)  HOWEVER CAUSED  AND ON ANY THEORY  OF LIABILITY,  WHETHER IN
// CONTRACT,  STRICT LIABILITY,  OR TORT  (INCLUDING NEGLIGENCE  OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,  EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#pragma once

#include "intel_fpga_api_cmn_msg.h"
#include "intel_fpga_api_cmn_inf.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef unsigned int FPGA_INTERFACE_INDEX;
typedef uint64_t (*FPGA_DFL_BASE_ADDR_DECODER)(uint64_t);

void common_dfl_scan_multi_interfaces(void *dfh_base_addr, FPGA_DFL_BASE_ADDR_DECODER base_addr_decoder);
void common_dfl_print_all_interfaces(FPGA_DFL_BASE_ADDR_DECODER base_addr_decoder);
void common_dfl_print_interface(FPGA_INTERFACE_INDEX index, FPGA_DFL_BASE_ADDR_DECODER base_addr_decoder);

#ifdef PROTODRV_COMMON_DFL_USE_CUSTOM_MMIO_READ_FUNC
#include "intel_fpga_platform_api_sim.h"
// Targeting simulation platform
static inline uint64_t common_dfl_read_64(void *begin_address, uint32_t offset)
{
   uint32_t value[64/32];
   value[0] = g_fpga_read_32_f(1, (uint64_t)begin_address + offset);
   value[1] = g_fpga_read_32_f(1, (uint64_t)begin_address + offset+4);
   return *((uint64_t *)value);
}
#else

static inline uint32_t common_dfl_read_32(void *begin_address, uint32_t offset)
{
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wpragmas"
#pragma GCC diagnostic ignored "-Wpointer-to-int-cast"
    if(((uint64_t)((volatile uint8_t *)begin_address + offset) & 0x3) != 0)
    {
        fpga_throw_runtime_exception(__FUNCTION__, __FILE__, __LINE__, "read address 0x%lX is not 32-bit aligned.", (uint64_t)((volatile uint8_t *)begin_address + offset));
    }

    return *((volatile uint32_t *)((volatile uint8_t *)begin_address + offset));
#pragma GCC diagnostic pop
}

static inline uint64_t common_dfl_read_64(void *begin_address, uint32_t offset)
{
#ifndef FPGA_PLATFORM_FORCE_64BIT_MMIO_EMULATION_WITH_32BIT
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wpragmas"
#pragma GCC diagnostic ignored "-Wpointer-to-int-cast"
    return *((volatile uint64_t *)((volatile uint8_t *)begin_address + offset));
#pragma GCC diagnostic pop
#else
    // This emulation is needed when Intel FPGA PCIe Memory Mapped Bridge IP is used to implement the PCIe function.
    // Little-endian system is assumed.
    uint64_t data = common_dfl_read_32(begin_address, offset);
    data |= (uint64_t)common_dfl_read_32(begin_address, offset + 4) << 32;

    return data;
#endif // FPGA_PLATFORM_FORCE_64BIT_MMIO_EMULATION_WITH_32BIT
}

#endif // PROTODRV_COMMON_DFL_USE_CUSTOM_MMIO_READ_FUNC

#ifdef __cplusplus
}
#endif