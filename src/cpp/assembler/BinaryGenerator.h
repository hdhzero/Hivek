#ifndef HIVEK_ASSEMBLER_BINARY_GENERATOR_H
#define HIVEK_ASSEMBLER_BINARY_GENERATOR_H

#include "HivekAssembler.h"

namespace HivekAssembler {
    class BinaryGenerator {
        private:
            Table* table;
            std::ofstream file;

        private:
            uint32_t op2bin(Instruction& op);
            uint8_t get_byte(uint32_t v, int pos);
            void write32op(uint32_t inst);

            void generate_data();
            void generate_instructions();

        public:
            void set_table(Table* table);
            void generate_binary();
            void open(char* filename);
            void close();
    };
}

#endif

