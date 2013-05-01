#include "HivekSimulator.h"

namespace HivekSimulator {
    uint8_t Simulator::str2byte(std::string& str) {
        uint8_t v = 0;

        for (int i = 7; i >= 0; --i) {
            v |= (str[7 - i] - '0') << i;
        }

        return v;
    }

    void Simulator::open(char* filename) {
        uint8_t v;
        std::string str;
        std::ifstream file;

        file.open(filename);

        while (file.good()) {
            file >> str;
            v = str2byte(str);
            instruction_memory.push_back(v);
        }

        file.close();

        for (int i = 0; i < instruction_memory.size(); ++i) {
            std::cout << (unsigned int) instruction_memory[i] << std::endl;
        }
    }

/*
    void Simulator::fetch_instructions() {
        uint32_t instruction1;
        uint32_t instruction2;

        instruction1  = instruction_memory[pc] << 24;
        instruction1 |= instruction_memory[pc + 1] << 16;
        instruction1 |= instruction_memory[pc + 2] << 8;
        instruction1 |= instruction_memory[pc + 3];

        instruction2  = instruction_memory[pc + 4] << 24;
        instruction2 |= instruction_memory[pc + 5] << 16;
        instruction2 |=instruction_memory[pc + 6] << 8;
        instruction2 |= instruction_memory[pc + 7];

        if (j_taken) {
            pc += pc + 8;
            j_taken = false;
        } else {
            switch ((instruction1 & 0xC0000000) >> 30) {
                case 0:
                    pc += 2; break;
                case 1:
                case 2:
                    pc += 4; break;
                case 3:
                    pc += 8; break;
                default:
                    break;
            }
        }

        sz = new_sz;
        new_sz = instruction1 & 0xC0000000;
    }

    void Simulator::decode_instructions() {
        if (sz == 0) {
            instruction1 = expand(instruction1);
            instruction2 = NOP;
        } else if (sz == 2) {
            instruction1 = expand(instruction1 >> 16);
            instruction2 = expand(instruction1 & 0xFFFF);
        } else if (sz == 1) {
            instruction2 = NOP;
        }
    }

    uint32_t Simulator::expand(uint32_t n) {
        // if jump
        // 00 1pccc 000 000 000
        // 00 001 l p iiiii ccc
        if (n & 0x2000) {
            if (n & 0x100) {
                immd22 = 0x3FFE00 | (n & 0x1FF);
            } else {
                immd22 = n & 0x1FF;
            }

            n = 0x0FC00000 | immd22 | cond;
        } else {
            switch (n & 0xff >> 0) {
                case ADD:
                    n = 0x0F123123 | rd | rs | rt | 0x04; break;
            }
        }

        return n;
    }

    void Simulator::execute_instructions() {
        execute(instruction1);

        if (execute_parallel) {
            execute(instruction2);
        }   
    }

    void Simulator::execute(uint32_t n) {
        int preg = n & 0x03;
        int pv   = (n & 0x04) >> 2;

        bool exec = pr_regs[preg] == pv;

        if (0x20000000 & n == 0) {
            operation = (n & 0x1E000000) >> 25;
            exec = 
        } else if (j_uncond) {
            exec = true;
        }


        if (exec) 
        switch (operation) {
            case ADD:
                regs[rd] = regs[rs] + regs[rt];
                break;
            case ADC:
                regs[rd] = regs[rs] + regs[rt];
                carry[bank] = regs[rd] < regs[rs];
                break;
            case AND:
                regs[rd] = regs[rs] & regs[rt];
                break;
            case JC:
                pc = pc + immd;
                break;
        }
    }
*/
}

