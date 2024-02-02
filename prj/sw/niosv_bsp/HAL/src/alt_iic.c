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
/*
 * This file implements the HAL Enhanced interrupt API for Abbott's Lake processors
 * with an internal interrupt controller (IIC).
 */

#include "sys/alt_irq.h"
#include "priv/alt_iic_isr_register.h"
                            
/** @Function Description:  This function registers an interrupt handler. 
  * If the function is succesful, then the requested interrupt will be enabled upon 
  * return. Registering a NULL handler will disable the interrupt.
  * @API Type:              External
  * @param ic_id            Ignored.
  * @param irq              IRQ number
  * @return                 0 if successful, else error (-1)
  */
int 
alt_ic_isr_register(alt_u32 ic_id, alt_u32 irq, alt_isr_func isr, 
  void *isr_context, void *flags)
{
    return alt_iic_isr_register(ic_id, irq, isr, isr_context, flags);
}  
