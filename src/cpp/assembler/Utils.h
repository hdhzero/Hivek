#ifndef HIVEK_ASSEMBLER_UTILS_H
#define HIVEK_ASSEMBLER_UTILS_H

#include "HivekAssembler.h"

namespace HivekAssembler {
    enum MultiOpSize {
        MULTI_OP1x16, MULTI_OP1x32, MULTI_OP2x16, MULTI_OP2x32 
    };

    enum DataType { 
        DATA_ASCII, DATA_INT32 
    };

    enum OperationFunc { 
        // TYPE_I
        ADD, SUB, ADC, SBC, ADDS, ADCS, SUBS, SBCS, 
        AND, OR, NOR, XOR,
        SLLV, SRLV, SRAV,
        CMPEQ, CMPLT, CMPGT, CMPLTU, CMPGTU,
        ANDP, ORP, XORP, NORP,

        //TYPE_Ib
        JR, JALR,

        //TYPE_Ic
        SHADD,

        // TYPE_II
        ADDI, ADCI, ADDIS, ADCIS,
        ANDI, ORI,
        CMPEQI, CMPLTI, CMPGTI, CMPLTUI, CMPGTUI,
        LW, SW, LB, SB,

        // TYPE_III
        JC, JCN, JALC, JALCN, 

        // TYPE_IV
        J, JAL,

        // Type14
        ADD14, SUB14, AND14, OR14, ADDHI14, SUBHI14,
        CMPEQ14, CMPLT14, CMPGT14,
        ADDI14, MOVI14, LWSP14, SWSP14, LW14, SW14, MOV14,
        JC14, JCN14
    };

    enum OperationType { 
        TYPE_I, TYPE_II, TYPE_III, TYPE_IV, TYPE_V,
        TYPE_Ib, TYPE_Ic, TYPE14
    };

    enum ShiftType {
        SLL = 1, SRL = 2, SRA = 3
    };
}

#endif
