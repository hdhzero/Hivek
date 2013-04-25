#include "HivekAssembler.h"

namespace HivekAssembler {
    void BinaryGenerator::set_table(Table* table) {
        this->table = table;
    }

    void BinaryGenerator::open(char* filename) {
        file.open(filename);
    }

    void BinaryGenerator::close() {
        file.close();
    }

    void BinaryGenerator::generate_binary() {
        generate_data();
    }

    uint8_t BinaryGenerator::get_byte(uint32_t v, int pos) {
        uint8_t r;

        switch (pos) {
            case 0:
                r = v & 0xFF; break;
            case 1:
                r = (v & 0xFF00) >> 8; break;
            case 2:
                r = (v & 0xFF0000) >> 16; break;
            case 3:
                r = (v & 0xFF000000) >> 24; break;
            default:
                r = ~0; break;
        }

        return r;
    }

    std::string byte2str(uint8_t v) {
        std::string str;

        for (int i = 7; i >= 0; --i) {
            str += v & (1 << i) ? '1' : '0';
        }

        return str;
    }

    void BinaryGenerator::generate_data() {
        int i;
        int j;
        uint32_t n;
        Data dt;

        for (i = 0; i < table->data_size(); ++i) {
            dt = table->get_data_at(i);

            if (dt.type == DATA_INT32) {
                std::stringstream stream;

                stream << dt.value;
                stream >> n;

                file << byte2str(get_byte(n, 3)) << std::endl;
                file << byte2str(get_byte(n, 2)) << std::endl;
                file << byte2str(get_byte(n, 1)) << std::endl;
                file << byte2str(get_byte(n, 0)) << std::endl;
            } else if (dt.type == DATA_ASCII) {
                //j = 2: skip space and ". -1 to skip last "
                for (j = 2; j < dt.value.size() - 1; ++j) {
                    file << byte2str(get_byte(dt.value[j], 0)) << std::endl;
                }

                file << byte2str(get_byte(0, 0)) << std::endl;
            }
        }
    }
}
