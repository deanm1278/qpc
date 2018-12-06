#include <platform_include.h>
#include <asm_sprt.h>

.import "context_record.h";

#define LOC(X) (OFFSETOF(ContextRecord, X)   / SIZEOF(int))
#define CONTEXT_RECORD_SIZE   (SIZEOF(ContextRecord)  / SIZEOF(int))

/* NOTE: keep in synch with the QXK_Attr struct in "qxk.h" !!! */
#define QXK_CURR       0
#define QXK_NEXT       1
#define QXK_ACT_PRIO   2
#define QXK_IDLE_THR   3

/* NOTE: keep in synch with the QXK_Attr struct in "qxk.h" !!! */
/*Q_ASSERT_COMPILE(QXK_CURR == offsetof(QXK_Attr, curr));*/
/*Q_ASSERT_COMPILE(QXK_NEXT == offsetof(QXK_Attr, next));*/
/*Q_ASSERT_COMPILE(QXK_ACT_PRIO == offsetof(QXK_Attr, actPrio));*/

.SECTION/DATA/DOUBLEANY seg_dmda;
.VAR  __QXKSaveI7;
.VAR  __QXKSaveB7;

.SECTION/CODE/DOUBLEANY seg_pmco;


/*****************************************************************************
* The NMI_Handler exception handler is used for returning back to the
* interrupted task. The NMI exception restores the context of the preemted
* task.
*
* NOTE: The NMI exception is entered with interrupts DISABLED, so it needs
* to re-enable interrupts before it returns to the preempted task.
*****************************************************************************/
.GLOBAL __NMI_Handler;
__NMI_Handler:

	/* RESTORE THE CONTEXT */
	
	  /* We restore the multiplier result registers now, before MODE1
     * has been restored, i.e. while the SRCU bit is still clear.
     * ASTAT is restored later, so it doesn't matter that loading
     * the MR registers will clear the M* flag bits.
     * Because the PEy multiplier registers cannot be accessed directly, we
     * need to do the restoring in SIMD but in order not to force the stack to
     * be in internal memory we copy from memory in non-SIMD mode.
     */
    S5 = DM(LOC(MS2B), I7);
    R5 = DM(LOC(MR2B), I7);
    S4 = DM(LOC(MS1B), I7);
    R4 = DM(LOC(MR1B), I7);
    S3 = DM(LOC(MS0B), I7);
    R3 = DM(LOC(MR0B), I7);
    S2 = DM(LOC(MS2F), I7);
    R2 = DM(LOC(MR2F), I7);
    S1 = DM(LOC(MS1F), I7);
    R1 = DM(LOC(MR1F), I7);
    S0 = DM(LOC(MS0F), I7);
    R0 = DM(LOC(MR0F), I7);

    BIT SET MODE1 BITM_REGF_MODE1_PEYEN;    /* Restore the multiplier registers. The only way is
                                         to use SIMD because the PEy registers cannot be
                                         used directly */
    NOP;
    MR0F = R0;
    MR1F = R1;
    MR2F = R2;
    MR0B = R3;
    MR1B = R4;
    MR2B = R5;

    BIT CLR MODE1 BITM_REGF_MODE1_PEYEN;
    NOP;
	
	/* DAG2 High registers, load using I7 */	
	B15  = DM(LOC(B15), I7);
	B14  = DM(LOC(B14), I7);
    B13  = DM(LOC(B13), I7);
    B12  = DM(LOC(B12), I7);
    L15  = DM(LOC(L15), I7);
    L14  = DM(LOC(L14), I7);
    L13  = DM(LOC(L13), I7);
    L12  = DM(LOC(L12), I7);
	M15  = DM(LOC(M15), I7);
	M14  = DM(LOC(M14), I7);
	M13  = DM(LOC(M13), I7);
	M12  = DM(LOC(M12), I7);
	I15  = DM(LOC(I15), I7);
	I14  = DM(LOC(I14), I7);
    I13  = DM(LOC(I13), I7);
    I12  = DM(LOC(I12), I7);
    
	/* DAG2 Low registers, load using I7 */	
	B11  = DM(LOC(B11), I7);
	B10  = DM(LOC(B10), I7);
	B9   = DM(LOC(B9),  I7);
	B8   = DM(LOC(B8),  I7);
    L11  = DM(LOC(L11), I7);
    L10  = DM(LOC(L10), I7);
    L9   = DM(LOC(L9),  I7);
    L8   = DM(LOC(L8),  I7);
	M11  = DM(LOC(M11), I7);
	M10  = DM(LOC(M10), I7);
	M9   = DM(LOC(M9),  I7);
	M8   = DM(LOC(M8),  I7);
	I11  = DM(LOC(I11), I7);
	I10  = DM(LOC(I10), I7);
	I9   = DM(LOC(I9),  I7);
	I8   = DM(LOC(I8),  I7);
	
	I12 = I7					; // copy I7' to I12
	
	/* DAG1 High registers, load using I12 */	
    B7   = PM(LOC(B7), I12);       /* clobbers I7' */
    B6   = PM(LOC(B6), I12);
	B5   = PM(LOC(B5), I12);
    B4   = PM(LOC(B4), I12);
    L7   = PM(LOC(L7), I12);
    L6   = PM(LOC(L6), I12);
    L5   = PM(LOC(L5), I12);
    L4   = PM(LOC(L4), I12);
    M7   = PM(LOC(M7), I12);
    M6   = PM(LOC(M6), I12);
    M5   = PM(LOC(M5), I12);
    M4   = PM(LOC(M4), I12);
    I6   = PM(LOC(I6), I12);
    I7   = I12;                   // copy I12 to I7'

	I5   = PM(LOC(I5), I12);
    I4   = PM(LOC(I4), I12);
    
	/* DAG1 Low registers, load using I12 */	
	B3   = PM(LOC(B3), I12);
	B2   = PM(LOC(B2), I12);
	B1   = PM(LOC(B1), I12);
	B0   = PM(LOC(B0), I12);      
    L3   = PM(LOC(L3), I12);
    L2   = PM(LOC(L2), I12);
    L1   = PM(LOC(L1), I12);
    L0   = PM(LOC(L0), I12);   
	M3   = PM(LOC(M3), I12);
	M2   = PM(LOC(M2), I12);
	M1   = PM(LOC(M1), I12);
	M0   = PM(LOC(M0), I12);      
	I3   = PM(LOC(I3), I12);
	I2   = PM(LOC(I2), I12);
	I1   = PM(LOC(I1), I12);
	I0   = PM(LOC(I0), I12);     
	
    /* Restore the bit fifo */
    R2 = DM(LOC(BitFIFO_1),  I7);
    R1 = DM(LOC(BitFIFO_0),  I7);
    R0 = DM(LOC(BitFIFOWRP), I7);                        
    
    BFFWRP = 0;
    BITDEP R2 BY 32;
    BITDEP R1 BY 32;
    BFFWRP = R0;
			 
    R15 = DM(LOC(R15), I7);
    R14 = DM(LOC(R14), I7);
    R13 = DM(LOC(R13), I7);
    R12 = DM(LOC(R12), I7);
    R11 = DM(LOC(R11), I7);
    R10 = DM(LOC(R10), I7);
    R9  = DM(LOC(R9),  I7);
    R8  = DM(LOC(R8),  I7);
    R7  = DM(LOC(R7),  I7);
    R6  = DM(LOC(R6),  I7);
    R5  = DM(LOC(R5),  I7);
    //R4  = DM(LOC(R4),  I7);    /* used to restore interrupts */
    R3  = DM(LOC(R3),  I7);    
    R2  = DM(LOC(R2),  I7);
    R1  = DM(LOC(R1),  I7);
    R0  = DM(LOC(R0),  I7);             /* Save off the primary ALU registers */

    S15 = DM(LOC(S15), I7);
    S14 = DM(LOC(S14), I7);
    S13 = DM(LOC(S13), I7);
    S12 = DM(LOC(S12), I7);
    S11 = DM(LOC(S11), I7);
    S10 = DM(LOC(S10), I7);
    S9  = DM(LOC(S9),  I7);
    S8  = DM(LOC(S8),  I7);
    S7  = DM(LOC(S7),  I7);
    S6  = DM(LOC(S6),  I7);
    S5  = DM(LOC(S5),  I7);
    S4  = DM(LOC(S4),  I7);
    S3  = DM(LOC(S3),  I7);
    S2  = DM(LOC(S2),  I7);
    S1  = DM(LOC(S1),  I7);
    S0  = DM(LOC(S0),  I7);
      
	// Restore the user status registers
    USTAT4 = DM(LOC(USTAT4), I7);
    USTAT3 = DM(LOC(USTAT3), I7);
    USTAT2 = DM(LOC(USTAT2), I7);
    USTAT1 = DM(LOC(USTAT1), I7);

	// Restore the status registers, via the status stack
    ASTATy = DM(LOC(ASTATy), I7);       /* Restore ASTATx and ASTATy. */
    ASTATx = DM(LOC(ASTATx), I7);
    STKYy  = DM(LOC(STKYy),  I7);        /* Restore the STKY flags, nothing that we do from here on out should change these */
    STKYx   = DM(LOC(STKYx), I7); 
    
    PCSTK   = DM(LOC(PCSTK), I7); 	/* Restore clobbered return address */
    
	// restore interrupts
	.EXTERN _qxk_imask.;
	R4 = DM(_qxk_imask.);
	IMASK = R4;
    
    R4  = DM(LOC(R4),  I7);  	/* restore R4 */
    MODIFY(I7, CONTEXT_RECORD_SIZE) (NW); /* will raise CB7I if stack underflows */
	
	NOP;
	NOP;
	NOP;
	NOP;
	RTI;
	
__NMI_Handler.end:

.GLOBAL __pendSV;
__pendSV:
	BIT CLR MODE1 BITM_REGF_MODE1_IRPTEN;

    DM(__QXKSaveI7) = I7;
	DM(__QXKSaveB7) = B7;
	I7 = W2B(I7);
	B7 = W2B(B7);
	
	MODIFY(I7, - CONTEXT_RECORD_SIZE) (NW); /* Allocate since we may need to context switch
											   use NW because CONTEXT_RECORD_SIZE is in words */
	// save some scratch registers
	DM(LOC(I10), I7) = I10;
	DM(LOC(R4), I7) = R4;
	DM(LOC(R8), I7) = R8;
	R8 = 0;
	
	.EXTERN QXK_attr_.;
	I10 = QXK_attr_.;
	R4 = PM(QXK_NEXT, I10);			/*R4 = QXK_attr_.next */
	
	/* Check QXK_attr_.next, which contains the pointer to the next thread
    * to run, which is set in QXK_ISR_EXIT(). This pointer must not be NULL.
    */
    R4 = R4 - R8;
    IF EQ JUMP PendSV_return;		/* branch if (QXK_attr_.next == 0) */
	
	/* SAVE THE CONTEXT */
	
	/* Save all registers that are part of the status stack */
    DM(LOC(MODE1), I7) = MODE1STK; /* save MODE1 from the copy on the status stack */
    DM(LOC(STKYx), I7) = STKYx;
    DM(LOC(STKYy), I7) = STKYy;
    DM(LOC(PX1), I7) = PX1;
    DM(LOC(PX2), I7) = PX2;
    
	/* Save the user status registers */
    DM(LOC(USTAT1), I7) = USTAT1;
    DM(LOC(USTAT2), I7) = USTAT2;
    DM(LOC(USTAT3), I7) = USTAT3;
    DM(LOC(USTAT4), I7) = USTAT4;
    
    /* Save the RETI address we are gonna clobber */
    DM(LOC(PCSTK), I7) = PCSTK;
    
    /* Save the DAG2 Low registers (8..11) using task I7 */
    DM(LOC(I8),  I7) = I8;  /* I regs */
    DM(LOC(I9),  I7) = I9;
    // DM(LOC(I10), I7) = I10; // already saved
    DM(LOC(I11), I7) = I11;
	DM(LOC(L8),  I7) = L8;  /* L regs */
    DM(LOC(L9),  I7) = L9;
    DM(LOC(L10), I7) = L10;
    DM(LOC(L11), I7) = L11;
    DM(LOC(B8),  I7) = B8;  /* B regs */
    DM(LOC(B9),  I7) = B9;
    DM(LOC(B10), I7) = B10;
    DM(LOC(B11), I7) = B11;
    DM(LOC(M8),  I7) = M8;  /* M regs */
    DM(LOC(M9),  I7) = M9;
    DM(LOC(M10), I7) = M10;
    DM(LOC(M11), I7) = M11;
    
    /* Save the DAG2 High (12..15) registers */
    DM(LOC(I12), I7) = I12; /* I regs */
    DM(LOC(I13), I7) = I13;
    DM(LOC(I14), I7) = I14;
    DM(LOC(I15), I7) = I15;
    DM(LOC(L12), I7) = L12; /* L regs */
    DM(LOC(L13), I7) = L13;
    DM(LOC(L14), I7) = L14;
    DM(LOC(L15), I7) = L15;
    DM(LOC(B12), I7) = B12; /* B regs */
    DM(LOC(B13), I7) = B13;
    DM(LOC(B14), I7) = B14;
    DM(LOC(B15), I7) = B15;
    DM(LOC(M12), I7) = M12; /* M regs */
    DM(LOC(M13), I7) = M13;
    DM(LOC(M14), I7) = M14;
    DM(LOC(M15), I7) = M15;
    
	// I12 has been saved, above, so we can use it as a copy of I7
	// for saving DAG1 registers
	I12 = I7;
		
    /* Save the DAG1 Low registers (0..3) using i12 */
    PM(LOC(I0), I12) = I0;  /* I regs */
    PM(LOC(I1), I12) = I1;
    PM(LOC(I2), I12) = I2;
    PM(LOC(I3), I12) = I3;
    PM(LOC(L0), I12) = L0;  /* L regs */
    PM(LOC(L1), I12) = L1;
    PM(LOC(L2), I12) = L2;
    PM(LOC(L3), I12) = L3;
    PM(LOC(B0), I12) = B0;  /* B regs */
    PM(LOC(B1), I12) = B1;
    PM(LOC(B2), I12) = B2;
    PM(LOC(B3), I12) = B3;
    PM(LOC(M0), I12) = M0;  /* M regs */
    PM(LOC(M1), I12) = M1;
    PM(LOC(M2), I12) = M2;
    PM(LOC(M3), I12) = M3;

    /* Save the DAG1 High (4..7) registers */
    PM(LOC(I4), I12) = I4;  /* I regs */
    PM(LOC(I5), I12) = I5;
    PM(LOC(I6), I12) = I6;
 // PM(LOC(I7), I12) = I7;      /* We do not need to save I7 here */
    PM(LOC(L4), I12) = L4;  /* L regs */
    PM(LOC(L5), I12) = L5;
    PM(LOC(L6), I12) = L6;
    PM(LOC(L7), I12) = L7;
    PM(LOC(B4), I12) = B4;  /* B regs */
    PM(LOC(B5), I12) = B5;
    PM(LOC(B6), I12) = B6;
    PM(LOC(B7), I12) = B7;
    PM(LOC(M4), I12) = M4;  /* M regs */
    PM(LOC(M5), I12) = M5;
    PM(LOC(M6), I12) = M6;
    PM(LOC(M7), I12) = M7;
    
	/* Save the data registers */
    DM(LOC(R0),  I7) = R0;
    DM(LOC(R1),  I7) = R1;
    DM(LOC(R2),  I7) = R2;
    DM(LOC(R3),  I7) = R3;
    // DM(LOC(R4),  I7) = R4; /* already saved */
    DM(LOC(R5),  I7) = R5;
    DM(LOC(R6),  I7) = R6;
    DM(LOC(R7),  I7) = R7;
    // DM(LOC(R8),  I7) = R8; /* already saved */
    DM(LOC(R9),  I7) = R9;
    DM(LOC(R10), I7) = R10;
    DM(LOC(R11), I7) = R11;
    DM(LOC(R12), I7) = R12;
    DM(LOC(R13), I7) = R13;
    DM(LOC(R14), I7) = R14;
    DM(LOC(R15), I7) = R15; 
    DM(LOC(S0),  I7) = S0;
    DM(LOC(S1),  I7) = S1;
    DM(LOC(S2),  I7) = S2;
    DM(LOC(S3),  I7) = S3;
    DM(LOC(S4),  I7) = S4;
    DM(LOC(S5),  I7) = S5;
    DM(LOC(S6),  I7) = S6;
    DM(LOC(S7),  I7) = S7;
    DM(LOC(S8),  I7) = S8;
    DM(LOC(S9),  I7) = S9;
    DM(LOC(S10), I7) = S10;
    DM(LOC(S11), I7) = S11;
    DM(LOC(S12), I7) = S12;
    DM(LOC(S13), I7) = S13;
    DM(LOC(S14), I7) = S14;
    DM(LOC(S15), I7) = S15;
    
    BIT SET MODE1 BITM_REGF_MODE1_PEYEN;    /* Save the multiplier registers. The only way is
	                                       to use SIMD because the PEy registers cannot be
	                                       used directly */
    NOP;
    R0 = MR0F;
    R1 = MR1F;
    R2 = MR2F;
    R3 = MR0B;
    R4 = MR1B;
    R5 = MR2B;
    BIT CLR MODE1 BITM_REGF_MODE1_PEYEN;    /* Back to SISD to do the actual stores to memory */
    NOP;
    //WA_15000004_1NOP

    DM(LOC(MS0F), I7)   = S0;
    DM(LOC(MS1F), I7)   = S1;
    DM(LOC(MS2F), I7)   = S2;
    DM(LOC(MS0B), I7)   = S3;
    DM(LOC(MS1B), I7)   = S4;
    DM(LOC(MS2B), I7)   = S5;

    DM(LOC(MR0F), I7)   = R0;
    DM(LOC(MR1F), I7)   = R1;
    DM(LOC(MR2F), I7)   = R2;
    DM(LOC(MR0B), I7)   = R3;
    DM(LOC(MR1B), I7)   = R4;
    DM(LOC(MR2B), I7)   = R5;        
     
    R0 = BFFWRP;                                       /* Save the bit fifo */
    BFFWRP = 64;
    R1 = BITEXT 32;
    R2 = BITEXT 32;
    DM(LOC(BitFIFOWRP), I7) = R0;
    DM(LOC(BitFIFO_0),  I7) = R1;
    DM(LOC(BitFIFO_1),  I7) = R2;
    
	// Save the top of the status stack. We assume that only one entry in the status stack
	// is in use, since it should only be used by interrupt entry & exit and since the
	// reschedule interrupt should be the lowest-priority interrupt in the system.
	//
	// We have to ensure that MODE1 doesn't change when we pop the status stack, so we
	// replace the stacked MODE1 value with the current value.
	MODE1STK = MODE1; // MODE1STK has already been saved to the context record, above
    POP STS;                // no effect delay (ToDo: check this)
	DM(LOC(ASTATx), I7) = ASTATX;	
	DM(LOC(ASTATy), I7) = ASTATY;	

#if 0
	//TODO: this stuff

    /* Load pointers into registers... */
    R7 = [P0+QMACTIVE_OSOBJ];		/* r7 := QXK_attr_.next->osObject */
    P2 = [P1+QXK_CURR]				/* P2 := QXK_attr_.curr */

    CC = P2 == 0;					/* (QXK_attr_.curr == 0)? */
	IF !CC JUMP PendSV_save_ex;      /* branch if (current thread is extended) */

    CC = R7 == 0;            		/* (QXK_attr_.next->osObject == 0)? */
    IF !CC JUMP PendSV_save_ao    	/* branch if (next tread is extended) */
    
#endif

	.EXTERN QXK_activate_.;
	PCSTK = QXK_activate_.; 	  // we want to return to the activator after this interrupt
	
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
    
    R2 = I6;
    I6 = I7;
    .EXTERN _Thread_ret.;
	R4 = _Thread_ret.-1;
	
	DM(I7, M7) = R2;
	DM(I7, M7) = R4;
	NOP;
	NOP;
	NOP;
	RTI;
	
PendSV_return:
	// restore scratch registers and deallocate context record
	I10 = DM(LOC(I10), I7);
	R4 = DM(LOC(R4), I7);
	R8 = DM(LOC(R8), I7);
	
	MODIFY(I7, CONTEXT_RECORD_SIZE) (NW); /* deallocate context record */
	
	NOP;
	NOP;
	NOP;
	NOP;
	RTI;

.__pendSV.end: