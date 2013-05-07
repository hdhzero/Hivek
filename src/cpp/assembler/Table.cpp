#include "HivekAssembler.h"

namespace HivekAssembler {
    void Table::add_branch_label(const std::string& str) {
        branch_labels[str] = address;
    }

    void Table::add_multi_instruction() {
        MultiInstruction mop;

        if (instructions.size() == 2) {
            mop.inst2 = instructions.top();
            instructions.pop();

            mop.inst1 = instructions.top();
            instructions.pop();

            if (mop.inst1.size == 4) {
                mop.size = MULTI_OP2x32;
            } else {
                mop.size = MULTI_OP2x16;
            }
        } else if (instructions.size() == 1) {
            mop.inst1 = instructions.top();
            instructions.pop();

            if (mop.inst1.size == 4) {
                mop.size = MULTI_OP1x32;
            } else {
                mop.size = MULTI_OP1x16;
            }

        }

        multi_instructions.push_back(mop);
    }

    void Table::add_instruction (
        std::string& predicate, 
        std::string& operation,
        std::string& destination,
        std::string& operand1,
        std::string& operand2,
        std::string& shift_type,
        std::string& shamt
    ) 
    {
        Instruction op;

        get_predicate(predicate, op);
        get_operation(operation, op);
        get_destination(destination, op);
        get_operand1(operand1, op);
        get_operand2(operand2, op);

        op.stop_bit = false;
        op.size     = instruction_size[op.type];
        op.address  = address;
        address    += op.size;
       
        instructions.push(op); 
    }

    void Table::get_predicate(std::string& str, Instruction& op) {
        if (str.size() == 0) {
            op.predicate_register = 0;
            op.predicate_value = 1;
            return;
        }

        // remove ( and )
        str.erase(0, 1);
        str.erase(str.size() - 1);

        if (str[0] == '!') {
            op.predicate_value = 0;
            str.erase(0, 1);
        } else {
            op.predicate_value = 1;
        }

        op.predicate_register = str2predicate[str];
    }

    void Table::get_operation(std::string& str, Instruction& op) {
        op.operation = str2operation[str];
        op.type      = str2type[str];
    }

    void Table::get_destination(std::string& str, Instruction& op) {
        if (str[str.size() - 1] == ',') {
            str.erase(str.size() - 1);
        }

        if (str2register.count(str) > 0) {
            // here, dest is a register
            op.destination = str2register[str];
        } else {
            // here, dest is a label from branch and should be
            // calculated in a second pass
            op.label = str;
        }
    }

    // add16 r1, r2, r4
    // addi16 r1, r0, 7
    // lwfp16 r3, fp, 89
    void Table::get_operand1(std::string& str, Instruction& op) {
        // operand1 is always a register
        if (str.size() > 0) {
            str.erase(str.size() - 1);
            op.operand1 = str2register[str];
        }
    }

    void Table::get_operand2(std::string& str, Instruction& op) {
        // verify that we have a second operand
        if (str.size() == 0) {
            return;
        }

        if (str2register.count(str) > 0) {
            op.operand2 = str2register[str];
        } else {
            op.label = str;
        }
    }

    void Table::get_shift_type(std::string& str, Instruction& op) {
        if (str.size() == 0) {
            return;
        }

        op.shift_type = str2shift_type[str];
    }

    void Table::get_shamt(std::string& str, Instruction& op) {
        if (str.size() == 0) {
            return;
        }

        std::stringstream stream;

        stream << str;
        stream >> op.shamt;
    }

    void Table::add_data(std::string& n, std::string& t, std::string& v) {
        Data dt;

        dt.address = address;
        dt.name    = n;
        dt.type    = str2data_type[t];
        dt.value   = v;

        if (dt.type == DATA_ASCII) {
            address += dt.value.size() + 1; // + 1 for '\0'
        } else if (dt.type == DATA_INT32) {
            address += 4;
        }

        data.push_back(dt);
    }

    Data Table::get_data_at(int i) {
        return data[i];
    }

    MultiInstruction Table::get_multi_instruction_at(int i) {
        return multi_instructions[i];
    }

    int Table::get_multi_instructions_size() {
        return multi_instructions.size();
    }

    int Table::data_size() {
        return data.size();
    }

    void Table::convert_labels() {
        int i;

        for (i = 0; i < multi_instructions.size(); ++i) {
            switch (multi_instructions[i].size) {
                case MULTI_OP1x16:
                case MULTI_OP1x32:
                    convert_label(multi_instructions[i].inst1, 0);
                    break;

                case MULTI_OP2x16:
                    convert_label(multi_instructions[i].inst1, 2);
                    convert_label(multi_instructions[i].inst2, 0);
                    break;

                case MULTI_OP2x32: 
                    convert_label(multi_instructions[i].inst1, 4);
                    convert_label(multi_instructions[i].inst2, 0);
                    break;

                default:
                    break;
            }
        }
    }

    void Table::convert_label(Instruction& op, int i) {
        switch (op.type) {
            case TYPE_III:
            case TYPE_IV:
                convert_label_branch(op, i);
                break;

            case TYPE_II:
                convert_label_data(op);
                break;

            default:
                break;
        }
    }

    // current_address  = op.address + op.size + i
    // branch_target = label.address
    // difference = branch_target - current_address
    // immd = difference / 2
    void Table::convert_label_branch(Instruction& op, int i) {
        int current_address;
        int branch_target;
        int difference;

        current_address = op.address + op.size + i;
        branch_target   = branch_labels[op.label];
        difference      = branch_target - current_address;

        op.destination  = difference / 2;
    }

    void Table::convert_label_data(Instruction& op) {
        std::stringstream stream;
        int i;


        for (i = 0; i < data.size(); ++i) {
            if (data[i].name.compare(op.label) == 0) {
                op.operand2 = data[i].address - data[0].address;
                return;
            }
        }

        // if we reach here, it is a number
        stream << op.label;
        stream >> op.operand2;        
    }

    void Table::update_multi_instruction_sizes() {
        int i;

        for (i = 0; i < multi_instructions.size() - 1; ++i) {
            multi_instructions[i].next_size = multi_instructions[i + 1].size;
        }

        multi_instructions[i].next_size = MULTI_OP1x16;
    }

    Table::Table() {
        address = 0;

        str2data_type["ascii"] = DATA_ASCII;
        str2data_type["dw"]    = DATA_INT32;

        str2shift_type["SLL"]  = SLL;
        str2shift_type["SRL"]  = SRL;
        str2shift_type["SRA"]  = SRA;

        str2predicate["p0"] = 0;
        str2predicate["p1"] = 1;
        str2predicate["p2"] = 2;
        str2predicate["p3"] = 3;
        

        #define REG(a) str2register[a]
        #define reg_assoc(a, b, c, d) { REG(a) = d; REG(b) = d; REG(c) = d; }
        reg_assoc("$r0", "$R0", "$zero", 0);
        reg_assoc("$r1", "$R1", "$at", 1);

        reg_assoc("$r2", "$R2", "$v0", 2);
        reg_assoc("$r3", "$R3", "$v1", 3);

        reg_assoc("$r4", "$R4", "$a0", 4);
        reg_assoc("$r5", "$R5", "$a1", 5);
        reg_assoc("$r6", "$R6", "$a2", 6);
        reg_assoc("$r7", "$R7", "$a3", 7);

        reg_assoc("$r8", "$R8", "$t0", 8);
        reg_assoc("$r9", "$R9", "$t1", 9);
        reg_assoc("$r10", "$R10", "$t2", 10);
        reg_assoc("$r11", "$R11", "$t3", 11);
        reg_assoc("$r12", "$R12", "$t4", 12);
        reg_assoc("$r13", "$R13", "$t5", 13);
        reg_assoc("$r14", "$R14", "$t6", 14);
        reg_assoc("$r15", "$R15", "$t7", 15);

        reg_assoc("$r16", "$R16", "$s0", 16);
        reg_assoc("$r17", "$R17", "$s1", 17);
        reg_assoc("$r18", "$R18", "$s2", 18);
        reg_assoc("$r19", "$R19", "$s3", 19);
        reg_assoc("$r20", "$R20", "$s4", 20);
        reg_assoc("$r21", "$R21", "$s5", 21);
        reg_assoc("$r22", "$R22", "$s6", 22);
        reg_assoc("$r23", "$R23", "$s7", 23);

        reg_assoc("$r24", "$R24", "$t8", 24);
        reg_assoc("$r25", "$R25", "$t9", 25);

        reg_assoc("$r26", "$R26", "$k0", 26);
        reg_assoc("$r27", "$R27", "$k1", 27);

        reg_assoc("$r28", "$R28", "$gp", 28);
        reg_assoc("$r29", "$R29", "$sp", 29);

        reg_assoc("$r30", "$R30", "$fp", 30);
        reg_assoc("$r31", "$R31", "$ra", 31);

        str2register["$p0"] = 0;
        str2register["$p1"] = 1;
        str2register["$p2"] = 2;
        str2register["$p3"] = 3;

        instruction_size[TYPE_I]   = 4;
        instruction_size[TYPE_Ib]  = 4;
        instruction_size[TYPE_II]  = 4;
        instruction_size[TYPE_III] = 4;
        instruction_size[TYPE_IV]  = 4;
        instruction_size[TYPE_V]   = 4;

        #define assoc(a, b, c) { str2operation[a] = b; str2type[a] = c; }
        assoc("add", ADD, TYPE_I);
        assoc("sub", SUB, TYPE_I);
        assoc("adc", ADC, TYPE_I);
        assoc("sbc", SBC, TYPE_I);
        assoc("adds", ADDS, TYPE_I);
        assoc("adcs", ADCS, TYPE_I);
        assoc("subs", SUBS, TYPE_I);
        assoc("sbcs", SBCS, TYPE_I);

        assoc("and", AND, TYPE_I);
        assoc("or", OR, TYPE_I);
        assoc("nor", NOR, TYPE_I);
        assoc("xor", XOR, TYPE_I);

        assoc("sll", SLL, TYPE_I);
        assoc("srl", SRL, TYPE_I);
        assoc("sra", SRA, TYPE_I);

        assoc("lwr", LWR, TYPE_I);
        assoc("swr", SWR, TYPE_I);
        assoc("lbr", LBR, TYPE_I);
        assoc("swr", SWR, TYPE_I);

        assoc("cmpeq", CMPEQ, TYPE_I);
        assoc("cmplt", CMPLT, TYPE_I);
        assoc("cmpgt", CMPGT, TYPE_I);
        assoc("cmpltu", CMPLTU, TYPE_I);
        assoc("cmpgtu", CMPGTU, TYPE_I);

        assoc("andp", ANDP, TYPE_I);
        assoc("orp", ORP, TYPE_I);
        assoc("xorp", XORP, TYPE_I);
        assoc("norp", NORP, TYPE_I);

        // type Ib
        assoc("jr", JR, TYPE_Ib);
        assoc("jalr", JALR, TYPE_Ib);

        //type Ic

        // type ii
        assoc("addi", ADDI, TYPE_II);
        assoc("adci", ADCI, TYPE_II);
        assoc("addis", ADDIS, TYPE_II);
        assoc("adcis", ADCIS, TYPE_II);

        assoc("andi", ANDI, TYPE_II);
        assoc("ori", ORI, TYPE_II);

        assoc("cmpeqi", CMPEQI, TYPE_II);
        assoc("cmplti", CMPLTI, TYPE_II);
        assoc("cmpgti", CMPGTI, TYPE_II);
        assoc("cmpltui", CMPLTUI, TYPE_II);
        assoc("cmpgtui", CMPGTUI, TYPE_II);

        assoc("lw", LW, TYPE_II);
        assoc("sw", SW, TYPE_II);
        assoc("lb", LB, TYPE_II);
        assoc("sb", SB, TYPE_II);

        // type iii
        assoc("jc", JC, TYPE_III);
        assoc("jcn", JCN, TYPE_III);
        assoc("jalc", JALC, TYPE_III);
        assoc("jalcn", JALCN, TYPE_III);

        // type iv
        assoc("j", J, TYPE_IV);
        assoc("jal", JAL, TYPE_IV);
    }
}
