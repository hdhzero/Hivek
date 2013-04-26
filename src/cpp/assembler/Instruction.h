#ifndef HIVEK_ASSEMBLER_OPERATION_H
#define HIVEK_ASSEMBLER_OPERATION_H

#include "HivekAssembler.h"

namespace HivekAssembler {
    class Instruction {
        public:
            int address; // addres where it appears
            int size;    // 16 bits or 32 bits
            int operation; 
            int type;
            int predicate_register;
            int predicate_value;
            int destination; // rs or rd
            int operand1; // rs
            int operand2; // rt or immd
            int operand3; // for shamt ammount
            std::string label;
    };
}

#endif
