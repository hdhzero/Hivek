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
        generate_instructions();
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
        MultiInstruction mop;

        table->convert_labels();
        table->update_multi_instruction_sizes();

        for (i = 0; i < table->get_multi_instructions_size(); ++i) {
            mop = table->get_multi_instruction_at(i);
            sz  = mop.size << 30;

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

/*
    void multiop2bin(MultipleOperation& mop, MultipleOperation& next) {
        uint32_t instruction1;
        uint32_t instruction2;
        uint16_t p[4];
        uint32_t size;

        if (next.size == MULTI_OP1x16) {
            size = 0;
        } else if (next.size == MULTI_OP1x32) {
            size = 0x40000000;
        } else if (next.size == MULTI_OP2x16) {
            size = 0x80000000;
        } else if (next.size == MULTI_OP2x32) {
            size = 0xC0000000;
        }

        if (mop.size == MULTI_OP1x32) {
            instruction1 = op2bin(mop.op1);
            instruction1 |= size;

            printop(mop.op1);
            cout << instruction1 << endl;
        }
    }
*/
    uint32_t BinaryGenerator::op2bin(Instruction& op) {
        uint32_t instruction = 0;

        uint32_t rd32 = op.destination << 13;
        uint32_t rs32 = op.operand1 << 3;
        uint32_t rt32 = op.operand2 << 8;
        uint32_t cond32 = (op.predicate_value << 2) | op.predicate_register;
        uint32_t immd12 = (op.operand2 << 20) >> 20;
        uint32_t opcode = 0;

        switch (op.operation) {
            case ADD:
                opcode = 0x30000000; break;
            case SUB:
                opcode = 0x30040000; break;
            case ADC:
                opcode = 0x30080000; break;
            case SBC:
                opcode = 0x300C0000; break;
            case ADDS:
                opcode = 0x30100000; break;
            case ADCS:
                opcode = 0x30140000; break;
            case SUBS:
                opcode = 0x30180000; break;
            case SBCS:
                opcode = 0x301C0000; break;
            default:
                opcode = 0;
                break;
        }

        switch (op.type) {
            case TYPE_I:
                instruction |= opcode | rd32 | rt32 | rs32 | cond32;
                break;

            default:
                break;
        }

        return instruction;
    }
}
