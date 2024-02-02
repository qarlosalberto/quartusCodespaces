/******************************************************************************
*                                                                             *
* License Agreement                                                           *
*                                                                             *
* Copyright (c) 2003-2010 Altera Corporation, San Jose, California, USA.      *
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

/* TODO: Port to RISC-V gprof scheme.*/
/*  mcount or _mcount is inserted by GCC before the function prologue of every 
 *  function when a program is compiled for profiling. At the start of mcount,
 *  we guarantee that:
 *  ra = self_pc (an address in the function which called mcount)
 *  a0 = from_pc (an address in the function which called mcount's caller)
 *
 *  Because this is always called at the start of a function we can corrupt
 *  t0-t6.  We must not corrupt a1-a7 (because they might contain
 *  function arguments for the instrumented function) or a0 (which holds ra
 *  for the instrumented function).
 */

#include "system.h"

// TODO: Remove usage of t3 if we wish to support RV32E + gprof
#if ALT_CPU_NUM_GPR == 32

        .global __mcount_fn_head

        .global mcount

        /* _mcount is used by gcc4 */
        .global _mcount

_mcount:        
mcount:

        /* Use a hash to speed up locating fn_entry.  We use bits 5 upwards to choose
         * the bucket because bits 1:0 will always be 0, and because the distribution
         * of values for bits 4:2 won't be even (aligning on cache line boundaries
         * will skew it).  Higher bits should be fairly random.
         */
        /* fn_head = mcount_fn_head + (((unsigned int)self_pc >> 5) & (HASH_BUCKETS - 1)); */

        srli    t0, ra, 3
        la      t1, __mcount_fn_head
        andi    t0, t0, 0xFC
        add     t2, t0, t1

        /* The fast case is where we have already allocated a function arc, and so
         * also a function pointer.
         */

        /* First find the function being called (using self_pc) */
        mv      t3, t2
0:
        lw      t3, 0(t3)
        beqz    t3, .Lnew_arc
        lw      t0, 4(t3)
        bne     t0, ra, 0b

        /* Found a function entry for this PC. Now look for an arc with a matching
         * from_pc value. There will always be at least one arc. */
        lw      t1, 8(t3)
0:
        lw      t0, 4(t1)
        beq     t0, a0, .Lfound_arc
        lw      t1, 0(t1)
        bne     t1, zero, 0b

.Lnew_arc:
        addi    sp, sp, -20

.LCFI0:
        sw     ra, 0(sp)
        sw     a0, 4(sp)
        sw     a1, 8(sp)
        sw     a2, 12(sp)
        sw     a3, 16(sp)

.LCFI1:
        /* __mcount_record(orig_ra, orig_r8, fn_entry, *fn_head); */
        mv      a1, a0
        mv      a0, ra
        mv      a2, t3
        mv      a3, t2
        jal     __mcount_record
        
        /* restore registers from the stack */
        lw      ra, 0(sp)
        lw      a0, 4(sp)
        lw      a1, 8(sp)
        lw      a2, 12(sp)
        lw      a3, 16(sp)

        addi    sp, sp, 20

.LCFI2:
        ret

.Lfound_arc:
        /* We've found the correct arc record.  Increment the count and return */
        lw      t0, 8(t1)
        addi    t0, t0, 1
        sw      t0, 8(t1)
        ret

.Lmcount_end:



/*
 * Dwarf2 debug information for the function.  This provides GDB with the
 * information it needs to backtrace out of this function.
 */

        .section    .debug_frame,"",@progbits
.LCIE:
        .4byte   2f - 1f               /* Length */
1:
        .4byte   0xffffffff            /* CIE id */
        .byte    0x1                   /* Version */
        .string  ""                    /* Augmentation */
        .uleb128 0x1                   /* Code alignment factor */
        .sleb128 -4                    /* Data alignment factor */
        .byte    0x1f                  /* Return address register */

        .byte    0xc                   /* Define CFA */
        .uleb128 0x1b                  /*   Register 27 (sp) */
        .uleb128 0x0                   /*   Offset 0 */

        .align   2                     /* Padding */
2:

.LFDE_mcount:
        .4byte   2f - 1f               /* Length */
1:
        .4byte   .LCIE                 /* Pointer to CIE */
        .4byte   mcount                /* Start of table entry */
        .4byte   .Lmcount_end - mcount /* Size of table entry */

        .byte    0x4                   /* Advance location */
        .4byte   .LCFI0 - mcount       /*   to .LCFI0 */
        .byte    0xe                   /* Define CFA offset */
        .uleb128 24                    /*   to 24     */

        .byte    0x4                   /* Advance location */
        .4byte   .LCFI1 - .LCFI0       /*   to .LCFI1 */
        .byte    0x9f                  /* Store ra    */
        .uleb128 0x6                   /*   at CFA-24 */
        .byte    0x84                  /* Store r4    */
        .uleb128 0x5                   /*   at CFA-20 */
        .byte    0x85                  /* Store r5    */
        .uleb128 0x4                   /*   at CFA-16 */
        .byte    0x86                  /* Store r6    */
        .uleb128 0x3                   /*   at CFA-12 */
        .byte    0x87                  /* Store r7    */
        .uleb128 0x2                   /*   at CFA-8  */
        .byte    0x88                  /* Store r8    */
        .uleb128 0x1                   /*   at CFA-4  */

        .byte    0x4                   /* Advance location */
        .4byte   .LCFI2 - .LCFI1       /*   to .LCFI2 */
        .byte    0xe                   /* Define CFA offset */
        .uleb128 0                     /*   to 0      */
        .byte    0x8                   /* Same value  */
        .uleb128 31                    /*   for ra    */
        .byte    0x8                   /* Same value  */
        .uleb128 4                     /*   for r4    */
        .byte    0x8                   /* Same value  */
        .uleb128 5                     /*   for r5    */
        .byte    0x8                   /* Same value  */
        .uleb128 6                     /*   for r6    */
        .byte    0x8                   /* Same value  */
        .uleb128 7                     /*   for r7    */
        .byte    0x8                   /* Same value  */
        .uleb128 8                     /*   for r8    */

        .align   2
2:

#endif

