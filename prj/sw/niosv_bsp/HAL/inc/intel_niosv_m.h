/******************************************************************************
*                                                                             *
* License Agreement                                                           *
*                                                                             *
* Copyright (c) 2008 Altera Corporation, San Jose, California, USA.           *
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
#ifndef __INTEL_NIOSV_M_H__
#define __INTEL_NIOSV_M_H__

#include "string.h"

#include "alt_types.h"
#include "sys/alt_alarm.h"

#include "system.h"

/* Most of the functionality is contained here as it is variant agnostic. */
#include "intel_niosv.h"

/*
 * This header provides processor specific macros for accessing Intel Nios V/m.
 */

#ifdef __cplusplus
extern "C"
{
#endif /* __cplusplus */

// System initialization macros
#define INTEL_NIOSV_M_INSTANCE(name, dev) extern int alt_no_storage

// This is what's called from alt_sys_init.v
#define INTEL_NIOSV_M_INIT(name, dev)                                        \
  if (strcmp(ALT_MKSTR_EXPAND(name), ALT_MKSTR_EXPAND(ALT_SYS_CLK)) == 0)    \
  {                                                                          \
      alt_sysclk_init(ALT_CPU_TICKS_PER_SEC);                                \
      alt_niosv_register_mtimecmp_interrupt_handle(alt_niosv_timer_sc_isr);  \
      alt_niosv_mtimecmp_interrupt_init();                                   \
      alt_niosv_timer_sc_isr(0, 0, 0);                                       \
  }                                                                          \

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* __INTEL_NIOSV_M_H__ */
