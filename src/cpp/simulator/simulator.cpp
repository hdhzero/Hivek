#include <iostream>
#include <vector>
#include <stdint.h>
#include <iostream>
#include "HivekSimulator.h"
using namespace std;

int main(int argc, char** argv) {
    HivekSimulator::Simulator sim;
    sim.open(argv[1]);
    sim.reset();
    sim.run();
    sim.print_registers();

    return 0;
}
