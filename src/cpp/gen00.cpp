#include <iostream>
#include <vector>
#include <cstdio>
using namespace std;

int main() {
    int i = 0;
    int j = 0;
    int k = 0;

    vector<int> v;
    vector<int> g;

    v.push_back(3);
    v.push_back(0);
    v.push_back(0);
    v.push_back(2);
    v.push_back(1);
    v.push_back(0);

    for (i = 0; i < v.size() - 1; ++i) {
        j = (v[i+1] << 14);

        if (v[i] == 0) {
            g.push_back(j | (0xFFF & k++));
        } else if (v[i] == 1) {
            g.push_back(j | (0xFFF & k));
            g.push_back(0xFFFF & k++);
        } else if (v[i] == 2) {
            g.push_back(j | (0xFFF & k++));
            g.push_back(0xFFFF & k++);
        } else if (v[i] = 3) {
            g.push_back(j | (0xFFF & k));
            g.push_back(0xFFFF & k++);
            g.push_back(0xFFFF & k);
            g.push_back(0xFFFF & k++);
        }
    }

    printf("    signal mem0 : ram := (\n");
    j = 0;

    for (i = 0; i < g.size() - 1; i += 4) {
        printf("        %i => x\"%04X\",\n", j++, g[i]);
    }

    if (i < g.size()) {
        printf("        %i => x\"%04X\",\n", j, g[i]);
    }

    printf("        others => x\"0000\");\n");



    printf("    signal mem1 : ram := (\n");
    j = 0;

    for (i = 1; i < g.size() - 1; i += 4) {
        printf("        %i => x\"%04X\",\n", j++, g[i]);
    }

    if (i < g.size()) {
        printf("        %i => x\"%04X\",\n", j, g[i]);
    }

    printf("        others => x\"0000\");\n");


    printf("    signal mem2 : ram := (\n");
    j = 0;

    for (i = 2; i < g.size() - 1; i += 4) {
        printf("        %i => x\"%04X\",\n", j++, g[i]);
    }

    if (i < g.size()) {
        printf("        %i => x\"%04X\",\n", j, g[i]);
    }

    printf("        others => x\"0000\");\n");

    printf("    signal mem3 : ram := (\n");
    j = 0;

    for (i = 3; i < g.size() - 1; i += 4) {
        printf("        %i => x\"%04X\",\n", j++, g[i]);
    }

    if (i < g.size()) {
        printf("        %i => x\"%04X\",\n", j, g[i]);
    }

    printf("        others => x\"0000\");\n");

    return 0;
}
