#include <iostream>
#include <vector>
#include <stdint.h>
using namespace std;

#define ADD 0
#define SUB 1
#define ADC 2
#define SBC 3
#define AND 4
#define OR  5
#define NOR 6
#define XOR 7
#define LW  8
#define LH  9
#define LB  10
#define LHU 11
#define LBU 12
#define SW  13
#define SH  14
#define SB  15

class HivekEmulator {
    private:
        bool zero;
        bool negative;
        bool carry;
        bool overflow;
        int32_t pc;
        int32_t res;
        int32_t cin;
        int32_t op1;
        int32_t op2;
        uint16_t head1;
        uint16_t head2;
        uint16_t tail1;
        uint16_t tail2;
        vector<uint16_t> imem;
        vector<uint8_t> dmem;

        int op;
        int addr_dmem;

    private:
        void store_word(uint32_t value, uint32_t addr) {
            dmem[addr] = value >> 24;
            dmem[addr + 1] = (value << 8) >> 24;
            dmem[addr + 2] = (value << 16) >> 24;
            dmem[addr + 3] = (value << 24) >> 24;
        }

        void store_half(uint32_t value, uint32_t addr) {
            dmem[addr] = (value << 16) >> 24;
            dmem[addr + 1] = (value << 24) >> 24;
        }

        void store_byte(uint32_t value, uint32_t addr) {
            dmem[addr] = value;
        }

        uint32_t load_word(uint32_t addr) {
            uint32_t res = 0;

            res |= dmem[addr] << 24;
            res |= dmem[addr + 1] << 16;
            res |= dmem[addr + 2] << 8;
            res |= dmem[addr + 3];

            return res;
        }

        uint32_t load_half(uint32_t addr) {
            uint32_t res = 0;

            if (dmem[addr] & 0x80) {
                res = ~0;
                res &= dmem[addr] << 8;
                res &= dmem[addr + 1];
            } else {
                res = 0;
                res |= dmem[addr] << 8;
                res |= dmem[addr + 1];
            }

            return res;

        }

        uint32_t load_byte(uint32_t addr) {
            uint32_t res = 0;

            if (dmem[addr] & 0x80) {
                res = ~0;
                res &= dmem[addr];
            } else {
                res = 0;
                res |= dmem[addr];
            }

            return res;
        }

        uint32_t load_uhalf(uint32_t addr) {
            uint32_t res = 0;

            res = 0;
            res |= dmem[addr] << 8;
            res |= dmem[addr + 1];

            return res;

        }

        uint32_t load_ubyte(uint32_t addr) {
            uint32_t res = 0;

            res = 0;
            res |= dmem[addr];

            return res;
        }


        void fetch() {
            head1 = imem[pc];
            head2 = imem[pc + 1];
            tail1 = imem[pc + 2];
            tail2 = imem[pc + 3];   
        }

        void decode() {

        }

        void execute() {
            switch (op) {
                /* arith */
                case ADD:
                    res = op1 + op2; break;
                case SUB:
                    res = op1 - op2; break;
                case ADC:
                    res = op1 + op2 + cin; break;
                case SBC: /* check that later */
                    res = op1 - op2 + cin - 1; break;
                case AND:
                    res = op1 & op2; break;
                case OR:
                    res = op1 | op2; break;
                case NOR:
                    res = ~(op1 | op2); break;
                case XOR:
                    res = op1 ^ op2; break;

                /* memory */
                case LW:
                   dmem[addr_dmem] = 0;
            }
        }

        void update() {

        }

        void main_loop() {
            fetch();
            decode();
            execute();
            update();
        }

    public:
};

int main(int argc, char** argv) {
    HivekEmulator emulator;
    return 0;
}
