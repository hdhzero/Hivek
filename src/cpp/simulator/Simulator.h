#ifndef HIVEK_SIMULATOR_SIMULATOR_H
#define HIVEK_SIMULATOR_SIMULATOR_H

#include "HivekSimulator.h"

namespace HivekSimulator {
    class Simulator {
        private:
            int pc;
            int new_pc;
            int regs[32];
            bool pr_regs[4];
            int carry[2];
            bool status[32];
            bool j_taken;
            int sz;
            int new_sz;
            uint32_t instruction1;
            uint32_t instruction2;
            std::vector<uint8_t> instruction_memory;
            std::vector<uint8_t> data_memory;

        private:
            uint8_t str2byte(std::string& str);
            uint32_t expand(uint32_t n);
            uint32_t sign_ext(uint32_t v, int pos);
            uint32_t get_part(uint32_t operation, int end, int begin);
            void execute(uint32_t n, int u);

            bool cmpeq(uint32_t a, uint32_t b);
            bool cmplt(int32_t a, int32_t b);
            bool cmpgt(int32_t a, int32_t b);
            bool cmpltu(uint32_t a, uint32_t b);
            bool cmpgtu(uint32_t a, uint32_t b);


            void write_dmem(uint32_t v, uint32_t address, int bits);
            uint32_t read_dmem(uint32_t address, int bits);

            void fetch_instructions();
            void decode_instructions();
            void execute_instructions();
            void update_status();

        public:
            Simulator();

        public:
            void open(char* filename);
            void print_registers();
            void run();
            void reset();
            void dump_memory();
    };
}

#endif
