/*
 * systick.c
 *
 *  Created on: Nov 25, 2018
 *      Author: Dean
 */

#include "systick.h"
#include <platform_include.h>
#include <services/tmr/adi_ctmr.h>
#include <sys/platform.h>

void SysTick_Config(uint32_t period)
{
	int _success;
	timer_off();
	timer_set(0u, 0u);

	__asm volatile ("TPERIOD=%1; %0=MODE2; %0=FEXT %0 by 5:1;"
	                    : "=&d" (_success) : "d" (period) : );
}

void SysTick_Enable(bool en)
{
	if(en){
		timer_on();
	}
	else{
		timer_off();
	}
}
