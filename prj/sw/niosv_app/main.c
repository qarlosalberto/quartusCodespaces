#include <stdio.h>
#include <system.h>
#include <io.h>
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_sysid_qsys_regs.h"
#include <unistd.h>

// Using usleep as the delay funciton
        int usleep(useconds_t usec);

	int pio_test();

	int pio ()
	{


		int count = 0;
                int i;
		int pio_err = 0;
                printf("Application to toggle the PIOs- [4:0] \n");

                while(count < 64)
                {
                        i = count&0xf;
                        IOWR_ALTERA_AVALON_PIO_DATA(PIO_0_BASE,count&0xf);
                        usleep(100);
                        printf("DATA READBACK FROM PIO_0_BASE is 0x%x \n",IORD_ALTERA_AVALON_PIO_DATA(PIO_0_BASE));

                        if (i != IORD_ALTERA_AVALON_PIO_DATA(PIO_0_BASE))
                        {

                                printf("Data MISMATCH - TEST FAILED \n");
				pio_err = pio_err + 1;
                        }
                        else
                        {
                                printf ("DATA MATCHED - TEST PASSED \n");
                        }
                count++;
                }


	return pio_err;


	}



	int main () 
	{
		int pio_fail_flag;
		int sys_id;

		pio_fail_flag = pio();
		
		if ((pio_fail_flag != 0)  )
		{

			printf ("NIOSV-PIO Test failed with PIO_ERR = %d\n",pio_fail_flag);
		}
		else
		{
			
			printf ("NIOSV-PIO Test PASSED \n");
		}	

		printf ("Print the value of System ID \n");
		sys_id = IORD_ALTERA_AVALON_SYSID_QSYS_ID(SYSID_QSYS_0_BASE);
		printf ("System ID from Peripheral core is 0x%X \n",sys_id);

		return 0;  
      }


		
