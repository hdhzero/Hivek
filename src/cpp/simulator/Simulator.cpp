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

    void Simulator::print_registers() {
        std::cout << "pc: " << pc << std::endl;

        for (int i = 0; i < 32; ++i) {
            std::cout << "regs[" << i << "]: " << i << std::endl;
        }
    }

    void Simulator::fetch_instructions() {
        instruction1  = instruction_memory[pc] << 24;
        instruction1 |= instruction_memory[pc + 1] << 16;
        instruction1 |= instruction_memory[pc + 2] << 8;
        instruction1 |= instruction_memory[pc + 3];

        instruction2  = instruction_memory[pc + 4] << 24;
        instruction2 |= instruction_memory[pc + 5] << 16;
        instruction2 |=instruction_memory[pc + 6] << 8;
        instruction2 |= instruction_memory[pc + 7];
    }

    void Simulator::update_status() {
        if (j_taken) {
            new_pc += pc + 8;
            j_taken = false;
        } else {
            switch ((instruction1 & 0xC0000000) >> 30) {
                case 0:
                    new_pc += 2; break;
                case 1:
                case 2:
                    new_pc += 4; break;
                case 3:
                    new_pc += 8; break;
                default:
                    break;
            }
        }

        sz = new_sz;
        new_sz = (instruction1 & 0xC0000000) >> 30;

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
        uint32_t immd22;
        uint32_t immd12;
/*        // if jump
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
        }*/

        return n;
    }

    void Simulator::execute_instructions() {
        execute(instruction1);
        execute(instruction2);
    }

    void Simulator::execute(uint32_t n) {
        int p_reg   = n & 0x03;
        int p_value = (n & 0x04) >> 2;
        int rs      = (n & 0x0F8) >> 3;
        int rt      = (n & 0x01F00) >> 8;
        int rd      = (n & 0x03E000) >> 13;
        int immd12  = (n & 0x01FFE000) >> 13;
        int immd22  = (n & 0x01FFFFFF) >> 3;
        int immd27  = (n & 0x07FFFFFF);

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

        /* immediates */
            case ADDI:
                regs[rs] = regs[rt] + sign_ext(immd12, 12);
                break;

            case ADCI:
                regs[rs] = regs[rt] + sign_ext(immd12, 12);
                break;

            case ANDI:
                regs[rs] = regs[rt] & sign_ext(immd12, 12);
                break;

            case ORI:
                regs[rs] = regs[rt] | sign_ext(immd12, 12);
                break;

            case CMPEQI:
                predicate_regs[rs] = cmpeq(regs[rt], sign_ext(immd12, 12));
                predicate_regs[rs] = predicate_regs[rs] || rs == 0;
                break;

            case CMPLTI:
                predicate_regs[rs] = cmplt(regs[rt], sign_ext(immd12, 12));
                predicate_regs[rs] = predicate_regs[rs] || rs == 0;
                break;

            case CMPGTI:
                predicate_regs[rs] = cmpgt(regs[rt], sign_ext(immd12, 12));
                predicate_regs[rs] = predicate_regs[rs] || rs == 0;
                break;

            case CMPLTUI:
                predicate_regs[rs] = cmpltu(regs[rt], sign_ext(immd12, 12));
                predicate_regs[rs] = predicate_regs[rs] || rs == 0;
                break;

            case CMPGTUI:
                predicate_regs[rs] = cmpgtu(regs[rt], sign_ext(immd12, 12));
                predicate_regs[rs] = predicate_regs[rs] || rs == 0;
                break;

            case LW:
                regs[rs] = read_dmem(regs[rt] + sign_ext(immd12, 12), 32);
                break;

             case LB:
                regs[rs] = read_dmem(regs[rt] + sign_ext(immd12, 12), 8);
                break;

            case SW:
                write_dmem(regs[rs], regs[rt] + sign_ext(immd12, 12), 32);
                break;

             case SB:
                write_dmem(regs[rs], regs[rt] + sign_ext(immd12, 12), 8);
                break;
           
            default:
                break;
        }
    }

    bool Simulator::cmpeq(uint32_t a, uint32_t b) {
        return a == b;
    }

    bool Simulator::cmplt(int32_t a, int32_t b) {
        return a < b;
    }

    bool Simulator::cmpgt(int32_t a, int32_t b) {
        return a > b;
    }

    bool Simulator::cmpltu(uint32_t a, uint32_t b) {
        return a < b;
    }

    bool Simulator::cmpgtu(uint32_t a, uint32_t b) {
        return a > b;
    }

    void Simulator::write_dmem(uint32_t v, uint32_t address, int bits) {

    }

    uint32_t Simulator::read_dmem(uint32_t address, int bits) {

    }

    void Simulator::run() {
        fetch_instructions();
        decode_instructions();
        execute_instructions();
        update_status();
    }

    Simulator::Simulator() {
        pc = 0;
        new_pc = 0;
        sz = 3;
        new_sz = 3;

        for (int i = 0; i < 32; ++i) {
            regs[i] = 0;
        }

        regs[1] = 2;
        regs[2] = 5;
    }
}

