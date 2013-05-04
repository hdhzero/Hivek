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

    enum OPERATIONS {
        ADD = 0,
        ADC = 1,
        AND = 2,

        // immediates
        ADDI   = 0,
        ADCI   = 1,
        ANDI   = 2,
        ORI    = 3,
        CMPEQI = 4,
        CMPLTI = 5,
        CMPGTI = 6,
        CMPLTUI = 7,
        CMPGTUI = 8,
        LW = 9,
        LB = 10,
        SW = 11,
        SB = 12,
        JC
    };

    #define NOP 0
}

#include "Simulator.h"

#endif
