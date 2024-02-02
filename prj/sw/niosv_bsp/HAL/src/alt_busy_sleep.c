/*
 * Copyright (c) 2003-2004 Altera Corporation, San Jose, California, USA.  
 * All rights reserved.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to 
 * deal in the Software without restriction, including without limitation the 
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is 
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in 
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
 * DEALINGS IN THE SOFTWARE.
 * 
 * ------------
 *
 * Altera does not recommend, suggest or require that this reference design 
 * file be used in conjunction or combination with any other product.
 *
 * alt_busy_sleep.c - Microsecond delay routine which uses a calibrated busy
 *                    loop to perform the delay. This is used to implement
 *                    usleep for the standalone HAL.  
 */

#include <limits.h>

#include "system.h"
#include "alt_types.h"
#include "sys/alt_timestamp.h"
#include "intel_niosv.h"

#include "priv/alt_busy_sleep.h"

#define CPU_FREQUENCY_MHZ (ALT_CPU_CPU_FREQ / 1000000u)

// Assumption: This is greater than 1.  The timing will have an increased innacuracy off if the CPU clock is
// less than 1 MHz, or near 1 MHz with a fraction, e.g. 1.5 MHz or 3.5 MHz as the integer math will
// truncate significantly.
#define CLOCKS_PER_US CPU_FREQUENCY_MHZ

// These are rough estimations and dependent on the assumption on-chip memory has been used.
// If a memory of different latency is used the timing will be innaccurate.  For accuarate timing
#define NIOSV_M_CLOCKS_PER_LOOP_ITERATION          9
#define NIOSV_M_NOPIPE_CLOCKS_PER_LOOP_ITERATION   14
#define NIOSV_G_CLOCKS_PER_LOOP_ITERATION          7
#define NIOSV_C_CLOCKS_PER_LOOP_ITERATION          14

// Detect which CPU is instantiated COER_VARIANT macros
#if ALT_CPU_NIOSV_CORE_VARIANT == NIOSV_M_ARCH
    #define CLOCKS_PER_LOOP_ITERATION NIOSV_M_CLOCKS_PER_LOOP_ITERATION
#elif ALT_CPU_NIOSV_CORE_VARIANT == NIOSV_M_ARCH_NOPIPE
    #define CLOCKS_PER_LOOP_ITERATION NIOSV_M_NOPIPE_CLOCKS_PER_LOOP_ITERATION
#elif ALT_CPU_NIOSV_CORE_VARIANT == NIOSV_G_ARCH
    #define CLOCKS_PER_LOOP_ITERATION NIOSV_G_CLOCKS_PER_LOOP_ITERATION
#elif ALT_CPU_NIOSV_CORE_VARIANT == NIOSV_C_ARCH
    #define CLOCKS_PER_LOOP_ITERATION NIOSV_C_CLOCKS_PER_LOOP_ITERATION
#endif

// Determine if timer_sw_agent interface is connected in HW
#ifdef ALT_CPU_MTIME_OFFSET
    #if ALT_CPU_MTIME_OFFSET != 0xffffffffffffffff
        #define MTIME_SW_AGENT_CONNECTED
    #endif
#endif

// Determine if timerstamp functionality is enabled in the HAL
#define HAL_TIMESTAMP_ENABLED (ALT_TIMESTAMP_CLK_TIMER_DEVICE_TYPE != NONE_TIMER_DEVICE_TYPE)

#define CLOCKS_PER_INNER_LOOP CLOCKS_PER_LOOP_ITERATION
#define CLOCKS_PER_OUTER_LOOP (alt_u64)(((alt_u64)CLOCKS_PER_INNER_LOOP * (alt_u64)UINT_MAX) + CLOCKS_PER_LOOP_ITERATION)

// For a 50 Mhz clock, this is 1,202,590,842.
#define US_PER_OUTER_LOOP ((alt_u64)CLOCKS_PER_OUTER_LOOP / (alt_u64)CPU_FREQUENCY_MHZ)

unsigned int alt_busy_sleep (unsigned int us)
{
/*
 * Only delay if ALT_SIM_OPTIMIZE is not defined; i.e., if software
 * is built targetting ModelSim RTL simulation, the delay will be
 * skipped to speed up simulation.
 */
#ifndef ALT_SIM_OPTIMIZE

/* Determine implementation of busy sleep. For cores with timestamp enabled, use whatever
 * timestamp device they've provided. If no timestamp driver is enabled, but the timer agent
 * is connected, use that. If no timer agent is connected, fallback to a low accuracy busy
 * loop. If accurate timing is desired for busy sleep (used by usleep), please be sure to
 * provide a timestamp source, or connect the timer agent.
 */
#if HAL_TIMESTAMP_ENABLED
    alt_timestamp_start();
    const alt_timestamp_type end_time = (CPU_FREQUENCY_MHZ * us);
    while (alt_timestamp() < end_time) {
        // Spin
    }
#elif defined(MTIME_SW_AGENT_CONNECTED)
    const alt_u64 start_time = alt_niosv_mtime_get();
    const alt_u64 end_time = start_time + (CPU_FREQUENCY_MHZ * us);
    while (alt_niosv_mtime_get() < end_time) {
        // Spin
    }
#else
    if ((alt_u64)us > (alt_u64)US_PER_OUTER_LOOP) {
        alt_u32 big_loops =  (alt_u32)((alt_u64)us / (alt_u64)US_PER_OUTER_LOOP);
        
        // Big loops
        __asm__ volatile(
            "\n0:"
            "\naddi %[INNER_LOOP_REG], %[INNER_LOOP_REG], -1"
            "\nbnez %[INNER_LOOP_REG], 0b"
            "\naddi %[OUTER_LOOP_REG], %[OUTER_LOOP_REG], -1"
            "\nbnez %[OUTER_LOOP_REG], 0b"
            :
            : [OUTER_LOOP_REG] "r" (big_loops), [INNER_LOOP_REG] "r" (0)
        );
        
        // US_PER_OUTER_LOOP is a large number for any reasonable clock rate we'll see,
        // on the order of ~10^9 so the error introduced by casting to int and removing
        // fractional part after the decimal point is negligable
        us = us % (unsigned int)US_PER_OUTER_LOOP;        
    }
    
    alt_u32 small_loop_remainder_cnt;
    if (us > (CLOCKS_PER_INNER_LOOP << 16)) {
        // Handle case where we have a longer delay.
        // The order of operations and 32-bit math are chosen to prevent overflow
        // and trunctation issues and while avoiding 64-bit math which is much slower.
         small_loop_remainder_cnt = (us / CLOCKS_PER_INNER_LOOP) * CLOCKS_PER_US;
    } else {
        // Handle case where we have a short delay.
        // The order of operations and 32-bit math are chosen to prevent overflow
        // and trunctation issues and while avoiding 64-bit math which is much slower.
        small_loop_remainder_cnt = (us * CLOCKS_PER_US) / CLOCKS_PER_INNER_LOOP;
    }
    
    // Remainder small loops
    if (small_loop_remainder_cnt > 0) {
        __asm__ volatile(
            "\n0:"
            "\naddi %[LOOP_REG], %[LOOP_REG], -1"
            "\nbnez %[LOOP_REG], 0b"
            :
            : [LOOP_REG] "r" (small_loop_remainder_cnt)
        );
    }
#endif
#endif /* #ifndef ALT_SIM_OPTIMIZE */

  return 0;
}
