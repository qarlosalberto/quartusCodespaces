/******************************************************************************
*                                                                             *
* License Agreement                                                           *
*                                                                             *
* Copyright (c) 2009      Altera Corporation, San Jose, California, USA.      *
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

#include "sys/alt_irq.h"
#include "sys/alt_exceptions.h"
#include "sys/alt_log_printf.h"

#include "os/alt_hooks.h"

#include "alt_types.h"
#include "system.h"

alt_niosv_sw_isr_t alt_niosv_software_interrupt_handler;
alt_niosv_timer_isr_t alt_niosv_timer_interrupt_handler;

#ifdef ALT_INCLUDE_INSTRUCTION_RELATED_EXCEPTION_API
/* Function pointer to exception callback routine */
alt_exception_result (*alt_instruction_exception_handler)
  (alt_exception_cause, alt_u32, alt_u32) = 0x0;

#endif /* ALT_INCLUDE_INSTRUCTION_RELATED_EXCEPTION_API */

void alt_irq_handler (void) __attribute__ ((section (".exceptions")));
alt_u32 handle_trap(alt_u32 cause, alt_u32 epc, alt_u32 tval) __attribute__ ((section (".exceptions")));
alt_u32 handle_trap(alt_u32 cause, alt_u32 epc, alt_u32 tval)
{
    alt_u32 is_irq, exception_code;

    is_irq = (cause & NIOSV_MCAUSE_INTERRUPT_MASK);
    exception_code = (cause & ~NIOSV_MCAUSE_INTERRUPT_MASK);

    if (is_irq) {
        switch (exception_code) {
            case NIOSV_TIMER_IRQ:
            {
                if (alt_niosv_timer_interrupt_handler) {
                    ALT_OS_INT_ENTER();
                    alt_niosv_timer_interrupt_handler(cause, epc, tval);
                    ALT_OS_INT_EXIT();
                }
                break;
            }
            case NIOSV_SOFTWARE_IRQ:
            {
                if (alt_niosv_software_interrupt_handler) {
                    ALT_OS_INT_ENTER();
                    alt_niosv_software_interrupt_handler(cause, epc, tval);
                    ALT_OS_INT_EXIT();
                }
                break;
            }
            default:
            {
                if (exception_code >= 16) {
                    alt_irq_handler();
                } else {
                    ALT_LOG_PRINTF("invalid exception code: %d, epc = %d, tval = %d\n", exception_code, epc, tval);
                }
                break;
            }
        };
    } else {
#ifdef ALT_INCLUDE_INSTRUCTION_RELATED_EXCEPTION_API
        if (alt_instruction_exception_handler) {
            alt_exception_result handler_rc = alt_instruction_exception_handler(exception_code, epc, tval);
            epc = (handler_rc == NIOSV_EXCEPTION_RETURN_REISSUE_INST) ? epc : (epc + 4);
        }  else {
#ifdef ALT_CPU_HAS_DEBUG_STUB
            NIOSV_EBREAK();
#else  // ALT_CPU_HAS_DEBUG_STUB
            while(1)
                ;
#endif // ALT_CPU_HAS_DEBUG_STUB
        }
#else  // ALT_INCLUDE_INSTRUCTION_RELATED_EXCEPTION_API
#ifdef ALT_CPU_HAS_DEBUG_STUB
            NIOSV_EBREAK();
#else  // ALT_CPU_HAS_DEBUG_STUB
            while(1)
                ;
#endif // ALT_CPU_HAS_DEBUG_STUB    
#endif // ALT_INCLUDE_INSTRUCTION_RELATED_EXCEPTION_API
    }

    return epc;
}

/*
 * A table describing each interrupt handler. The index into the array is the
 * interrupt id associated with the handler. 
 *
 * When an interrupt occurs, the associated handler is called with
 * the argument stored in the context member.
 */
struct ALT_IRQ_HANDLER
{
  void (*handler)(void*);
  void *context;
} alt_irq[ALT_NIRQ];

/*
 * alt_irq_handler() is called by the interrupt exception handler in order to 
 * process any outstanding interrupts. 
 *
 * It is defined here since it is linked in using weak linkage. 
 * This means that if there is never a call to alt_irq_register() then
 * this function will not get linked in to the executable. This is acceptable
 * since if no handler is ever registered, then an interrupt can never occur.
 */
void alt_irq_handler (void)
{
    alt_u32 active;
    alt_u32 mask;
    alt_u32 i;

    /*
     * Notify the operating system that we are at interrupt level.
     */  
    ALT_OS_INT_ENTER();

    /* 
     * Obtain from the interrupt controller a bit list of pending interrupts,
     * and then process the highest priority interrupt. This process loops, 
     * loading the active interrupt list on each pass until alt_irq_pending() 
     * return zero.
     * 
     * The maximum interrupt latency for the highest priority interrupt is
     * reduced by finding out which interrupts are pending as late as possible.
     * Consider the case where the high priority interupt is asserted during
     * the interrupt entry sequence for a lower priority interrupt to see why
     * this is the case.
     */
    active = alt_irq_pending();

    do
    {
        i = 0;
        mask = 1;

        /*
         * Test each bit in turn looking for an active interrupt. Once one is 
         * found, the interrupt handler asigned by a call to alt_irq_register() is
         * called to clear the interrupt condition.
         */

        do
        {
            if (active & mask)
            {
                alt_irq[i].handler(alt_irq[i].context); 
                break;
            }
            
            mask <<= 1;
            i++;
            
        } while (1);

        active = alt_irq_pending();
    
    } while (active);

    /*
     * Notify the operating system that interrupt processing is complete.
     */ 

    ALT_OS_INT_EXIT();
}
