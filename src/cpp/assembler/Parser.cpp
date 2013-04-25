#include "HivekAssembler.h"

namespace Hivek {
    Parser::Parser {
        pc = 0;

        data_type["ascii"] = DATA_ASCII;
        data_type["dw"]    = DATA_32BITS;

        #define assoc(a, b, c) { str2op[a] = b; operation_type[b] = c; }

        // type I
        assoc("add", ADD, TYPE_I);
        assoc("sub", SUB, TYPE_I);
        assoc("adc", ADC, TYPE_I);
        assoc("sbc", SBC, TYPE_I);
        assoc("adds", ADDS, TYPE_I);
        assoc("adcs", ADCS, TYPE_I);
        assoc("subs", SUBS, TYPE_I);
        assoc("sbcs", SBCS, TYPE_I);

        assoc("and", AND, TYPE_I);
        assoc("or", OR, TYPE_I);
        assoc("nor", NOR, TYPE_I);
        assoc("xor", XOR, TYPE_I);

        assoc("sll", SLL, TYPE_I);
        assoc("srl", SRL, TYPE_I);
        assoc("sra", SRA, TYPE_I);

        assoc("lwr", LWR, TYPE_I);
        assoc("swr", SWR, TYPE_I);
        assoc("lbr", LBR, TYPE_I);
        assoc("swr", SWR, TYPE_I);

        assoc("cmpeq", CMPEQ, TYPE_I);
        assoc("cmplt", CMPLT, TYPE_I);
        assoc("cmpgt", CMPGT, TYPE_I);
        assoc("cmpltu", CMPLTU, TYPE_I);
        assoc("cmpgtu", CMPGTU, TYPE_I);

        assoc("andp", ANDP, TYPE_I);
        assoc("orp", ORP, TYPE_I);
        assoc("xorp", XORP, TYPE_I);
        assoc("norp", NORP, TYPE_I);

        // type Ib
        assoc("jr", JR, TYPE_Ib);
        assoc("jalr", JALR, TYPE_Ib);

        //type Ic

        // type ii
        assoc("addi", ADDI, TYPE_II);
        assoc("adci", ADCI, TYPE_II);
        assoc("addis", ADDIS, TYPE_II);
        assoc("adcis", ADCIS, TYPE_II);

        assoc("andi", ANDI, TYPE_II);
        assoc("ori", ORI, TYPE_II);

        assoc("cmpeqi", CMPEQI, TYPE_II);
        assoc("cmplti", CMPLTI, TYPE_II);
        assoc("cmpgti", CMPGTI, TYPE_II);
        assoc("cmpltui", CMPLTUI, TYPE_II);
        assoc("cmpgtui", CMPGTUI, TYPE_II);

        assoc("lw", LW, TYPE_II);
        assoc("sw", SW, TYPE_II);
        assoc("lb", LB, TYPE_II);
        assoc("sb", SB, TYPE_II);

        // type iii
        assoc("jc", JC, TYPE_III);
        assoc("jalc", JALC, TYPE_III);

        // type iv
        assoc("j", J, TYPE_IV);
        assoc("jal", JAL, TYPE_IV);
    }
}
