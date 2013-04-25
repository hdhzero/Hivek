#include <iostream>
#include <vector>
#include <stack>
#include <map>
#include <fstream>
#include <string>
#include <sstream>
#include <stdint.h>
using namespace std;

/*

L7:
         add r1 r2 r3 0
;;
         cmpeq b1, r2, r3 4
;;
    (p1) lw r5 r1 45 8
         j L7 
;;

L8:


.msg ascii "Hello, world" 
.len dw 77
.ptr dw 88
*/

struct Data {
    int address;
    int size;
    int type;
    string value;
    string name;
};

struct Operation {
    int address;
    int size;
    int operation;
    int type;
    int predicate_register;
    int predicate_value;
    int rd;
    int rs;
    int rt;
    int immd; //string because immd can be a number or a label
    string label;
};

struct MultipleOperation {
    int size;
    Operation op1;
    Operation op2;
};

void printop(Operation& op) {
    cout << "addr: " << op.address
        << " sz: " << op.size
        << " op: " << op.operation
        << " p_reg: " << op.predicate_register
        << " p_value: " << op.predicate_value
        << " rd: " << op.rd
        << " rs: " << op.rs
        << " rt: " << op.rt 
        << " immd: " << op.immd 
        << " lbl: " << op.label << endl;
}

class HivekAssembler {
    public:
        enum multiop_size_t {
            MULTI_OP1x16, MULTI_OP1x32, MULTI_OP2x32, MULTI_OP2x16 
        };

        enum data_type_t { 
            DATA_ASCII, DATA_32BITS 
        };

        enum operation_func_t { 
            // TYPE_I
            ADD, SUB, ADC, SBC, ADDS, ADCS, SUBS, SBCS, 
            AND, OR, NOR, XOR,
            SLL, SRL, SRA,
            LWR, SWR, LBR, SBR,
            CMPEQ, CMPLT, CMPGT, CMPLTU, CMPGTU,
            ANDP, ORP, XORP, NORP,

            //TYPE_Ib
            JR, JALR,

            // TYPE_II
            ADDI, ADCI, ADDIS, ADCIS,
            ANDI, ORI,
            CMPEQI, CMPLTI, CMPGTI, CMPLTUI, CMPGTUI,
            LW, SW, LB, SB,

            // TYPE_III
            JC, JALC,

            // TYPE_IV
            J, JAL

        };

        enum operation_type_t { 
            TYPE_I, TYPE_II, TYPE_III, TYPE_IV, TYPE_V,
            TYPE_Ib 
        };

    private:
        int pc;
        ifstream file;

        map<string, int> labels;
        map<string, int> data_type;
        map<string, int> str2op;
        map<int, int>    operation_type;

        vector<Data>     data;
        stack<Operation> op_stack;
        vector<MultipleOperation> multiops;

        Data dt;

    public:
        HivekAssembler() {
            pc = 0;

            data_type["ascii"] = DATA_ASCII;
            data_type["dw"]    = DATA_32BITS;

            #define assoc(a, b, c) { str2op[a] = b; operation_type[b] = c; }

            // type I
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

        void open(char* filename) {
            file.open(filename);
        }

        void close() {
            file.close();
        }

        void add_label(string& str) {
            int j = str.size() - 1;

            str.erase(str.size() - 1);
            labels[str] = pc;
        }

        int label2int(string& str) {
            stringstream ss;
            int tmp = 0;

            if (labels.count(str) == 1) {
                return labels[str];
            } else {
                for (int i = 0; i < data.size(); ++i) {
                    if (data[i].name.compare(str) == 0) {
                        return data[i].address;
                    }
                }

                // if we are here, it is because it can only be a number
                ss << str;
                ss >> tmp;

                return tmp;
            }
        }

        void add_data(string& str, stringstream& ss) {
            int count = 0;

            str.erase(0, 1);
            dt.name = str;

            ss >> str;
            dt.type = data_type[str];
            dt.address = pc;

            getline(ss, str);
            dt.value = str;
            dt.value.erase(0, 1);

            if (dt.type == DATA_ASCII) {
                pc += dt.value.size() * 4;
            } else if (dt.type == DATA_32BITS) {
                pc += 4;
            }

            data.push_back(dt);
        }

        void add_instruction(string& str, stringstream& ss) {
            Operation op;

            add_predicate(str, ss, op);
            op.operation = str2op[str];
            op.type = operation_type[op.operation];
            parse_operation(op, str, ss);
            op_stack.push(op);
        }

        void add_predicate(string& str, stringstream& ss, Operation& op) {
            if (str[0] == '(') {
                if (str[1] == '!') {
                    op.predicate_value = 0;
                    op.predicate_register = str[3] - '0';
                } else {
                    op.predicate_value = 1;
                    op.predicate_register = str[2] - '0'; 
                }

                ss >> str;
            } else {
                op.predicate_value = 1;
                op.predicate_register = 0;
            }
        }

        void parse_type_i(Operation& op, string& str, stringstream& ss) {
            op.address = pc;
            pc += 4;
            op.size = 4;

            ss >> str; 
            str.erase(str.size() - 1);
            op.rd = (str[1] - '0') * 10 + (str[2] - '0');

            ss >> str;
            str.erase(str.size() - 1);
            op.rs = (str[1] - '0') * 10 + (str[2] - '0');

            ss >> str;
            op.rt = (str[1] - '0') * 10 + (str[2] - '0');
        }

        void parse_type_ib(Operation& op, string& str, stringstream& ss) {
            op.address = pc;
            pc += 4;
            op.size = 4;

            ss >> str;
            op.rd = (str[1] - '0') * 10 + (str[2] - '0');
        }

        void parse_type_ii(Operation& op, string& str, stringstream& ss) {
            op.address = pc;
            pc += 4;
            op.size = 4;

            ss >> str;                   
            str.erase(str.size() - 1);
            op.rd = (str[1] - '0') * 10 + (str[2] - '0');

            ss >> str;
            str.erase(str.size() - 1);
            op.rs = (str[1] - '0') * 10 + (str[2] - '0');

            ss >> op.label;
        }

        void parse_type_iii(Operation& op, string& str, stringstream& ss) {
            op.address = pc;
            pc += 4;
            op.size = 4;

            ss >> op.label;
        }

        void parse_type_iv(Operation& op, string& str, stringstream& ss) {
            op.address = pc;
            pc += 4;
            op.size = 4;

            ss >> op.label;
        }

        void parse_operation(Operation& op, string& str, stringstream& ss) {
            switch (op.type) {
                case TYPE_I: // add rd, rs, rt
                    parse_type_i(op, str, ss);
                    break;

                case TYPE_Ib:
                    parse_type_ib(op, str, ss);
                    break;

                case TYPE_II: // addi rs, rt, immd
                    parse_type_ii(op, str, ss);
                    break;

                case TYPE_III: // jc jalc immd
                    parse_type_iii(op, str, ss);
                    break;

                case TYPE_IV: // j jal immd 
                    parse_type_iv(op, str, ss);
                    break;

                default:
                    break;

            }
        }

        bool is_empty_string(string& str) {
            bool f;

            if (str.size() == 0) {
                return true;
            }

            f = false;

            for (int i = 0; i < str.size(); ++i) {
                if (! (str[i] == ' ' || str[i] == '\t' || str[i] == '#')) {
                    f = true;
                }
            }

            return !f;
        }

        void parse() {
            int j;
            string tmp0;
            string tmp1;

            while (file.good()) {
                stringstream ss;
                getline(file, tmp0);

                if (is_empty_string(tmp0)) {
                    continue;
                }

                ss << tmp0;
                ss >> tmp1;

                j = tmp1.size() - 1;

                if (tmp1[j] == ':') {
                    add_label(tmp1);
                } else if (tmp1[0] == '.') {
                    add_data(tmp1, ss);
                } else if (tmp1[0] == ';' && tmp1[1] == ';') {
                    add_multiple_instruction();
                } else {
                    add_instruction(tmp1, ss);
                }
            }
        }

        void add_multiple_instruction() {
            if (op_stack.size() == 2) {
                add_mop_2();
            } else if (op_stack.size() == 1) {
                add_mop_1();
            }
        }

        void add_mop_1() {
            MultipleOperation mop;

            mop.op1 = op_stack.top();
            op_stack.pop();

            if (mop.op1.size == 2) {
                mop.size = MULTI_OP1x16;
            } else {
                mop.size = MULTI_OP1x32;
            }

            multiops.push_back(mop);
        }

        void add_mop_2() {
            MultipleOperation mop;

            mop.op2 = op_stack.top();
            op_stack.pop();
            mop.op1 = op_stack.top();
            op_stack.pop();

            if (mop.op1.size == 4) {
                mop.size = MULTI_OP2x32;
            } else {
                mop.size = MULTI_OP2x16;
            }

            multiops.push_back(mop);
        }

        void convert_labels() {
            int i;

            for (i = 0; i < multiops.size(); ++i) {
                switch (multiops[i].size) {
                    case MULTI_OP1x16:
                    case MULTI_OP1x32:
                        convert_label(multiops[i].op1);
                        break;

                    case MULTI_OP2x16:
                    case MULTI_OP2x32: 
                        convert_label(multiops[i].op1);
                        convert_label(multiops[i].op2);
                        break;

                    default:
                        break;
                   
                }
            }
        }

        void convert_label(Operation& op) {
            switch (op.type) {
                case TYPE_III:
                case TYPE_IV:
                    convert_label_branch(op);
                    break;

                case TYPE_II:
                    convert_label_data(op);
                    break;

                default:
                    break;
            }
        }

        // current_address  = op.address + op.size
        // branch_target = label.address
        // difference = branch_target - current_address
        // immd = difference / 2
        void convert_label_branch(Operation& op) {
            int current_address;
            int branch_target;
            int difference;

            current_address = op.address + op.size;
            branch_target   = labels[op.label];
            difference      = branch_target - current_address;

            op.immd = difference / 2;

            cout << "ca: " << current_address
                << ", bt: " << branch_target 
                << ", diff: " << difference
                << endl;
        }

        void convert_label_data(Operation& op) {
            int i;

            for (i = 0; i < data.size(); ++i) {
                if (data[i].name.compare(op.label) == 0) {
                    op.immd = data[i].address;
                    break;
                }
            }
        }

        void check() {
            int i;

            for (i = 0; i < multiops.size(); ++i) {
                switch (multiops[i].size) {
                    case MULTI_OP1x16:
                    case MULTI_OP1x32:
                        printop(multiops[i].op1);
                        break;

                    case MULTI_OP2x16:
                    case MULTI_OP2x32:
                        printop(multiops[i].op1);
                        printop(multiops[i].op2);
                        break;

                    default:
                        break;
                   
                }
            }

        }

        void gen_code() {
            int i;

            for (i = 0; i < multiops.size() - 1; ++i) {
                multiop2bin(multiops[i], multiops[i + 1]);
            }
        }

/*struct Operation {
    int address;
    int size;
    int operation;
    int type;
    int predicate_register;
    int predicate_value;
    int rd;
    int rs;
    int rt;
    int immd; //string because immd can be a number or a label
    string label;
};*/

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

        uint32_t op2bin(Operation& op) {
            uint32_t instruction = 0;

            uint32_t rd32 = op.rd << 13;
            uint32_t rs32 = op.rs << 3;
            uint32_t rt32 = op.rt << 8;
            uint32_t cond32 = (op.predicate_value << 2) | op.predicate_register;
            uint32_t immd12 = (op.immd << 20) >> 20;
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

};

int main(int argc, char** argv) {
    HivekAssembler as;

    as.open(argv[1]);
    as.parse();
    as.convert_labels();
    as.check();
    as.gen_code();
    as.close();

    return 0;
}






