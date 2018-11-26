/*
 * systick.h
 *
 *  Created on: Nov 25, 2018
 *      Author: Dean
 */

#ifndef QPC_3RD_PARTY_SHARC_CC21K_SYSTICK_H_
#define QPC_3RD_PARTY_SHARC_CC21K_SYSTICK_H_

#include <stdint.h>

void SysTick_Config(uint32_t period);

void SysTick_Enable(bool en);

#endif /* QPC_3RD_PARTY_SHARC_CC21K_SYSTICK_H_ */
