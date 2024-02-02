/******************************************************************************
*                                                                             *
* License Agreement                                                           *
*                                                                             *
* Copyright (c) 2009 Altera Corporation, San Jose, California, USA.           *
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
#ifndef __ALT_IRQ_H__
#define __ALT_IRQ_H__

/*
 * alt_irq.h is the Intel Nios V specific implementation of the interrupt controller 
 * interface.
 *
 * This file should be included by application code and device drivers that register 
 * ISRs or manage interrpts.
 */
#include "intel_niosv.h"
#include "alt_types.h"
#include "system.h"

#ifdef __cplusplus
extern "C"
{
#endif /* __cplusplus */

/* 
 * Number of available interrupts in internal interrupt controller.
 */
#define ALT_NIRQ NIOSV_NIRQ

/* Default value is true. For older builds (mid 23.2 and earlier every CPU had CSR support */
#ifndef ALT_CPU_HAS_CSR_SUPPORT
    #define ALT_CPU_HAS_CSR_SUPPORT 1
#endif

#define ALT_HAS_IRQ_SUPPORT ALT_CPU_HAS_CSR_SUPPORT

/*
 * Used by alt_ic_irq_disable_all() and alt_ic_irq_enable_all().
 */
typedef int alt_irq_context;

/* ISR Prototype */
typedef void (*alt_isr_func)(void* isr_context);

/* 
 * Lower 16 in Qsys are mapped to the general purpose upper 16 bits of RV
 * 0  --> 16
 * 1  --> 17
 * 2  --> 18
 * 3  --> 19
 * 4  --> 20
 * 5  --> 21
 * 6  --> 22
 * 7  --> 23
 * 8  --> 24
 * 9  --> 25
 * 10 --> 26
 * 11 --> 27
 * 12 --> 28
 * 13 --> 29
 * 14 --> 30
 * 15 --> 31
 */
#define ALT_REMAP_IRQ_NUM(irq) ((irq > (NIOSV_NIRQ - 1)) ? -1 : (int) (irq + 16))

/*
 * alt_irq_enabled can be called to determine if the processor's global
 * interrupt enable is asserted. The return value is zero if interrupts 
 * are disabled, and non-zero otherwise.
 *
 * Whether the internal or external interrupt controller is present, 
 * individual interrupts may still be disabled. Use the other API to query
 * a specific interrupt. 
 */
static ALT_INLINE int ALT_ALWAYS_INLINE 
alt_irq_enabled(void)
{
#if ALT_HAS_IRQ_SUPPORT
    alt_u32 mstatus_val;

    NIOSV_READ_CSR(NIOSV_MSTATUS_CSR, mstatus_val);

    return mstatus_val & NIOSV_MSTATUS_MIE_MASK;
#else
    return 0;
#endif
}

/*
 * alt_irq_disable_all() 
 *
 * This routine inhibits all interrupts by clearing the status register MIE 
 * bit. It returns the previous contents of the status register (IRQ 
 * context) which can be used to restore the status register MIE bit to its 
 * state before this routine was called.
 */
static ALT_INLINE alt_irq_context ALT_ALWAYS_INLINE 
alt_irq_disable_all(void)
{
#if ALT_HAS_IRQ_SUPPORT
    alt_irq_context context;

    NIOSV_READ_AND_CLR_CSR(NIOSV_MSTATUS_CSR, context, NIOSV_MSTATUS_MIE_MASK);
  
    return context;
#else
    return 0;
#endif
}

/*
 * alt_irq_enable_all() 
 *
 * Enable all interrupts that were previously disabled by alt_irq_disable_all().
 *
 * This routine accepts a context to restore the CPU status register MIE bit
 * to the state prior to a call to alt_irq_disable_all().
 
 * In the case of nested calls to alt_irq_disable_all()/alt_irq_enable_all(), 
 * this means that alt_irq_enable_all() does not necessarily re-enable
 * interrupts.
 */
static ALT_INLINE void ALT_ALWAYS_INLINE 
alt_irq_enable_all(alt_irq_context context)
{
#if ALT_HAS_IRQ_SUPPORT
    NIOSV_SET_CSR(NIOSV_MSTATUS_CSR, context & NIOSV_MSTATUS_MIE_MASK);
#endif
}

/*
 * The function alt_irq_init() is defined within the auto-generated file
 * alt_sys_init.c. This function calls the initilization macros for all
 * interrupt controllers in the system at config time, before any other
 * non-interrupt controller driver is initialized.
 *
 * The "base" parameter is ignored and only present for backwards-compatibility.
 * It is recommended that NULL is passed in for the "base" parameter.
 */
extern void alt_irq_init(const void* base);

/*
 * alt_irq_cpu_enable_interrupts() enables the CPU to start taking interrupts.
 */
static ALT_INLINE void ALT_ALWAYS_INLINE 
alt_irq_cpu_enable_interrupts(void)
{
#if ALT_HAS_IRQ_SUPPORT
    NIOSV_SET_CSR(NIOSV_MSTATUS_CSR, NIOSV_MSTATUS_MIE_MASK);
#endif
}

/*
 * alt_ic_isr_register() can be used to register an interrupt handler. If the
 * function is succesful, then the requested interrupt will be enabled upon 
 * return.
 */
extern int alt_ic_isr_register(alt_u32 ic_id,
                        alt_u32 irq,
                        alt_isr_func isr,
                        void *isr_context,
                        void *flags);


/*
 * Provide inline functions for IIC.
 */

/** @Function Description:  This function enables a single interrupt indicated by "irq".
  * @API Type:              External
  * @param ic_id            Ignored.
  * @param irq              IRQ number
  * @return                 0 if successful, < 0 otherwise
  */
static ALT_INLINE int ALT_ALWAYS_INLINE 
alt_ic_irq_enable(alt_u32 ic_id __attribute__((unused)), alt_u32 irq)
{
#if ALT_HAS_IRQ_SUPPORT
    int rc = ALT_REMAP_IRQ_NUM(irq);
    if (rc < 0)
        return rc;
    else
        irq = (alt_u32)rc;
    
    NIOSV_SET_CSR(NIOSV_MIE_CSR, 0x1 << irq);
#endif
    return 0;
}

/** @Function Description:  This function disables a single interrupt indicated by "irq".
  * @API Type:              External
  * @param ic_id            Ignored.
  * @param irq              IRQ number
  * @return                 0 if successful, < 0 otherwise
  */
static ALT_INLINE int ALT_ALWAYS_INLINE 
alt_ic_irq_disable(alt_u32 ic_id __attribute__((unused)), alt_u32 irq)
{
#if ALT_HAS_IRQ_SUPPORT
    int rc = ALT_REMAP_IRQ_NUM(irq);
    if (rc < 0)
        return rc;
    else
        irq = (alt_u32)rc;
    
    NIOSV_CLR_CSR(NIOSV_MIE_CSR, 0x1 << irq);
#endif
    return 0;
}

/** @Function Description:  This function to determine if corresponding
  *                         interrupt is enabled.
  * @API Type:              External
  * @param ic_id            Ignored.
  * @param irq              IRQ number
  * @return                 Zero if corresponding interrupt is disabled and
  *                         non-zero otherwise.
  */
static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE
alt_ic_irq_enabled(alt_u32 ic_id __attribute__((unused)), alt_u32 irq)
{
#if ALT_HAS_IRQ_SUPPORT
    int rc = ALT_REMAP_IRQ_NUM(irq);
    if (rc < 0)
        return 0;
    else
        irq = (alt_u32)rc;
    
    alt_u32 mie_val;

    NIOSV_READ_CSR(NIOSV_MIE_CSR, mie_val);

    return (mie_val & (0x1 << irq));
#else
    return 0;
#endif
}

/*
 * alt_irq_pending() returns a bit list of the current pending interrupts.
 * This is used by alt_irq_handler() to determine which registered interrupt
 * handlers should be called.
 */
static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE 
alt_irq_pending(void)
{
#if ALT_HAS_IRQ_SUPPORT
    alt_u32 active;
    alt_u32 enabled;

    NIOSV_READ_CSR(NIOSV_MIP_CSR, active);
    NIOSV_READ_CSR(NIOSV_MIE_CSR, enabled);

    // Since this is used by alt_irq_handler, we want to only process the upper 16-bits
    // --> the interrupt lines connected via Platform Designer...
    return (active & enabled) >> 16;
#else
    return 0;
#endif
}

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* __ALT_IRQ_H__ */
