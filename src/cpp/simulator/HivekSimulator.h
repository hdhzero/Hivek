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
        ADDI   = 1000,
        ADCI   = 1001,
        ANDI   = 1002,
        ORI    = 1003,
        CMPEQI = 1004,
        CMPLTI = 1005,
        CMPGTI = 1006,
        CMPLTUI = 1007,
        CMPGTUI = 1008,
        LW = 1009,
        LB = 1010,
        SW = 1011,
        SB = 1012,

        // conditional jumps
        JCN   = 2000,
        JC    = 2001,
        JALC  = 2003,
        JALCN = 2002,

        // unconditional jumps
        J   = 3000,
        JAL = 3001
    };

    #define NOP 0
}

#include "Simulator.h"

#endif
