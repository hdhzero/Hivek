#ifndef HIVEK_SIMULATOR_SIMULATOR_H
#define HIVEK_SIMULATOR_SIMULATOR_H

#include "HivekSimulator.h"

namespace HivekSimulator {
    class Simulator {
        private:
            int pc;
            int regs[32];
            bool status[32];
            bool jump;
            bool j_taken;
            int sz;
            int new_sz;
            uint32_t instruction1;
            uint32_t instruction2;
            std::vector<uint8_t> instruction_memory;
            std::vector<uint8_t> data_memory;

        private:
            uint8_t str2byte(std::string& str);
/*            uint32_t expand(uint32_t n);

            void fetch_instructions();
            void decode_instructions();
            void execute_instructions();

        public:
            Simulator();*/

        public:
            void open(char* filename);
    };
}

#endif
