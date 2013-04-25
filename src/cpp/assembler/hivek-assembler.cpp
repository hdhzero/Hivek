#include "HivekAssembler.h"
#include <iostream>
using namespace std;

int main(int argc, char** argv) {
    HivekAssembler::Assembler as;
    as.parse(argv[1]);
    as.generate_binary(argv[2]);
    std::cout << "Hello world\n";
    return 0;
}
