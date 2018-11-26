#include "qf_port.h"

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

/* NOTE: keep in synch with the QXK_Attr struct in "qxk.h" !!! */
#define QXK_CURR       0
#define QXK_NEXT       4
#define QXK_ACT_PRIO   8
#define QXK_IDLE_THR   12

/* NOTE: keep in synch with the QXK_Attr struct in "qxk.h" !!! */
/*Q_ASSERT_COMPILE(QXK_CURR == offsetof(QXK_Attr, curr));*/
/*Q_ASSERT_COMPILE(QXK_NEXT == offsetof(QXK_Attr, next));*/
/*Q_ASSERT_COMPILE(QXK_ACT_PRIO == offsetof(QXK_Attr, actPrio));*/

/* NOTE: keep in synch with the QMActive struct in "qf.h/qxk.h" !!! */
#define QMACTIVE_OSOBJ 28
#define QMACTIVE_PRIO  36

/* NOTE: keep in synch with the QActive struct in "qf.h/qxk.h" !!! */
/*Q_ASSERT_COMPILE(QMACTIVE_OSOBJ == offsetof(QActive, osObject));*/
/*Q_ASSERT_COMPILE(QMACTIVE_PRIO == offsetof(QActive, prio));*/
