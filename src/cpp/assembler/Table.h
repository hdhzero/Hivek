#ifndef HIVEK_TABLE_H
#define HIVEK_TABLE_H

namespace HivekAssembler {
    class Table {
        private:
            vector<Label> labels;
            vector<Data>  data;
            vector<MultiOperation> multiops;

        public:
            void add_label(Label& label);
            void add_data(Data& data);
            void add_multiop(MultiOperation& mop);

            OperationType get_operation_type(const std::string& str);
    };
}

#endif
