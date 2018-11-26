#ifndef qxk_port_h
#define qxk_port_h

#include <sysreg.h>

// determination if the code executes in the ISR context
#define QXK_ISR_CONTEXT_() (sysreg_read(sysreg_IMASKP) != 0)

// trigger the PendSV exception to pefrom the context switch
#define QXK_CONTEXT_SWITCH_() \
    sysreg_bit_set(sysreg_IRPTL, BITM_REGF_IRPTL_SFT3I)

// QXK ISR entry and exit
#define QXK_ISR_ENTRY() ((void)0)

#define QXK_ISR_EXIT()  do { \
    QF_INT_DISABLE(); \
    if (QXK_sched_() != 0) { \
    	QXK_CONTEXT_SWITCH_(); \
    } \
    QF_INT_ENABLE(); \
} while (false)

// initialization of the QXK kernel
#define QXK_INIT() QXK_init()

extern void QXK_init(void);

#include "qxk.h" // QXK platform-independent public interface

#endif // qxk_port_h
