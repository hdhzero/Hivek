#ifndef HIVEK_PARSER_H
#define HIVEK_PARSER_H

#include "HivekAssembler.h"

namespace Hivek {
    class Parser {
        private:
            int pc;
            map<string, int> labels;
            map<string, int> data_type;
            map<string, int> str2op;
            map<int, int>    operation_type;

            vector<Data> data;
            vector<Operation> op_stack;
            vector<MultiOperation> multiops;

        private:
            void parse_label();
            void parse_data();
            void parse_predicate();
            void parse_type_i();
            void parse_type_ii();
            void parse_type_iii();
            void parse_type_iv();

        public:
            void open(char* filename);
            void close();
            void parse();
    };
}

#endif
