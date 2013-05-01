#ifndef HIVEK_SIMULATOR_H
#define HIVEK_SIMULATOR_H

#include <iostream>
#include <vector>
#include <fstream>
#include <sstream>
#include <string>
#include <stdint.h>

namespace HivekSimulator {
    enum BIT_STATUS {
        CARRY0 = 0,
        CARRY1 = 1,
        P0     = 2,
        P1     = 3,
        P2     = 4,
        P3     = 5
    };

    #define NOP 0
}

#include "Simulator.h"

#endif
