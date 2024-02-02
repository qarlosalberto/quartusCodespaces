/******************************************************************************
*                                                                             *
* License Agreement                                                           *
*                                                                             *
* Copyright (c) 2006 Altera Corporation, San Jose, California, USA.           *
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

/* Setup header files to work with assembler code. */
#define ALT_ASM_SRC

/* Debug logging facility */
#include "sys/alt_log_printf.h"

/* Default value is true. For older builds (mid 23.2 and earlier every CPU had CSR support */
#ifndef ALT_CPU_HAS_CSR_SUPPORT
    #define ALT_CPU_HAS_CSR_SUPPORT 1
#endif


/*************************************************************************\
|                                MACROS                                   |
\*************************************************************************/

/* Need to call alt_load() if any of these sections are being copied. */
#if defined(ALT_LOAD_COPY_RODATA) || defined(ALT_LOAD_COPY_RWDATA) || defined(ALT_LOAD_COPY_EXCEPTIONS)
#define CALL_ALT_LOAD
#endif

/*
 * When the legacy build tools define a macro called ALT_NO_BOOTLOADER,
 * it indicates that initialization code is allowed at the reset address.
 * The new build tools define a macro called ALT_ALLOW_CODE_AT_RESET for
 * the same purpose.
 */
#ifdef ALT_NO_BOOTLOADER
#define ALT_ALLOW_CODE_AT_RESET
#endif

/*************************************************************************\
|                         EXTERNAL REFERENCES                             |
\*************************************************************************/

/*
 * The entry point for user code is either "main" in hosted mode, or
 * "alt_main" in standalone mode. These are explicitly referenced here,
 * to ensure they are built into the executable. This allows the user
 * to build them into libraries, rather than supplying them in object
 * files at link time.
 */
    .globl main
    .globl alt_main


/*
 * Linker defined symbols used to initialize bss.
 */
.globl __bss_start
.globl __bss_end

/*************************************************************************\
|                         RESET SECTION (.entry)                          |
\*************************************************************************/
#if defined(ALT_ALLOW_CODE_AT_RESET) || defined(ALT_SIM_OPTIMIZE)
/*
 * This is the reset entry point for Nios V
 *
 * At reset, only the cache line which contain the reset vector is
 * initialized by the hardware. The code within the first cache line
 * initializes the remainder of the instruction cache.
 */

    .section .entry, "xa"
    .align 5

    .globl __reset
    .type __reset, @function
__reset:
/*
 * Jump to the _start entry point in the .text section if reset code
 * is allowed or if optimizing for RTL simulation.
 */

    /* Jump to the _start entry point in the .text section. */
    tail _start

    .size __reset, . - __reset
#endif /* Jump to _start */

/*
 * When not using exit, provide an _exit symbol to prevent unresolved
 * references to _exit from the linker script.
 */
#ifdef ALT_NO_EXIT
    .globl _exit
_exit:
#endif

/*************************************************************************\
|                          TEXT SECTION (.text)                           |
\*************************************************************************/

/*
 * Start of the .text section, and also the code entry point when
 * the code is executed by a bootloader rather than directly from reset.
 */
    .section .text
    .align 2

    .globl _start
    .type _start, @function
_start:
#if ALT_CPU_HAS_CSR_SUPPORT
    /* assume that we are in machine mode on startup */
    /* setup trap to catch anything that goes wrong early in the boot process */
    la t0, trap_vector
    csrw mtvec, t0

    /* disable all interrupt */
    li t0, 8
    csrc mstatus, t0
    csrw mie, zero
    csrw mip, zero
#endif

/*
 * Initialize the data cache if present (i.e. size > 0).
 * Skip initialization if optimizing for RTL simulation.
 * RTL simulations can ensure the data cache tag RAM is already
 * initialized so skipping this speeds up RTL simulation.
 */
#ifndef ALT_SIM_OPTIMIZE
#if ALT_CPU_DCACHE_SIZE > 0
    li t0, ALT_CPU_DCACHE_SIZE
0:
    /* cbo.inval.ix */
    .insn i 0x0F, 0x2, zero, t0, 0x080
    addi t0, t0, -ALT_CPU_DCACHE_LINE_SIZE
    bnez t0, 0b
#endif /* Initialize Data Cache */
#endif /* ALT_SIM_OPTIMIZE */

    .option push
    .option norelax
    la gp, __global_pointer$
    .option pop

    /* Log that the stack pointer is about to be setup. */
#ifdef ALT_LOG_ENABLE
    ALT_LOG_PUTS(alt_log_msg_stackpointer)
#endif /* ALT_LOG_ENABLE */

    /*
     * Now that the caches are initialized, set up the stack pointer and global pointer.
     * The values provided by the linker are assumed to be correctly aligned.
     */
    la sp, __alt_stack_pointer

/*
 * Clear the BSS if not optimizing for RTL simulation.
 *
 * This uses the symbols: __bss_start and __bss_end, which are defined
 * by the linker script. They mark the begining and the end of the bss
 * region. The linker script guarantees that these values are word aligned.
 */
#ifndef ALT_SIM_OPTIMIZE
    /* Log that the BSS is about to be cleared. */
#ifdef ALT_LOG_ENABLE
    ALT_LOG_PUTS(alt_log_msg_bss)
#endif /* ALT_LOG_ENABLE */

    la t1, __bss_start
    la t2, __bss_end
0:
    sw zero, (t1)
    addi t1, t1, 4
    bltu t1, t2, 0b

#endif /* ALT_SIM_OPTIMIZE */

/*
 * The alt_load() facility is normally used when there is no bootloader.
 * It copies some sections into RAM so it acts like a mini-bootloader.
 */
#ifdef CALL_ALT_LOAD
    call alt_load
#endif /* CALL_ALT_LOAD */

/* 
 * Initialize Thread Local Support
 * a) Zero out main thread tbss
 * b) Copy main thread tdata to tdata_source 'golden' reference for all subsequent threads
 * c) Set thread pointer register (tp) to __tls_base
 */
#ifndef ALT_SIM_OPTIMIZE
.globl __tbss_start
.globl __tbss_end

    la t1, __tbss_start
    la t2, __tbss_end
    
    // Check if we need to skip this (if .tbss is empty)
    bgeu t1, t2, 1f
0:
    sw zero, (t1)
    addi t1, t1, 4
    bltu t1, t2, 0b
1:
#endif /* ALT_SIM_OPTIMIZE */
    
// Copy tdata to tdata golden source location
.globl __tdata_start
.globl __tdata_end
.globl __tdata_source

    la t0, __tdata_start
    la t1, __tdata_end
    la t2, __tdata_source

    // Check if we need to skip this (if .tdata is empty)
    bgeu t0, t1, 1f
0:
    lw s1, (t0)
    sw s1, (t2)
    addi t0, t0, 4
    addi t2, t2, 4
    bltu t0, t1, 0b
1:

// Assign thread pointer register (tp) to main thread tls base
.globl __tls_base
    la tp, __tls_base

    /* Log that alt_main is about to be called. */
#ifdef ALT_LOG_ENABLE
    ALT_LOG_PUTS(alt_log_msg_alt_main)
#endif /* ALT_LOG_ENABLE */

    /* Call the C entry point. It should never return. */
    call alt_main

    /* Wait in infinite loop in case alt_main does return. */
alt_after_alt_main:
    j alt_after_alt_main

    .size _start, . - _start

/*
 * Add information about the stack base if stack overflow checking is enabled.
 */
#ifdef ALT_STACK_CHECK
    .globl  alt_stack_limit_value
    .section .sdata,"aw",@progbits
    .align  2
    .type   alt_stack_limit_value, @object
    .size   alt_stack_limit_value, 4
alt_stack_limit_value:
    .long   __alt_stack_limit
#endif
