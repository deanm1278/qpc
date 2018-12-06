typedef struct
{
    unsigned int R0;
    unsigned int R1;
    unsigned int R2;
    unsigned int R3;
    unsigned int R4;
    unsigned int R5;
    unsigned int R6;
    unsigned int R7;
    unsigned int R8;
    unsigned int R9;
    unsigned int R10;
    unsigned int R11;
    unsigned int R12;
    unsigned int R13;
    unsigned int R14;
    unsigned int R15;
    unsigned int S0;
    unsigned int S1;
    unsigned int S2;
    unsigned int S3;
    unsigned int S4;
    unsigned int S5;
    unsigned int S6;
    unsigned int S7;
    unsigned int S8;
    unsigned int S9;
    unsigned int S10;
    unsigned int S11;
    unsigned int S12;
    unsigned int S13;
    unsigned int S14;
    unsigned int S15;

    unsigned int MR0F;
	unsigned int MR1F;
	unsigned int MR2F;
	unsigned int MR0B;
	unsigned int MR1B;
	unsigned int MR2B;

	unsigned int MS0F;
	unsigned int MS1F;
	unsigned int MS2F;
	unsigned int MS0B;
	unsigned int MS1B;
	unsigned int MS2B;

	unsigned int I0;
	unsigned int I1;
	unsigned int I2;
	unsigned int I3;
    unsigned int I4;
	unsigned int I5;
    unsigned int I6;
  //    unsigned int I7; I7 (SP) is stored in the task control block, so we don't need to store it here
	unsigned int I8;
	unsigned int I9;
	unsigned int I10;
	unsigned int I11;
    unsigned int I13;
    unsigned int I12;
	unsigned int I14;
	unsigned int I15;

	unsigned int M0;
	unsigned int M1;
	unsigned int M2;
	unsigned int M3;
    unsigned int M4;
    unsigned int M5;
    unsigned int M6;
    unsigned int M7;
	unsigned int M8;
	unsigned int M9;
	unsigned int M10;
	unsigned int M11;
    unsigned int M12;
    unsigned int M13;
    unsigned int M14;
    unsigned int M15;

	unsigned int B0;
	unsigned int B1;
	unsigned int B2;
	unsigned int B3;
    unsigned int B4;
	unsigned int B5;
    unsigned int B6;
    unsigned int B7;
	unsigned int B8;
	unsigned int B9;
	unsigned int B10;
	unsigned int B11;
    unsigned int B12;
    unsigned int B13;
	unsigned int B14;
	unsigned int B15;

    unsigned int L15;
    unsigned int L14;
    unsigned int L13;
    unsigned int L12;
    unsigned int L11;
    unsigned int L10;
    unsigned int L9;
    unsigned int L8;
    unsigned int L7;
    unsigned int L6;
    unsigned int L5;
    unsigned int L4;
    unsigned int L3;
    unsigned int L2;
    unsigned int L1;
    unsigned int L0;

    unsigned int BitFIFO_1;
	unsigned int BitFIFO_0;
	unsigned int BitFIFOWRP;

	unsigned int ASTATy;
    unsigned int ASTATx;
    unsigned int STKYy;
    unsigned int STKYx;
    unsigned int MODE1;
    unsigned int USTAT4;
    unsigned int USTAT3;
    unsigned int USTAT2;
    unsigned int USTAT1;
    unsigned int PCSTK;

    unsigned int PX2;
    unsigned int PX1;
 //   unsigned int RTI;                 /* Saved by the RTL on interrupt entry - Sequence must not be changed */
} ContextRecord;
