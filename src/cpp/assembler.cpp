#include <iostream>
#include <vector>
#include <stack>
#include <map>
#include <fstream>
#include <string>
#include <sstream>
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
    cout << "address: " << op.address
        << "size: " << op.size
        << "operation: " << op.operation
        << "predicate_register: " << op.predicate_register
        << "predicate_value: " << op.predicate_value
        << "rd: " << op.rd
        << "rs: " << op.rs
        << "rt: " << op.rt << endl;
}

class HivekAssembler {
    private:
        enum multiop_size_t {
            MULTI_OP1x16, MULTI_OP1x32, MULTI_OP2x32, MULTI_OP2x16 
        };

        enum data_type_t { 
            DATA_ASCII, DATA_32BITS 
        };

        enum operation_func_t { 
            // TYPE_I
            ADD, SUB, AND, OR, LWR, SWR, ADC, SBC 
        };

        enum operation_type_t { 
            TYPE_I, TYPE_II, TYPE_III, TYPE_IV, TYPE_V 
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
            assoc("add", ADD, TYPE_I);
            assoc("sub", SUB, TYPE_I);
            assoc("and", AND, TYPE_I);
            assoc("or", OR, TYPE_I);
            assoc("lwr", LWR, TYPE_I);
/*            operation_type["add"] = ADD;
            operation_type["sub"] = SUB;
            operation_type["and"] = AND;
            operation_type["or"]  = OR;
            operation_type["lw"]  = LW;
            operation_type["sw"]  = SW;
            operation_type["adc"] = ADC;
            operation_type["sbc"] = SBC;*/
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

        void parse_operation(Operation& op, string& str, stringstream& ss) {
            switch (op.type) {
                case TYPE_I:
                    parse_type_i(op, str, ss);
                    break;

                case TYPE_II:
                    parse_type_ii(op, str, ss);
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
            } else {
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

};

int main(int argc, char** argv) {
    HivekAssembler as;

    as.open(argv[1]);
    as.parse();
    as.close();

    return 0;
}
