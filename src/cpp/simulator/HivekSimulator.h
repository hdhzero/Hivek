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
        SUB = 1,
        ADC = 2,
        SBC = 3,

        AND = 4,
        OR  = 5,
        NOR = 6,
        XOR = 7,

        SLLV = 8,
        SRLV = 9,
        SRAV = 10,
        
        CMPEQ = 11,
        CMPLT = 12,
        CMPLTU = 13,
        CMPGT = 14,
        CMPGTU = 15,

        ANDP = 16,
        ORP  = 17,
        XORP = 18,
        NORP = 19,

        JR = 20,
        JALR = 21,

        // immediates
        ADDI   = 1000,
        ADCI   = 1001,
        ANDI   = 1002,
        ORI    = 1003,
        CMPEQI = 1004,
        CMPLTI = 1005,
        CMPLTUI = 1006,
        CMPGTI = 1007,
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
