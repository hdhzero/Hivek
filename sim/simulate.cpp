#include <iostream>
#include <fstream>
#include <vector>
using namespace std;

void barrel_shifter_tb() {
    vector<string> files;
    string bench = "barrel_shifter_tb";

    files.push_back(src_dir + "/vhdl/hivek_pkg.vhd");
    files.push_back(src_dir + "/vhdl/auxiliary/barrel_shifter.vhd");
    files.push_back(bench_dir + "/auxiliary/barrel_shifter.vhd");

    
}

int main(int argc, char** argv) {
    string project_dir = "/home/hdhzero/projetos/Hivek";

    string src_dir   = project_dir + "/src";
    string bench_dir = project_dir + "/bench";
    string sim_dir   = project_dir + "/sim";
    string work_dir  = project_dir + "/work";

    string simulator = "modelsim";

    string mklib;
    string map;
    string com;
    string sim;
    string com_flags;

    if (simulator.compare("modelsim") == 0) {
        mklib = "vlib";
        map   = "vmap WORK";
        com   = "vcom -work" + work_dir + "-93 -explicit"
        sim   = "vsim -c";
    } else if (simulator.compare("ghdl") == 0) {
        mklib = "mkdir";
    }

    return 0;
}
