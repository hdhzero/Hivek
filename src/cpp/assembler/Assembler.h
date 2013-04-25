#ifndef HIVEK_ASSEMBLER_ASSEMBLER_H
#define HIVEK_ASSEMBLER_ASSEMBLER_H

#include "HivekAssembler.h"

namespace HivekAssembler {
    class Assembler {
        private:
            Table table;
            Parser parser;
            BinaryGenerator bin_gen;
        public:
            Assembler();

        public:
            void parse(char* filename);
            void generate_binary(char* filename);
    };
}

#endif
