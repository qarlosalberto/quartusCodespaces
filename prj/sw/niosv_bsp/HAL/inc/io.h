#ifndef __IO_H__
#define __IO_H__

/******************************************************************************
*                                                                             *
* License Agreement                                                           *
*                                                                             *
* Copyright (c) 2003 Altera Corporation, San Jose, California, USA.           *
* All rights reserved.                                                        *
*                                                                             *
* Permission is hereby granted, free of charge, to any person obtaining a     *
* copy of this software and associated documentation files (the "Software"),  *
* to deal in the Software without restriction, including without limitation   *
* the rights to use, copy, modify, merge, publish, distribute, sublicense,    *
* and/or sell copies of the Software, and to permit persons to whom the       *
* Software is furnished to do so, subject to the following conditions:        *
*                                                                             *
* The above copyright notice and this permission notice shall be included in  *
* all copies or substantial portions of the Software.                         *
*                                                                             *
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  *
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    *
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE *
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      *
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     *
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         *
* DEALINGS IN THE SOFTWARE.                                                   *
*                                                                             *
* This agreement shall be governed in all respects by the laws of the State   *
* of California and by the laws of the United States of America.              *
*                                                                             *
* Altera does not recommend, suggest or require that this reference design    *
* file be used in conjunction or combination with any other product.          *
******************************************************************************/

/* IO Header file for Nios V Toolchain */

#include "alt_types.h"
#ifdef __cplusplus
extern "C"
{
#endif /* __cplusplus */

#ifndef SYSTEM_BUS_WIDTH
#define SYSTEM_BUS_WIDTH 32
#endif

/* Performs lb instruction and returns the read DATA. BASE and OFFSET are byte-aligned */
#define LBIO(BASE, OFFSET) ({                   \
    signed char __tmpData;                      \
    asm volatile (                              \
      "lb %[DATAReg], 0(%[addrReg])"            \
      : [DATAReg] "=r"(__tmpData)               \
      : [addrReg] "r"(BASE),[imm] "i"(OFFSET)   \
      :                                         \
    );                                          \
    __tmpData; })

/* Performs lh instruction and returns the read DATA. BASE and OFFSET are byte-aligned */
#define LHIO(BASE, OFFSET) ({                   \
    signed short __tmpData;                     \
    asm volatile (                              \
      "lh %[DATAReg], 0(%[addrReg])"            \
      : [DATAReg] "=r"(__tmpData)               \
      : [addrReg] "r"(BASE),[imm] "i"(OFFSET)   \
      :                                         \
    );                                          \
    __tmpData; })

/* Performs lw instruction and returns the read DATA. BASE and OFFSET are byte-aligned */
#define LWIO(BASE, OFFSET) ({                   \
    unsigned int __tmpData;                     \
    asm volatile (                              \
      "lw %[DATAReg], 0(%[addrReg])"            \
      : [DATAReg] "=r"(__tmpData)               \
      : [addrReg] "r"(BASE), [imm] "i"(OFFSET)  \
      :                                         \
    );                                          \
    __tmpData; })

/* Performs lbu instruction and returns the read DATA. BASE and OFFSET are byte-aligned */
#define LBUIO(BASE, OFFSET) ({                  \
    unsigned char __tmpData;                    \
    asm volatile (                              \
      "lbu %[DATAReg], 0(%[addrReg])"           \
      : [DATAReg] "=r"(__tmpData)               \
      : [addrReg] "r"(BASE), [imm] "i"(OFFSET)  \
      :                                         \
    );                                          \
    __tmpData; })

/* Performs lhu instruction and returns the read DATA. BASE and OFFSET are byte-aligned */
#define LHUIO(BASE, OFFSET) ({                  \
    unsigned short __tmpData;                   \
    asm volatile (                              \
      "lhu %[DATAReg], 0(%[addrReg])"           \
      : [DATAReg] "=r"(__tmpData)               \
      : [addrReg] "r"(BASE), [imm] "i"(OFFSET)  \
      :                                         \
    );                                          \
    __tmpData; })

/* Performs sbio instruction. BASE and OFFSET are byte-aligned */
#define SBIO(BASE, OFFSET, DATA) do {                   \
    unsigned char __tmpData = (DATA);                   \
    asm volatile (                                      \
      "sb %[DATAReg], 0(%[addrReg])\n\t"                \
      :                                                 \
      : [addrReg] "r"(BASE), [imm] "i"(OFFSET), [DATAReg] "r"(__tmpData)  \
      : "memory"                            \
    );                                                  \
    } while (0)

/* Performs shio instruction. BASE and OFFSET are byte-aligned */
#define SHIO(BASE, OFFSET, DATA) do {                   \
    unsigned short __tmpData = (DATA);                  \
    asm volatile (                                      \
      "sh %[DATAReg], 0(%[addrReg])\n\t"                \
      :                                                 \
      : [addrReg] "r"(BASE), [imm] "i"(OFFSET), [DATAReg] "r"(__tmpData)  \
      : "memory"                                        \
    );                                                  \
    } while (0)

/* Performs swio instruction. BASE and OFFSET are byte-aligned */
#define SWIO(BASE, OFFSET, DATA) do {                   \
    unsigned int __tmpData = (DATA);                    \
    asm volatile (                                      \
      "sw %[DATAReg], 0(%[addrReg])\n\t"                \
      :                                                 \
      : [addrReg] "r"(BASE), [imm] "i"(OFFSET), [DATAReg] "r"(__tmpData)  \
      : "memory"                                        \
    );                                                  \
    } while (0)

/* 
 * Dynamic bus access functions 
 */

#define __IO_CALC_ADDRESS_DYNAMIC(BASE, OFFSET) \
  ((void *)(((alt_u8*)BASE) + (OFFSET)))

/* Don't use OFFSET of load/store IO macros in case it exceeds the 12-bit imm range. */
#define IORD_32DIRECT(BASE, OFFSET) \
  LWIO(__IO_CALC_ADDRESS_DYNAMIC((BASE), (OFFSET)), 0)
#define IORD_16DIRECT(BASE, OFFSET) \
  LHUIO(__IO_CALC_ADDRESS_DYNAMIC((BASE), (OFFSET)), 0)
#define IORD_8DIRECT(BASE, OFFSET) \
  LBUIO(__IO_CALC_ADDRESS_DYNAMIC((BASE), (OFFSET)), 0)

#define IOWR_32DIRECT(BASE, OFFSET, DATA) \
  SWIO(__IO_CALC_ADDRESS_DYNAMIC((BASE), (OFFSET)), 0, (DATA))
#define IOWR_16DIRECT(BASE, OFFSET, DATA) \
  SHIO(__IO_CALC_ADDRESS_DYNAMIC((BASE), (OFFSET)), 0, (DATA))
#define IOWR_8DIRECT(BASE, OFFSET, DATA) \
  SBIO(__IO_CALC_ADDRESS_DYNAMIC((BASE), (OFFSET)), 0, (DATA))

/* 
 * Native bus access functions 
 */
#define __IO_CALC_ADDRESS_NATIVE(BASE, REGNUM) \
  ((void *)(((alt_u8*)BASE) + ((REGNUM) * (SYSTEM_BUS_WIDTH/8))))

/* Don't use OFFSET of load/store IO macros in case it exceeds the 12-bit imm range. */
#define IORD(BASE, REGNUM) \
  LWIO(__IO_CALC_ADDRESS_NATIVE((BASE), (REGNUM)), 0)
#define IOWR(BASE, REGNUM, DATA) \
  SWIO(__IO_CALC_ADDRESS_NATIVE((BASE), (REGNUM)), 0, (DATA))

#ifdef __cplusplus
}
#endif

#endif /* __IO_H__ */
