#include "HivekAssembler.h"

namespace HivekAssembler {
    void BinaryGenerator::set_table(Table* table) {
        this->table = table;
    }

    void BinaryGenerator::open(char* filename) {
        file.open(filename);
    }

    void BinaryGenerator::close() {
        file.close();
    }

    void BinaryGenerator::generate_binary() {
        file << "   .text\n";
        generate_instructions();
        file << "   .data\n";
        generate_data();
    }

    uint8_t BinaryGenerator::get_byte(uint32_t v, int pos) {
        uint8_t r;

        switch (pos) {
            case 0:
                r = v & 0xFF; break;
            case 1:
                r = (v & 0xFF00) >> 8; break;
            case 2:
                r = (v & 0xFF0000) >> 16; break;
            case 3:
                r = (v & 0xFF000000) >> 24; break;
            default:
                r = ~0; break;
        }

        return r;
    }

    std::string byte2str(uint8_t v) {
        std::string str;

        for (int i = 7; i >= 0; --i) {
            str += v & (1 << i) ? '1' : '0';
        }

        return str;
    }

    void BinaryGenerator::generate_data() {
        int i;
        int j;
        uint32_t n;
        Data dt;

        for (i = 0; i < table->data_size(); ++i) {
            dt = table->get_data_at(i);

            if (dt.type == DATA_INT32) {
                std::stringstream stream;

                stream << dt.value;
                stream >> n;

                file << byte2str(get_byte(n, 3)) << std::endl;
                file << byte2str(get_byte(n, 2)) << std::endl;
                file << byte2str(get_byte(n, 1)) << std::endl;
                file << byte2str(get_byte(n, 0)) << std::endl;
            } else if (dt.type == DATA_ASCII) {
                //j = 2: skip space and ". -1 to skip last "
                for (j = 2; j < dt.value.size() - 1; ++j) {
                    file << byte2str(get_byte(dt.value[j], 0)) << std::endl;
                }

                file << byte2str(get_byte(0, 0)) << std::endl;
            }
        }
    }

    void BinaryGenerator::write32op(uint32_t inst) {
        file << byte2str(get_byte(inst, 3)) << std::endl;
        file << byte2str(get_byte(inst, 2)) << std::endl;
        file << byte2str(get_byte(inst, 1)) << std::endl;
        file << byte2str(get_byte(inst, 0)) << std::endl;
    }

    void BinaryGenerator::generate_instructions() {
        int i;
        int sz;
        uint32_t instruction1;
        uint32_t instruction2;
        MultiInstruction mop;

        table->convert_labels();
        table->update_multi_instruction_sizes();

        for (i = 0; i < table->get_multi_instructions_size(); ++i) {
            mop = table->get_multi_instruction_at(i);
            sz  = mop.next_size << 30;

            switch (mop.size) {
                case MULTI_OP1x16:
                    break;

                case MULTI_OP1x32: 
                    instruction1 = sz | op2bin(mop.inst1);
                    write32op(instruction1);
                    break;

                case MULTI_OP2x16:
                    break;

                case MULTI_OP2x32: 
                    instruction1 = sz | op2bin(mop.inst1);
                    instruction2 = op2bin(mop.inst2);
                    write32op(instruction1);
                    write32op(instruction2);
                    break;

                default:
                    break;
            }
        }
    }

    uint32_t BinaryGenerator::op2bin(Instruction& op) {
        uint32_t instruction = 0;

        uint32_t rd;
        uint32_t rs;
        uint32_t rt;
        uint32_t cond;
        uint32_t immd;
        uint32_t opcode = 0;

        cond = (op.predicate_value << 2) | op.predicate_register;

        switch (op.operation) {
            case ADD:
                opcode = 0x38000000 | (0 << 18); break;
            case SUB:
                opcode = 0x38000000 | (1 << 18); break;
            case ADC:
                opcode = 0x38000000 | (2 << 18); break;
            case SBC:
                opcode = 0x38000000 | (3 << 18); break;
            case SHADD:
                // op.shift_type
                opcode = 0x38000000 | (3 << 18); break;

            case AND:
                opcode = 0x38000000 | (4 << 18); break;
            case OR:
                opcode = 0x38000000 | (5 << 18); break;
            case NOR:
                opcode = 0x38000000 | (6 << 18); break;
            case XOR:
                opcode = 0x38000000 | (7 << 18); break;

            case SLLV:
                opcode = 0x38000000 | (8 << 18); break;
            case SRLV:
                opcode = 0x38000000 | (9 << 18); break;
            case SRAV:
                opcode = 0x38000000 | (10 << 18); break;

            case CMPEQ:
                opcode = 0x38000000 | (11 << 18); break;

            case CMPLT:
                opcode = 0x38000000 | (12 << 18); break;

            case CMPGT:
                opcode = 0x38000000 | (13 << 18); break;

            case CMPLTU:
                opcode = 0x38000000 | (14 << 18); break;

            case CMPGTU:
                opcode = 0x38000000 | (15 << 18); break;

            case ANDP:
                opcode = 0x38000000 | (16 << 18); break;
            case ORP:
                opcode = 0x38000000 | (17 << 18); break;
            case XORP:
                opcode = 0x38000000 | (18 << 18); break;
            case NORP:
                opcode = 0x38000000 | (19 << 18); break;

            case JR:
                opcode = 0x38000000 | (20 << 18); break;
            case JALR:
                opcode = 0x38000000 | (21 << 18); break;

            // immediate
            case ADDI:
                opcode = 0; break;
            case ADCI:
                opcode = 0x02000000; break;
            case ANDI:
                opcode = 0x04000000; break;
            case ORI:
                opcode = 0x06000000; break;
            case CMPEQI:
                opcode = 0x08000000; break;
            case CMPLTI:
                opcode = 0x0A000000; break;
            case CMPGTI:
                opcode = 0x0C000000; break;
            case CMPLTUI:
                opcode = 0x0E000000; break;
            case CMPGTUI:
                opcode = 0x10000000; break;
            case LW:
                opcode = 0x12000000; break;
            case LB:
                opcode = 0x14000000; break;
            case SW:
                opcode = 0x16000000; break;
            case SB:
                opcode = 0x18000000; break;

            // conditional jumps
            case JC:
                opcode = 0x32000000; break;
            case JCN:
                opcode = 0x30000000; break;
            case JALC:
                opcode = 0x36000000; break;
            case JALCN:
                opcode = 0x34000000; break;

            // unconditional jumps:
            case J:
                opcode = 0x20000000; break;
            case JAL:
                opcode = 0x28000000; break;

            default:
                opcode = 0;
                break;
        }

        switch (op.type) {
            case TYPE_I:
                rd = op.destination << 13;
                rs = op.operand1 << 3;
                rt = op.operand2 << 8;
                instruction |= opcode | rd | rt | rs | cond;
                break;

            case TYPE_Ib:
                rd = 31 << 13;
                rs = 0;
                rt = op.destination << 8;
                instruction |= opcode | rd | rt | rs | cond;
                break;

            case TYPE_II:
                rs   = op.operand1 << 3;
                rt   = op.destination << 8;
                immd = (op.operand2 << 13) & 0x01FFE000; 
                instruction |= opcode | immd | rt | rs | cond;
                break;

            case TYPE_III:
                immd = (op.destination << 3) & 0x01FFFFF8;
                instruction |= opcode | immd | cond;
                break;

            case TYPE_IV:
                immd = op.destination & 0x07FFFFFF;
                instruction |= opcode | immd;
                break;

            default:
                break;
        }

        return instruction;
    }
}

