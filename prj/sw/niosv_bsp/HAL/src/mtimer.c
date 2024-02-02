#include "intel_niosv.h"
#include "sys/alt_irq.h"
#include "sys/alt_log_printf.h"
#include "sys/alt_timestamp.h"
#include "sys/alt_alarm.h"

#include "system.h" // For ALT_TIMESTAMP_CLK_TIMER_DEVICE_TYPE

// This needs to be kept in sync with the _hw.tcl
#define INTEL_NIOSV_TIMER_DEVICE_TYPE 2

#if (ALT_TIMESTAMP_CLK_TIMER_DEVICE_TYPE == INTEL_NIOSV_TIMER_DEVICE_TYPE)
alt_u64 alt_niosv_timestamp_offset = 0;

int alt_timestamp_start() {
    return alt_niosv_timer_timestamp_start();
}

alt_timestamp_type alt_timestamp() {
    return alt_niosv_timer_timestamp();
}

alt_u32 alt_timestamp_freq() {
    return alt_niosv_timer_timestamp_freq();
}
#endif

alt_u64 alt_niosv_mtime_get() {
    alt_u32 lowbits;
    alt_u32 highbits;

    // Guard against rollover while acquiring each word
    do {
        highbits = ALT_VOLATILE_ACCESS((alt_u32 *)(NIOSV_MTIME_ADDR + 4));
        lowbits = ALT_VOLATILE_ACCESS((alt_u32 *)NIOSV_MTIME_ADDR);
    } while (ALT_VOLATILE_ACCESS((alt_u32 *)(NIOSV_MTIME_ADDR + 4)) != highbits);

    return (((alt_u64)highbits) << 32) | lowbits;
}

void alt_niosv_mtimecmp_set(alt_u64 time) {
    // Make sure to set the high word to a max value first to prevent triggering inadvertently
    ALT_VOLATILE_ACCESS((alt_u32 *)(NIOSV_MTIMECMP_ADDR + 4)) = 0xFFFFFFFF;
    ALT_VOLATILE_ACCESS((alt_u32 *)NIOSV_MTIMECMP_ADDR) = (alt_u32)time;
    ALT_VOLATILE_ACCESS((alt_u32 *)(NIOSV_MTIMECMP_ADDR + 4)) = (alt_u32)(time >> 32);
}

alt_u64 alt_niosv_mtimecmp_get() {
    alt_u32 lowbits = ALT_VOLATILE_ACCESS((alt_u32 *)NIOSV_MTIMECMP_ADDR);
    alt_u32 highbits = ALT_VOLATILE_ACCESS((alt_u32 *)(NIOSV_MTIMECMP_ADDR + 4));
    return (((alt_u64)highbits) << 32) | lowbits;
}

#if (OS_PORT_HAS_MTIME == 1)
// Let's the OS port handles the machine timer configuration and interrupt if
// the OS port has it (ex: FreeRTOS).
void alt_niosv_timer_sc_isr(alt_u32 cause, alt_u32 epc, alt_u32 tval) {}
void alt_niosv_mtimecmp_interrupt_init() {}
#else
void alt_niosv_timer_sc_isr(alt_u32 cause, alt_u32 epc, alt_u32 tval) {
    // Schedule the next interrupt.  This is done first since who knows how long
    // the following code takes, and the contract is ticks per second, irrespective
    // of how long a given clock tick may take.

    alt_u64 curr_time = alt_niosv_mtime_get();
    alt_niosv_mtimecmp_set(curr_time + MTIMECMP_DELTA_AMT);

    // ALT_LOG - see altera_hal/HAL/inc/sys/alt_log_printf.h
    ALT_LOG_SYS_CLK_HEARTBEAT();

    /* 
    * Notify the system of a clock tick. disable interrupts 
    * during this time to safely support ISR preemption
    */
    alt_irq_context cpu_sr = alt_irq_disable_all();
    alt_tick();
    alt_irq_enable_all(cpu_sr);
}

void alt_niosv_mtimecmp_interrupt_init() {
    alt_niosv_mtimecmp_set(MTIMECMP_MAX_VALUE);
    alt_niosv_enable_timer_interrupt();
}
#endif /* OS_PORT_HAS_MTIME */
