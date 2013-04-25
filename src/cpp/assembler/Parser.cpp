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

        flag = false;

        for (i = 0; i < str.size(); ++i) {
            flag = ! (str[i] == ' ' || str[i] == '\t' || str[i] == '#');

            if (flag) return false;
        }

        return true;
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

    }
}

