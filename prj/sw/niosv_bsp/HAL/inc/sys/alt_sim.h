#ifndef __ALT_SIM_H__
#define __ALT_SIM_H__

/******************************************************************************
*                                                                             *
* License Agreement                                                           *
*                                                                             *
* Copyright (c) 2007      Altera Corporation, San Jose, California, USA.      *
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
******************************************************************************/
#include "system.h"
#include "alt_types.h"

/* 
 * Instructions that might mean something special to a simulator. 
 * These have no special effect on real hardware (they are just nops).
 */
#define ALT_SIM_FAIL() \
    do { __asm volatile ("sltiu x0, x0, 0x7c1"); } while (0)

#define ALT_SIM_PASS() \
    do { __asm volatile ("sltiu x0, x0, 0x7c2"); } while (0)

#define ALT_SIM_IN_TOP_OF_HOT_LOOP() \
    do { __asm volatile ("sltiu x0, x0, 0x7c3"); } while (0)

/*
 * Routine called on exit.
 * TODO: Add support for GMON/gprof.
 */
static ALT_INLINE ALT_ALWAYS_INLINE void alt_sim_halt(int exit_code)
{
  register int a0 asm ("a0") = exit_code;

#if defined(ALT_CPU_HAS_DEBUG_STUB) && (defined(ALT_BREAK_ON_EXIT) || defined(ALT_PROVIDE_GMON))
  register int a1 asm ("a1") = (1 << 2);

  if (a0) {
    ALT_SIM_FAIL();
  } else {
    ALT_SIM_PASS();
  }

  __asm__ volatile (
    "\n0:\n\t"
    "addi %0,%0, -1\n\t"
    "bgtz %0,0b" 
    : 
    : "r" (ALT_CPU_FREQ/100) ); /* Delay for >30ms */

  __asm__ volatile (
    "ebreak" 
    : 
    : "r"(a0), "r"(a1));

#else /* !DEBUG_STUB */
  if (a0) {
    ALT_SIM_FAIL();
  } else {
    ALT_SIM_PASS();
  }
#endif /* DEBUG_STUB */
}

#define ALT_SIM_HALT(exit_code) \
  alt_sim_halt(exit_code)

#endif /* __ALT_SIM_H__ */
