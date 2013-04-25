#ifndef HIVEK_ASSEMBLER_PARSER_H
#define HIVEK_ASSEMBLER_PARSER_H

#include "HivekAssembler.h"

namespace HivekAssembler {
    class Parser {
        private:
            int address;
            std::ifstream file;

            // used for read and extract txt from file
            std::stringstream stream;
            std::string str;

            // table
            Table* table;

        private:
            bool empty_line();
            void parse_branch_label();
            void parse_data();
            void parse_instruction();
            
        public:
            void open(char* filename);
            void close();

            void set_table(Table* table);

            void parse();
    };
}

#endif
