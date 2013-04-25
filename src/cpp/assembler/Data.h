#ifndef HIVEK_ASSEMBLER_DATA_H
#define HIVEK_ASSEMBLER_DATA_H

#include "HivekAssembler.h"

namespace HivekAssembler {
    class Data {
        public:
            int address;
            int size;
            int type;
            std::string name;
            std::string value;
    };
}

#endif
