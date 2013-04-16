#include <iostream>
#include <vector>
#include <map>
#include <fstream>
#include <string>
#include <sstream>
using namespace std;

/*

L7:
         add r1 r2 r3 ;;

         cmpeq b1, r2, r3 ;;

    (p1) lw r5 r1 45
         j L7 ;;

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

class HivekAssembler {
    private:
        enum data_type_t { DATA_ASCII, DATA_32BITS };
        enum operation_type_t {
            ADD, SUB
        };

    private:
        int pc;
        ifstream file;

        map<string, int> labels;
        map<string, int> data_type;
        map<string, int> operation_type;
        vector<Data> data;
        Data dt;

    public:
        HivekAssembler() {
            pc = 0;

            data_type["ascii"] = DATA_ASCII;
            data_type["dw"]    = DATA_32BITS;
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
        }

        void parse_operation(Operation& op, string& str, stringstream ss) {
            switch (op.operation) {
                case ADD:
                case SUB:
                case AND:
                case OR:
                    ss >> str;

                    str.erase(str.size() - 1);
                    op.rd = 
            }
        }

        void check() {
            cout << pc << endl;
        }

        void parse() {
            int j;
            string tmp0;
            string tmp1;

            while (file.good()) {
                stringstream ss;
                getline(file, tmp0);

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
