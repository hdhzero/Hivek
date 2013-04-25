#ifndef HIVEK_ASSEMBLER_MULTI_INSTRUCTION_H
#define HIVEK_ASSEMBLER_MULTI_INSTRUCTION_H

#include "HivekAssembler.h"

namespace HivekAssembler {
    class MultiInstruction {
        public:
            int size;
            Instruction inst1;
            Instruction inst2;
    };
}

#endif

