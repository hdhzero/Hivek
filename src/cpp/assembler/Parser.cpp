#include "HivekAssembler.h"

namespace HivekAssembler {
    void Parser::open(char* filename) {
        file.open(filename);
    }

    void Parser::close() {
        file.close();
    }

    void Parser::set_table(Table* table) {
        this->table = table;
    }

    bool Parser::empty_line() {
        int i;
        bool flag;

        if (str.size() == 0) {
            return true;
        }

        flag = true;

        for (i = 0; i < str.size(); ++i) {
            if (! (str[i] == ' ' || str[i] == '\t')) {
                flag = false;
            } 
            if (str[i] == '#') {
                return true;
            }
        }

        return flag;
    }

    void Parser::parse() {
        int i;

        while (file.good()) {
            // reset stringstream
            stream.str("");
            stream.clear();

            // read a line from file
            getline(file, str);

            // if empty line or a comment, skip
            if (empty_line()) {
                continue;
            }

            stream << str;
            stream >> str;

            i = str.size() - 1;

            if (str[i] == ':') {
                parse_branch_label();
            } else if (str[0] == '.') {
                parse_data();
            } else if (str[0] == ';') {
                /* add code to add multiop */
            } else {
                std::cout << "calling parse_instruction with: " << str << ' ' << empty_line() << std::endl;
                parse_instruction();
            }
        }
    }

    void Parser::parse_branch_label() {
        // erase : from label:
        str.erase(str.size() - 1);

        table->add_branch_label(str);
    }

    void Parser::parse_data() {
        std::string name;
        std::string type;
        std::string value;

        // erase . from .label
        str.erase(0, 1);
        name = str;

        // read type
        stream >> type;

        // read value
        getline(stream, value);
        table->add_data(name, type, value);
    }

    void Parser::parse_instruction() {
        bool read;
        std::string pr;     // predicate
        std::string op;     // operation
        std::string dst;    // destination
        std::string op1;    // operand1
        std::string op2;    // operand2
        std::string shamt;  // shift ammount
        std::string sht;    // shift type

        // verify if has a predicate and read operation
        if (str[0] == '(') {
            pr = str;
            stream >> op;
        } else {
            op = str;
        }


        // read destination
        // we also verify if there is more data to read
        // note: jr r1, so there are no more operands
        read = (stream >> dst);

        // yeah! goto!
        if (!read) {
            goto ADD_INST;
        }

        // read operand1 and operand2
        // if we reach here, then it must have two operands
        stream >> op1;
        read = (stream >> op2);

        if (!read) {
            goto ADD_INST;
        }

        // if we reach here, then it must be a shift type and shift ammount
        stream >> sht;
        stream >> shamt;

        ADD_INST:
            table->add_instruction(pr, op, dst, op1, op2, sht, shamt);
    }
}

