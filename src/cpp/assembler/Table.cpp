#include "HivekAssembler.h"

namespace HivekAssembler {
    void Table::add_branch_label(const std::string& str) {
        branch_labels[str] = address;
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
            op.operand1 = str2register[str];
        }
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

    int Table::data_size() {
        return data.size();
    }

    Table::Table() {
        address = 0;

        str2data_type["ascii"] = DATA_ASCII;
        str2data_type["dw"]    = DATA_INT32;

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
        assoc("jalc", JALC, TYPE_III);

        // type iv
        assoc("j", J, TYPE_IV);
        assoc("jal", JAL, TYPE_IV);
    }
}
