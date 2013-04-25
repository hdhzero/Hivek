#include "HivekAssembler.h"

namespace HivekAssembler {
    Assembler::Assembler() {
        parser.set_table(&table);
        bin_gen.set_table(&table);
    }

    void Assembler::parse(char* filename) {
        parser.open(filename);
        parser.parse();
        parser.close();
    }

    void Assembler::generate_binary(char* filename) {
        bin_gen.open(filename);
        bin_gen.generate_binary();
        bin_gen.close();
    }
}
