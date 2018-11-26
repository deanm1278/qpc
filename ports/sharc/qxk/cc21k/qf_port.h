#ifndef qf_port_h
#define qf_port_h

#include <interrupt.h>

// The maximum number of active objects in the application, see NOTE1
#define QF_MAX_ACTIVE           32

// The maximum number of system clock tick rates
#define QF_MAX_TICK_RATE        2

// QF interrupt disable/enable and log2()...
#define QF_LOG2(n_) ((uint_fast8_t)(32 - __builtin_leftz(n_)))

// interrupt disabling policy
#define QF_INT_DISABLE() disable_interrupts()
#define QF_INT_ENABLE()  enable_interrupts()

// QF critical section entry/exit (unconditional interrupt disabling)
//#define QF_CRIT_STAT_TYPE not defined
#define QF_CRIT_ENTRY(dummy) QF_INT_DISABLE()
#define QF_CRIT_EXIT(dummy)  QF_INT_ENABLE()

//TODO: these
// BASEPRI threshold for "QF-aware" interrupts
#define QF_BASEPRI           0

// CMSIS threshold for "QF-aware" interrupts
#define QF_AWARE_ISR_CMSIS_PRI 0

//TODO: should we do this?
#define QF_CRIT_EXIT_NOP()      __asm volatile ("NOP;")

#include "qep_port.h" // QEP port

#include "qxk_port.h" // QXK dual-mode kernel port
#include "qf.h"       // QF platform-independent public interface
#include "qxthread.h" // QXK extended thread

//****************************************************************************
// NOTE1:
// The maximum number of active objects QF_MAX_ACTIVE can be increased
// up to 64, if necessary. Here it is set to a lower level to save some RAM.
//

#endif // qf_port_h
