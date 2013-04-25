#include "HivekAssembler.h"

namespace HivekAssembler {
    void Table::add_label(Label& label) {
        labels.push_back(label);
    }

    void Table::add_data(Data& data) {
        data.push_back(data);
    }

    void Table::add_multiop(MultiOperation& mop) {
        multiops.push_back(mop);
    }

    OperationType Table::get_operation_type(const std::string& str) {

    }
}
