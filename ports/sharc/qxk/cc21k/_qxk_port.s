.SECTION/CODE/DOUBLEANY seg_pmco;

//TODO: save context and exit to activator
.GLOBAL __pendSV;
__pendSV:

#if 0
    /* disable interrupts */
    P1.H = ___imask;
    P1.L = ___imask;
    CLI R0;
    [P1] = R0;

	P1.H = _QXK_attr_;
	P1.L = _QXK_attr_;

	P0 = [P1+QXK_NEXT]; 			/*P0 = QXK_attr_.next */

	/* Check QXK_attr_.next, which contains the pointer to the next thread
    * to run, which is set in QXK_ISR_EXIT(). This pointer must not be NULL.
    */
	CC = P0 == 0;					/* is (QXK_attr_.next == 0)? */
    IF CC JUMP PendSV_return;		/* branch if (QXK_attr_.next == 0) */

    SAVE_CONTEXT;

    /* Load pointers into registers... */
    R7 = [P0+QMACTIVE_OSOBJ];		/* r7 := QXK_attr_.next->osObject */
    P2 = [P1+QXK_CURR]				/* P2 := QXK_attr_.curr */

    CC = P2 == 0;					/* (QXK_attr_.curr == 0)? */
	IF !CC JUMP PendSV_save_ex;      /* branch if (current thread is extended) */

    CC = R7 == 0;            		/* (QXK_attr_.next->osObject == 0)? */
    IF !CC JUMP PendSV_save_ao    	/* branch if (next tread is extended) */

PendSV_activate:
	/* The QXK activator must be called in a thread context, while this code
    * executes in the handler contex of the PendSV exception. The switch
    * to the Thread mode is accomplished by returning from PendSV using
    * a fabricated exception stack frame, where the return address is
    * QXK_activate_().
    *
    * NOTE: the QXK activator is called with interrupts DISABLED and also
    * it returns with interrupts DISABLED.
    */

    R0.H = _Thread_ret;
    R0.L = _Thread_ret;
    RETS = R0;					 /* return address after the call */
    
#endif
	
	// we want to return to the activator after this interrupt
	.EXTERN QXK_activate_.;
	PCSTK = QXK_activate_.;

	RTI (DB);
	NOP;
	NOP;
.__pendSV.end: