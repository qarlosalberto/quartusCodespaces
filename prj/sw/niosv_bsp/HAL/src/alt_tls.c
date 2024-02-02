/******************************************************************************
*                                                                             *
* License Agreement                                                           *
*                                                                             *
* Copyright (c) 2023 Intel Corporation, Santa Clara, California, USA.         *
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
* Intel does not recommend, suggest or require that this reference design     *
* file be used in conjunction or combination with any other product.          *
******************************************************************************/

#include <stdint.h>
#include <string.h>

#include "sys/alt_tls.h"

/* Linker defined symbols */
extern char __tbss_size[];     // Size of .tbss section
extern char __tdata_size[];    // Size of .tdata section
extern char __tdata_source[];  // Location of golden .tdata section to copy from
extern char __tdata_start[];   // Location of main thread .tdata section
extern char __tbss_start[];    // Location of main thread .tbss section

/* Assumes the .tbss section is mapped after the .tdata section by the linker script */
#define TBSS_BLOCK_OFFSET (uintptr_t)(__tbss_start - __tdata_start)

/*
 * alt_init_tls_block() is called to prepare a new threads thread-local storage.
 */
void alt_init_tls_block(void *tls_block_ptr)
{
    char *tdata_ptr = (char *)tls_block_ptr;
    char *tbss_ptr = tdata_ptr + TBSS_BLOCK_OFFSET;
    
    /* Zero out the thread local BSS data (*.tbss) */
	memset(tbss_ptr, '\0', (uintptr_t) __tbss_size);

	/* Create a copy of the intialized thread local data (*.tdata) */
	memcpy(tdata_ptr, __tdata_source, (uintptr_t) __tdata_size);
}

/*
 * alt_set_thread_pointer() is called to set the thread pointer to a specific
 * thread local storage block.  Useful when switching tasks.
 */
void alt_set_thread_pointer(void *tls_block_ptr)
{
    __asm__ volatile("mv tp, %[tls_reg]" :: [tls_reg] "r"(tls_block_ptr));
}
