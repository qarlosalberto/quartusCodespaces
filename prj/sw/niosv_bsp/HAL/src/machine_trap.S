/******************************************************************************
*                                                                             *
* License Agreement                                                           *
*                                                                             *
* Copyright (c) 2020-2021 Intel Corporation, Santa Clara, California, USA.    *
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

/*
 * This is the base machine-mode trap exception handler for Nios V.  This only
 * saves the caller saved registers, any callee saved registers will be saved by
 * handle_trap, if needed.
*/ 

#include "linker.h"
#include "system.h"

    .section .exceptions.entry, "xa"
    .align 2

    .globl trap_vector
    
    .globl __alt_exception_stack_pointer
    .globl __alt_exception_stack_limit

trap_vector:
#ifdef ALT_EXCEPTION_STACK
    /* Save callee saved registers s0, s1 */
    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)
    
    /* Compare against the exception stack bounds */    
    la s0, __alt_exception_stack_pointer
    la s1, __alt_exception_stack_limit
    bgtu sp, s0, not_nested_exc
    bltu sp, s1, not_nested_exc

nested_exc:
    /* This saves the stack pointer onto the stack to keep the loading of
       the stack pointer below the same for both cases (nested vs non-nested) */
    sw sp, -4(sp)
    addi sp, sp, -4    
    j save_registers
    
not_nested_exc:
    /* Load the exception stack pointer into s0 */
    la s0, __alt_exception_stack_pointer - 4
    
    /* Save the current stack pointer into the exception stack, and load the 
       exception stack pointer (s0 holds the memory address of the exception stack) */      
    sw sp, 0(s0)
    mv sp, s0

#endif /* ALT_EXCEPTION_STACK */

save_registers:
    /* Save caller-saved registers on the stack */

#if __riscv_flen == 32 // rv32if
    addi sp, sp, -36 * 4
#elif ALT_CPU_NUM_GPR == 32 // rv32i
	addi sp, sp, -16 * 4
#else // rv32e (16-bit)
	addi sp, sp, -10 * 4
#endif

    /* rv32e (16-bit), rv32i and rv32if */
    sw ra,  0 * 4(sp)
    sw t0,  1 * 4(sp)
    sw t1,  2 * 4(sp)
    sw t2,  3 * 4(sp)
    sw a0,  4 * 4(sp)
    sw a1,  5 * 4(sp)
    sw a2,  6 * 4(sp)
    sw a3,  7 * 4(sp)
    sw a4,  8 * 4(sp)
    sw a5,  9 * 4(sp)

    /* rv32i and rv32if */
#if ALT_CPU_NUM_GPR == 32 
    sw a6, 10 * 4(sp)
    sw a7, 11 * 4(sp)
    sw t3, 12 * 4(sp)
    sw t4, 13 * 4(sp)
    sw t5, 14 * 4(sp)
    sw t6, 15 * 4(sp)
#endif

    /* rv32if only */
#if __riscv_flen == 32
    fsw ft0, 16 * 4(sp)
    fsw ft1, 17 * 4(sp)
    fsw ft2, 18 * 4(sp)
    fsw ft3, 19 * 4(sp)
    fsw ft4, 20 * 4(sp)
    fsw ft5, 21 * 4(sp)
    fsw ft6, 22 * 4(sp)
    fsw ft7, 23 * 4(sp)
    fsw ft8, 24 * 4(sp)
    fsw ft9, 25 * 4(sp)
    fsw ft10, 26 * 4(sp)
    fsw ft11, 27 * 4(sp)
    fsw fa0, 28 * 4(sp)
    fsw fa1, 29 * 4(sp)
    fsw fa2, 30 * 4(sp)
    fsw fa3, 31 * 4(sp)
    fsw fa4, 32 * 4(sp)
    fsw fa5, 33 * 4(sp)
    fsw fa6, 34 * 4(sp)
    fsw fa7, 35 * 4(sp)
#endif
   
    /* Call handle_trap to dispatch the correct handler, if available */
    csrr a0, mcause
    csrr a1, mepc
    csrr a2, mtval
    jal handle_trap
    csrw mepc, a0

    /* Restore caller-saved registers */

    /* rv32e (16-bit), rv32i and rv32if */
    lw ra,  0 * 4(sp)
    lw t0,  1 * 4(sp)
    lw t1,  2 * 4(sp)
    lw t2,  3 * 4(sp)
    lw a0,  4 * 4(sp)
    lw a1,  5 * 4(sp)
    lw a2,  6 * 4(sp)
    lw a3,  7 * 4(sp)
    lw a4,  8 * 4(sp)
    lw a5,  9 * 4(sp)

    /* rv32i and rv32if */
#if ALT_CPU_NUM_GPR == 32	
    lw a6, 10 * 4(sp)
    lw a7, 11 * 4(sp)
    lw t3, 12 * 4(sp)
    lw t4, 13 * 4(sp)
    lw t5, 14 * 4(sp)
    lw t6, 15 * 4(sp)
#endif	

    /* rv32if only */	
#if __riscv_flen == 32
    flw ft0, 16 * 4(sp)
    flw ft1, 17 * 4(sp)
    flw ft2, 18 * 4(sp)
    flw ft3, 19 * 4(sp)
    flw ft4, 20 * 4(sp)
    flw ft5, 21 * 4(sp)
    flw ft6, 22 * 4(sp)
    flw ft7, 23 * 4(sp)
    flw ft8, 24 * 4(sp)
    flw ft9, 25 * 4(sp)
    flw ft10, 26 * 4(sp)
    flw ft11, 27 * 4(sp)
    flw fa0, 28 * 4(sp)
    flw fa1, 29 * 4(sp)
    flw fa2, 30 * 4(sp)
    flw fa3, 31 * 4(sp)
    flw fa4, 32 * 4(sp)
    flw fa5, 33 * 4(sp)
    flw fa6, 34 * 4(sp)
    flw fa7, 35 * 4(sp)
#endif

#if __riscv_flen == 32 // rv32if
    addi sp, sp, 36 * 4
#elif ALT_CPU_NUM_GPR == 32 // rv32i
	addi sp, sp, 16 * 4
#else // rv32e (16-bit)
	addi sp, sp, 10 * 4
#endif
    
#ifdef ALT_EXCEPTION_STACK
    /* Load in the previous stack pointer */
    lw s0, 0(sp)
    addi sp, sp, 4
    mv sp, s0

    /* Load callee saved registers s0, s1 */
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8
#endif

    mret
