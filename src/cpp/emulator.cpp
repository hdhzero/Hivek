#include <iostream>
#include <vector>
#include <stdint.h>
#include <cstdio>
using namespace std;


class HivekEmulator {
    private:
        int pc;
        int regs[32];
        vector<uint16_t> mem0;
        vector<uint16_t> mem1;
        vector<uint16_t> mem2;
        vector<uint16_t> mem3;

    private:
        void fetch_instruction() {
            mem0[pc]
        }

        void execute_instruction() {

        }
};

int main(int argc, char** argv) {
    return 0;
}
