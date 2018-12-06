#include "qf_port.h"

uint32_t _qxk_imask;

/* prototypes --------------------------------------------------------------*/
void QXK_stackInit_(void *act, QActionHandler thread,
                    void *stkSto, uint_fast16_t stkSize);

/*
* Initialize the exception priorities and IRQ priorities to safe values.
*
* Description:
* On Cortex-M3/M4/M7, this QXK port disables interrupts by means of the
* BASEPRI register. However, this method cannot disable interrupt
* priority zero, which is the default for all interrupts out of reset.
* The following code changes the SysTick priority and all IRQ priorities
* to the safe value QF_BASEPRI, wich the QF critical section can disable.
* This avoids breaching of the QF critical sections in case the
* application programmer forgets to explicitly set priorities of all
* "kernel aware" interrupts.
*
* The interrupt priorities established in QXK_init() can be later
* changed by the application-level code.
*/
// TODO:
void QXK_init(void) {
	// enable pendsv interrupt
	sysreg_bit_set(sysreg_IMASK, BITM_REGF_IMASK_SFT3I);
	sysreg_bit_set(sysreg_IMASK, BITM_REGF_IMASK_SFT2I);
}

/*****************************************************************************
* Initialize the private stack of an extended QXK thread.
*
* NOTE: the function aligns the stack to the 8-byte boundary for compatibility
* with the AAPCS. Additionally, the function pre-fills the stack with the
* known bit pattern (0xDEADBEEF).
*
* NOTE: QXK_stackInit_() must be called before the QXK kernel is made aware
* of this thread. In that case the kernel cannot use the thread yet, so no
* critical section is needed.
****************************************************************************/
// TODO:
void QXK_stackInit_(void *act, QActionHandler thread,
                    void *stkSto, uint_fast16_t stkSize)
{
    extern void QXK_threadRet_(void); /* extended thread return */
}

/*****************************************************************************
* Thread_ret is a helper function executed when the QXK activator returns.
*
* NOTE: Thread_ret does not execute in the PendSV context!
* NOTE: Thread_ret executes entirely with interrupts DISABLED.
*****************************************************************************/
#pragma noreturn
void _Thread_ret(void){
	_qxk_imask = sysreg_read(sysreg_IMASK);
	sysreg_write(sysreg_IMASK, BITM_REGF_IRPTL_SFT2I);
	QF_INT_ENABLE();
	sysreg_bit_set(sysreg_IRPTL, BITM_REGF_IRPTL_SFT2I);
	while(1);
}

/* NOTE: keep in synch with the QMActive struct in "qf.h/qxk.h" !!! */
#define QMACTIVE_OSOBJ 28
#define QMACTIVE_PRIO  36

/* NOTE: keep in synch with the QActive struct in "qf.h/qxk.h" !!! */
/*Q_ASSERT_COMPILE(QMACTIVE_OSOBJ == offsetof(QActive, osObject));*/
/*Q_ASSERT_COMPILE(QMACTIVE_PRIO == offsetof(QActive, prio));*/
