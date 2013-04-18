#include <iostream>
#include <vector>
#include <map>
#include <fstream>
#include <string>
#include <sstream>
using namespace std;

/*

L7:
         add r1 r2 r3 
;;
         cmpeq b1, r2, r3 
;;
    (p1) lw r5 r1 45
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
    int predicate_register;
    int predicate_value;
    int rd;
    int rs;
    int rt;
    int immd;
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
        enum data_type_t { DATA_ASCII, DATA_32BITS };
        enum operation_type_t {
            ADD, SUB, AND, OR, LW, SW, ADC, SBC
        };

    private:
        int pc;
        ifstream file;

        map<string, int> labels;
        map<string, int> data_type;
        map<string, int> operation_type;
        vector<Data> data;
        vector<Operation> operations;
        Data dt;

    public:
        HivekAssembler() {
            pc = 0;

            data_type["ascii"] = DATA_ASCII;
            data_type["dw"]    = DATA_32BITS;

            operation_type["add"] = ADD;
            operation_type["sub"] = SUB;
            operation_type["and"] = AND;
            operation_type["or"]  = OR;
            operation_type["lw"]  = LW;
            operation_type["sw"]  = SW;
            operation_type["adc"] = ADC;
            operation_type["sbc"] = SBC;
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

            op.operation = operation_type[str];
            parse_operation(op, str, ss);
            operations.push_back(op);
        }

        void parse_operation(Operation& op, string& str, stringstream& ss) {
            switch (op.operation) {
                case ADD:
                case SUB:
                case AND:
                case OR:
                case ADC:
                case SBC:
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
                    break;

                case LW:
                case SW:
                    op.address = pc;
                    pc += 4;
                    op.size = 4;
                default:
                    break;

            }
        }

        void check() {
            cout << pc << endl;
            for (int i = 0; i < operations.size(); ++i) {
                printop(operations[i]);
            }
        }

        void parse() {
            int j;
            bool f;
            string tmp0;
            string tmp1;

            while (file.good()) {
                stringstream ss;
                getline(file, tmp0);

                if (tmp0.size() > 0) {
                    f = false;

                    for (int i = 0; i < tmp0.size(); ++i) {
                        if (! (tmp0[i] == ' ' || tmp0[i] == '\t')) {
                            f = true;
                        }
                    }

                    if (!f) continue;
                } else {
                    continue;
                }

                ss << tmp0;
                ss >> tmp1;

                j = tmp1.size() - 1;

                if (tmp1[j] == ':') {
                    add_label(tmp1);
                } else if (tmp1[0] == '.') {
                    add_data(tmp1, ss);
                } else {
                    add_instruction(tmp1, ss);
                }
            }
        }
};

int main(int argc, char** argv) {
    HivekAssembler as;

    as.open(argv[1]);
    as.parse();
    as.check();
    as.close();

    return 0;
}
