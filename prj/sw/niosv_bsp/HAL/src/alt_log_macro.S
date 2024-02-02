/*  alt_log_macro.S
 *
 *  Implements the function tx_log_str, called by the assembly macro 
 *  ALT_LOG_PUTS().  The macro will be empty when logging is turned off,
 *  and this function will not be compiled.  When logging is on,
 *  this function is used to print out the strings defined in the beginning
 *  of alt_log_printf.c, using port information taken from system.h and 
 *  alt_log_printf.h.  
 *
 *  This routine only handles strings, and sends a character into the defined
 *  output device's output buffer when the device is ready. It's intended for 
 *  debugging purposes, where messages can be set to print out at certain 
 *  points in the boot code to indicate the progress of the program.
 *
 */

#ifndef __ALT_LOG_MACROS__
#define __ALT_LOG_MACROS__

/* define this flag to skip assembly-incompatible parts
 * of various include files. */
#define ALT_ASM_SRC

#ifdef ALT_LOG_ENABLE // only compile this function if this flag is defined. 
	
	#include "system.h"
	#include "sys/alt_log_printf.h"

        .global tx_log_str
tx_log_str:
tx_next_char:
    /* if pointer points to null, return .
     * a0 is the pointer to the str to be printed, set by ALT_LOG_PUTS */
	lb      t1, (a0)
	beqz    t1, end_tx

	/* 
     * Check device transmit ready
     *    UART, ALT_LOG_PRINT_MSK == 0x40
     *    JTAG UART, ALT_LOG_PRINT_MSK == 0xFFFF0000
     */
    li      t2, ALT_LOG_PRINT_MSK

wait_tx_ready_loop:
    /* load base uart / jtag uart address into t0 */
    li      t0, ALT_LOG_PORT_BASE

    lw      t0, ALT_LOG_PRINT_REG_OFFSET(t0)
    and     t0, t0, t2
    beqz    t0, wait_tx_ready_loop	

    /* load base uart / jtag uart address into t0 */
    li      t0, ALT_LOG_PORT_BASE

	/* write char */
	sw      t1, ALT_LOG_PRINT_TXDATA_REG_OFFSET(t0)		

	/* advance string pointer */
	addi    a0, a0, 1
	j       tx_next_char

end_tx:	
    ret
    
#endif

#endif /* __ALT_LOG_MACROS__ */

