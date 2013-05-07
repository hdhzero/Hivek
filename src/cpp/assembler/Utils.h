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
        SLL, SRL, SRA,
        LWR, SWR, LBR, SBR,
        CMPEQ, CMPLT, CMPGT, CMPLTU, CMPGTU,
        ANDP, ORP, XORP, NORP,

        //TYPE_Ib
        JR, JALR,

        // TYPE_II
        ADDI, ADCI, ADDIS, ADCIS,
        ANDI, ORI,
        CMPEQI, CMPLTI, CMPGTI, CMPLTUI, CMPGTUI,
        LW, SW, LB, SB,

        // TYPE_III
        JC, JCN, JALC, JALCN, 

        // TYPE_IV
        J, JAL

    };

    enum OperationType { 
        TYPE_I, TYPE_II, TYPE_III, TYPE_IV, TYPE_V,
        TYPE_Ib 
    };
}

#endif
