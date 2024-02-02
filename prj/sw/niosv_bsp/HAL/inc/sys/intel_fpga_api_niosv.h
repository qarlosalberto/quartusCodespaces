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

#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include "io.h"
#include "alt_irq.h"
#include "priv/alt_irq_table.h"
#include "intel_fpga_platform_niosv.h"
#include "intel_fpga_api_cmn_inf.h"

#ifdef __cplusplus
extern "C" {
#endif

static inline uint8_t fpga_read_8(FPGA_MMIO_INTERFACE_HANDLE handle, uint32_t offset)
{
    return IORD_8DIRECT(handle, offset);
}

static inline void fpga_write_8(FPGA_MMIO_INTERFACE_HANDLE handle, uint32_t offset, uint8_t value)
{
    IOWR_8DIRECT(handle, offset ,value);
}

static inline uint16_t fpga_read_16(FPGA_MMIO_INTERFACE_HANDLE handle, uint32_t offset)
{
    return IORD_16DIRECT(handle, offset);
}

static inline void fpga_write_16(FPGA_MMIO_INTERFACE_HANDLE handle, uint32_t offset, uint16_t value)
{
    IOWR_16DIRECT(handle, offset ,value);
}

static inline uint32_t fpga_read_32(FPGA_MMIO_INTERFACE_HANDLE handle, uint32_t offset)
{
    return IORD_32DIRECT(handle, offset);
}

static inline void fpga_write_32(FPGA_MMIO_INTERFACE_HANDLE handle, uint32_t offset, uint32_t value)
{
    IOWR_32DIRECT(handle, offset ,value);
}

static inline uint64_t fpga_read_64(FPGA_MMIO_INTERFACE_HANDLE handle, uint32_t offset)
{
   uint32_t value[64/32];

   value[0] = IORD_32DIRECT(handle, offset);
   value[1] = IORD_32DIRECT(handle, offset+4);
   return *((uint64_t *)value);
}

static inline void fpga_write_64(FPGA_MMIO_INTERFACE_HANDLE handle, uint32_t offset, uint64_t value)
{
   IOWR_32DIRECT(handle, offset ,  ((uint32_t)value));
   IOWR_32DIRECT(handle, offset+4 ,((uint32_t)(value>>32)));
}

static inline void fpga_read_512(FPGA_MMIO_INTERFACE_HANDLE handle, uint32_t offset, uint8_t *ptr)
{
   int i;
   uint32_t *ptr_32;

   ptr_32 = (uint32_t *)ptr;

   for(i = 0; i < (512/32); ++i)
   {
     *ptr_32 = IORD_32DIRECT(handle, offset);
     ++ptr_32;
     offset += 4;
   }
}

static inline void fpga_write_512(FPGA_MMIO_INTERFACE_HANDLE handle, uint32_t offset, uint8_t *ptr)
{
   int     i;
   uint32_t *ptr_32;
  
   ptr_32 = (uint32_t *)ptr;

   for(i = 0; i < (512/32); ++i)
   {
      IOWR_32DIRECT(handle, offset ,*ptr_32);
      ++ptr_32;
      offset += 4;
   }
}


typedef void (*FPGA_ISR) ( void *isr_context );

//Interrupt controller ID is always zero
static inline int fpga_enable_interrupt(FPGA_INTERRUPT_HANDLE handle)
{
  int ret;
  //Check if ISR has been registered or not.Return -1 if ISR not registered
  if(alt_irq[handle].handler == NULL){
    ret = -1;
  }
  else{
    //If ISR enable succeeds, return 0
    ret = alt_ic_irq_enable(0, handle);
    //as per protodriver guidelines, hardware fault will return -2
    if (ret < 0){
      ret = -2;
    }
  }
  return ret;
}


//Interrupt controller ID is always zero
static inline int fpga_disable_interrupt(FPGA_INTERRUPT_HANDLE handle)
{
  int ret;
  //Check if ISR has been registered or not.Return -1 if ISR not registered
  if(alt_irq[handle].handler == NULL){
    ret = -1;
  }
  else{
    if( alt_ic_irq_enabled(0,handle) ){
      //If ISR disable succeeds, return 0
      ret = alt_ic_irq_disable(0, handle);
      //as per protodriver guidelines, hardware fault will return -2
      if (ret < 0){
        ret = -2;
      }
    }
    else{
      //Return -3 if irq not enabled
      ret = -3;
    }
  }
  return ret;
}

static inline int fpga_register_isr(FPGA_INTERRUPT_HANDLE handle, FPGA_ISR isr, void *isr_context)
{
  int ret = 0;
  int rc;
  
  //Check if ISR has been registered or not.Return 1 if ISR has been registered
  //NOTE: This return value may be overwriiten unpon unsuccessful isr registration.
  if(alt_irq[handle].handler != NULL && isr != NULL){
    ret = 1;
  }
  
  rc = alt_ic_isr_register(0, handle, isr, isr_context, NULL);
  if (rc != 0){
    const int MSB_POS = sizeof(int)*8-1;
    
    ret = rc | (1 << MSB_POS);  // Make return value into a negative value while maintaining some return value information.
  }
  
  return ret;
}

static inline void *fpga_malloc(FPGA_MMIO_INTERFACE_HANDLE, uint32_t size)
{
  return (void *)malloc(size);
}

static inline void fpga_free(FPGA_MMIO_INTERFACE_HANDLE, void *address)
{
  free(address);
}

static inline FPGA_PLATFORM_PHYSICAL_MEM_ADDR_TYPE fpga_get_physical_address(void *address)
{
  return address;
}

int fpga_msg_printf(FPGA_MSG_PRINTF_TYPE type, const char * format, ... );
void fpga_throw_runtime_exception(const char *function, const char *file, int lineno, const char * format, ... );


#ifdef __cplusplus
}
#endif
