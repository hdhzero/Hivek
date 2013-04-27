#ifndef HIVEK_ASSEMBLER_TABLE_H
#define HIVEK_ASSEMBLER_TABLE_H

namespace HivekAssembler {
    class Table {
        private:
            std::map<std::string, int> str2data_type;
            std::map<std::string, int> str2shift_type;
            std::map<std::string, int> str2operation;
            std::map<std::string, int> str2predicate;
            std::map<std::string, int> str2type;
            std::map<std::string, int> str2register;
            
            std::map<int, int> instruction_size;

        private:
            int address;
            std::map<std::string, int> branch_labels;
            std::vector<Data> data;
            std::vector<MultiInstruction> multi_instructions;
            std::stack<Instruction> instructions;

        private:
            void get_predicate(std::string& str, Instruction& op);
            void get_operation(std::string& str, Instruction& op);
            void get_destination(std::string& str, Instruction& op);
            void get_operand1(std::string& str, Instruction& op);
            void get_operand2(std::string& str, Instruction& op);
            void get_shift_type(std::string& str, Instruction& op);
            void get_shamt(std::string& str, Instruction& op);

            void convert_label(Instruction& op);
            void convert_label_branch(Instruction& op);
            void convert_label_data(Instruction& op);

        public:
            Table();

        public:
            void add_branch_label(const std::string& str);
            void add_data(std::string& n, std::string& t, std::string& v);
            void add_multi_instruction();
            void convert_labels();
            void update_multi_instruction_sizes();

            void add_instruction (
                std::string& predicate, 
                std::string& operation,
                std::string& destination,
                std::string& operand1,
                std::string& operand2,
                std::string& shift_type,
                std::string& shamt
            );

            Data get_data_at(int i);
//            Instruction get_instruction_at(int i);
            int data_size();
            int instructions_size();
    };
}

#endif
