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
#ifndef __INTEL_NIOSV_H__
#define __INTEL_NIOSV_H__

#include "alt_types.h"

#include "system.h"

/*
 * This header provides processor macros for accessing Intel Nios V.
 */
#define NIOSV_M_ARCH        1
#define NIOSV_M_ARCH_NOPIPE 2
#define NIOSV_G_ARCH        3
#define NIOSV_C_ARCH        4

#ifdef __cplusplus
extern "C"
{
#endif /* __cplusplus */

#define ALT_VOLATILE_ACCESS(x) (*(__typeof__(*x) volatile *)(x))

// Handy stringification marcos
#define ALT_MKSTR(s) #s
#define ALT_MKSTR_EXPAND(s) ALT_MKSTR(s)

#if ALT_CPU_HAS_CSR_SUPPORT

typedef void (*alt_niosv_timer_isr_t)(alt_u32 cause, alt_u32 epc, alt_u32 tval);
typedef void (*alt_niosv_sw_isr_t)(alt_u32 cause, alt_u32 epc, alt_u32 tval);

#define NIOSV_IC_ID 0
#define NIOSV_SOFTWARE_IRQ  3
#define NIOSV_TIMER_IRQ     7
#define NIOSV_EXTERNAL_IRQ  11

#define NIOSV_NUM_SYNCH_EXCEPTIONS 16

/*
 * Memory mapped control registers
 */
#define NIOSV_MSIP_ADDR       (ALT_CPU_MTIME_OFFSET + 0x10)
#define NIOSV_MTIMECMP_ADDR   ALT_CPU_MTIME_OFFSET
#define NIOSV_MTIME_ADDR      (ALT_CPU_MTIME_OFFSET + 0x8)
#define MTIMECMP_MAX_VALUE    0xFFFFFFFFFFFFFFFF

/*
 * Control registers (CSRs)
 */
#define NIOSV_MSTATUS_CSR 0x300
#define NIOSV_MIE_CSR     0x304
#define NIOSV_MTVEC_CSR   0x305
#define NIOSV_MEPC_CSR    0x341
#define NIOSV_MCAUSE_CSR  0x342
#define NIOSV_MIP_CSR     0x344

/*
 * Control register (CSR) fields
 */
#define NIOSV_MSTATUS_MIE_MASK 0x8
#define NIOSV_MIE_MASK 0xFFFFFFFF
#define NIOSV_MCAUSE_INTERRUPT_MASK 0x80000000

/*
 * Number of available IRQs in internal interrupt controller.
 * Note: For Abbott's Lake, the top 16 bits of mie / mip are
 *       available for general purpose interrupts, and the bottom
 *       16 are reserved.  We are only exposing the top 16 bits.
 */
#define NIOSV_NIRQ 16

/*
 * Macros to access control registers.
 */

/* Read CSR regNum and set dst to its value. */
#define NIOSV_READ_CSR(regNum, dst)                         \
  do { asm volatile ("csrr %[dstReg], %[imm]"               \
    : [dstReg] "=r"(dst)                                    \
    : [imm] "i"(regNum)); } while (0)

/* Writes CSR regNum with src */
#define NIOSV_WRITE_CSR(regNum, src)                        \
  do { asm volatile ("csrw %[imm], %[srcReg]"               \
    :                                                       \
    : [imm] "i"(regNum), [srcReg] "r"(src)); } while (0)

/* Read CSR regNum, set dst to its value, and write CSR regNum with src. */
#define NIOSV_SWAP_CSR(regNum, src, dst)                    \
  do { asm volatile ("csrrw %[dstReg], %[imm], %[srcReg]"   \
    : [dstReg] "=r"(dst)                                    \
    : [imm] "i"(regNum), [srcReg] "r"(src)); } while (0)

/* 
 * Bit-wise OR the CSR with bitmask.
 * Any bit that is 1 in bitmask causes the corresponding bit in CSR to be set to 1.
 */
#define NIOSV_SET_CSR(regNum, bitmask)                      \
  do { asm volatile ("csrs %[imm], %[srcReg]"               \
    :                                                       \
    : [imm] "i"(regNum), [srcReg] "r"(bitmask)); } while (0)

/* 
 * Read CSR regNum, set dst to its value, and bit-wise OR the CSR with bitmask.
 * Any bit that is 1 in bitmask causes the corresponding bit in CSR to be set to 1.
 */
#define NIOSV_READ_AND_SET_CSR(regNum, dst, bitmask)        \
  do { asm volatile ("csrrs %[dstReg], %[imm], %[srcReg]"   \
    : [dstReg] "=r"(dst)                                    \
    : [imm] "i"(regNum), [srcReg] "r"(bitmask)); } while (0)

/* 
 * Bit-wise AND the CSR with ~bitmask.
 * Any bit that is 1 in bitmask causes the corresponding bit in CSR to be cleared to 0.
 */
#define NIOSV_CLR_CSR(regNum, bitmask)                      \
  do { asm volatile ("csrc %[imm], %[srcReg]"              \
    :                                                       \
    : [imm] "i"(regNum), [srcReg] "r"(bitmask)); } while (0)

/* 
 * Read CSR regNum, set dst to its value, and bit-wise AND the CSR with ~bitmask.
 * Any bit that is 1 in bitmask causes the corresponding bit in CSR to be cleared to 0.
 */
#define NIOSV_READ_AND_CLR_CSR(regNum, dst, bitmask)        \
  do { asm volatile ("csrrc %[dstReg], %[imm], %[srcReg]"   \
    : [dstReg] "=r"(dst)                                    \
    : [imm] "i"(regNum), [srcReg] "r"(bitmask)); } while (0)

/* set specific bit to 1 */
#define NIOSV_CSR_SET_BIT(regNum, bit)        \
  do { asm volatile ("csrsi %[imm], %[srcReg]"   \
    :                                                       \
    : [imm] "i"(regNum), [srcReg] "r"(bit)); } while (0)

/* set specific bit to 0 */
#define NIOSV_CSR_CLR_BIT(regNum, bit)        \
  do { asm volatile ("csrci %[imm], %[srcReg]"   \
    :                                                       \
    : [imm] "i"(regNum), [srcReg] "r"(bit)); } while (0)

// Functions for getting mtime, and get/set mtimecmp
alt_u64 alt_niosv_mtime_get();
void alt_niosv_mtimecmp_set(alt_u64 time);
alt_u64 alt_niosv_mtimecmp_get();
void alt_niosv_mtimecmp_interrupt_init();
extern alt_niosv_timer_isr_t alt_niosv_timer_interrupt_handler;

static ALT_INLINE void ALT_ALWAYS_INLINE alt_niosv_register_mtimecmp_interrupt_handle(alt_niosv_timer_isr_t handle) {
    alt_niosv_timer_interrupt_handler = handle;
}

static ALT_INLINE void ALT_ALWAYS_INLINE alt_niosv_enable_timer_interrupt() {
    NIOSV_SET_CSR(NIOSV_MIE_CSR, (0x1 << NIOSV_TIMER_IRQ));
}

static ALT_INLINE void ALT_ALWAYS_INLINE alt_niosv_disable_timer_interrupt() {
    NIOSV_CLR_CSR(NIOSV_MIE_CSR, (0x1 << NIOSV_TIMER_IRQ));
}

static ALT_INLINE int ALT_ALWAYS_INLINE alt_niosv_is_timer_interrupt_enabled() {
    alt_u32 mie_val;
    NIOSV_READ_CSR(NIOSV_MIE_CSR, mie_val);   
    return mie_val & (0x1 << NIOSV_TIMER_IRQ);
}

/*
 * Functions for use as system clock driver and timestamp driver.
 */
void alt_niosv_timer_sc_isr(alt_u32 cause, alt_u32 epc, alt_u32 tval);

extern alt_u64 alt_niosv_timestamp_offset;

static ALT_INLINE int ALT_ALWAYS_INLINE alt_niosv_timer_timestamp_start() {
    alt_niosv_timestamp_offset = alt_niosv_mtime_get();
    return 0;
}

static ALT_INLINE alt_u64 ALT_ALWAYS_INLINE alt_niosv_timer_timestamp() {
    return alt_niosv_mtime_get() - alt_niosv_timestamp_offset;
}

static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE alt_niosv_timer_timestamp_freq() {
    return ALT_CPU_CPU_FREQ;
}

// Determine amount to add to mtimecmp to trigger a subsequent interrupt at
#define MTIMECMP_DELTA_AMT (ALT_CPU_CPU_FREQ / ALT_CPU_TICKS_PER_SEC)

#else /* ALT_CPU_HAS_CSR_SUPPORT */

/* Cores that do not have CSR support do not support interrupts */
#define NIOSV_NIRQ 0

#endif /* ALT_CPU_HAS_CSR_SUPPORT */

/*
 * Cache maintenance macros
 * CLEAN - Writeback to memory;
 * FLUSH - Writeback to memory and invalidate. 
 */

#if ALT_CPU_DCACHE_SIZE > 0
#define DCACHE_CLEAN_BY_INDEX_VAL(i) \
__asm__ volatile(".insn i 0x0F, 0x2, zero, %[i_reg], 0x081" :: [i_reg] "r"(i));

#define DCACHE_FLUSH_BY_INDEX_VAL(i) \
__asm__ volatile(".insn i 0x0F, 0x2, zero, %[i_reg], 0x082" :: [i_reg] "r"(i));

#define DCACHE_INVALIDATE_BY_INDEX_VAL(i) \
__asm__ volatile(".insn i 0x0F, 0x2, zero, %[i_reg], 0x080" :: [i_reg] "r"(i));
#endif

/*
 * Macros for accessing select Nios V general-purpose registers.
 */
/* SP (Stack Pointer) register */ 
#define NIOSV_READ_SP(sp) \
    do { __asm ("mv %0, sp" : "=r" (sp) ); } while (0)

/*
 * Macros for useful processor instructions.
 */
#define NIOSV_EBREAK() \
    do { __asm volatile ("ebreak"); } while (0)

/* TODO: Figure this out for Nios V. No optional immediate for RISC-V ebreak supported. */
#define NIOSV_REPORT_STACK_OVERFLOW() \
    do { __asm volatile("ebreak"); } while (0)

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* __INTEL_NIOSV_H__ */
