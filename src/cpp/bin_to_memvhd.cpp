#include <iostream>
#include <string>
#include <vector>
#include <fstream>
using namespace std;

void print_signals(ofstream& file, vector<string>& mem) {
    int j = 0;

    file << "signal mem0_ram : mem_bram := (\n";

    for (int i = 0; i < mem.size(); i += 8) {
        file << "    " << j++ << " => \"" << mem[i] << mem[i + 1] << "\",\n";
    }

    file << "    others => \"0000000000000000\");\n\n";

    j = 0;
    file << "signal mem1_ram : mem_bram := (\n";

    for (int i = 2; i < mem.size(); i += 8) {
        file << "    " << j++ << " => \"" << mem[i] << mem[i + 1] << "\",\n";
    }
    file << "    others => \"0000000000000000\");\n\n";

    j = 0;

    file << "signal mem2_ram : mem_bram := (\n";

    for (int i = 4; i < mem.size(); i += 8) {
        file << "    " << j++ << " => \"" << mem[i] << mem[i + 1] << "\",\n";
    }
    file << "    others => \"0000000000000000\");\n\n";

    j = 0;

    file << "signal mem3_ram : mem_bram := (\n";

    for (int i = 6; i < mem.size(); i += 8) {
        file << "    " << j++ << " => \"" << mem[i] << mem[i + 1] << "\",\n";
    }
    file << "    others => \"0000000000000000\");\n\n";


}

void print_processes(ofstream& file) {
    int j;
    int k;

    for (int i = 0; i < 4; ++i) {
        j = (4 - i) * 16 - 1;
        k = j - 15;

        file << "    process (clock)\n";
        file << "    begin\n";
        file << "        if clock'event and clock = '1' then\n";
        file << "            out" << i << " <= mem" << i << "_ram(to_integer(unsigned(addr" << i << "(ADDR_WIDTH - 1 downto 0))));\n";
        file << "        end if;\n";
        file << "    end process;\n\n";
    }

}
void generate(ofstream& file, vector<string>& mem) {
    file << "library ieee;\n";
    file << "use ieee.std_logic_1164.all;\n";
    file << "use ieee.numeric_std.all;\n";

    file << "entity icache_memory is\n";
    file << "    generic (\n";
    file << "        VENDOR     : string := \"GENERIC\";\n";
    file << "        ADDR_WIDTH : integer := 8\n";
    file << "    );\n";
    file << "    port (\n";
    file << "        clock   : in std_logic;\n";
    file << "        wren    : in std_logic;\n";
    file << "        address : in std_logic_vector(31 downto 0);\n";
    file << "        data_i  : in std_logic_vector(63 downto 0);\n";
    file << "        data_o  : out std_logic_vector(63 downto 0)\n";
    file << "    );\n";
    file << "end icache_memory;\n";

    file << "architecture icache_memory_arch of icache_memory is\n";
    file << "    signal addr0 : std_logic_vector(31 downto 0);\n";
    file << "    signal addr1 : std_logic_vector(31 downto 0);\n";
    file << "    signal addr2 : std_logic_vector(31 downto 0);\n";
    file << "    signal addr3 : std_logic_vector(31 downto 0);\n";
    file << "\n";
    file << "    signal out0 : std_logic_vector(15 downto 0);\n";
    file << "    signal out1 : std_logic_vector(15 downto 0);\n";
    file << "    signal out2 : std_logic_vector(15 downto 0);\n";
    file << "    signal out3 : std_logic_vector(15 downto 0);\n";
    file << "\n";
    file << "    signal wren0 : std_logic;\n";
    file << "    signal wren1 : std_logic;\n";
    file << "    signal wren2 : std_logic;\n";
    file << "    signal wren3 : std_logic;\n";
    file << "\n";
    file << "    signal address_plus_one : std_logic_vector(31 downto 0);\n";
    file << "    signal addr_sel         : std_logic_vector(1 downto 0);\n";
    file << "    signal addr_sel_reg     : std_logic_vector(1 downto 0);\n";
    file << "    type mem_bram is array (2 ** ADDR_WIDTH - 1 downto 0) of std_logic_vector(15 downto 0);\n";
    file << "\n";

    print_signals(file, mem);

    file << "begin\n";
    file << "    address_plus_one <= std_logic_vector(unsigned(address) + x\"00000008\");\n";
    file << "    addr_sel <= address(2 downto 1);\n";

    file << "    wren0 <= wren;\n";
    file << "    wren1 <= wren;\n";
    file << "    wren2 <= wren;\n";
    file << "    wren3 <= wren;\n";
    file << "\n";
    file << "    process (addr_sel, address, address_plus_one)\n";
    file << "    begin\n";
    file << "        case addr_sel is\n";
    file << "            when \"00\" =>\n";
    file << "                addr0 <= \"000\" & address(31 downto 3);\n";
    file << "                addr1 <= \"000\" & address(31 downto 3);\n";
    file << "                addr2 <= \"000\" & address(31 downto 3);\n";
    file << "                addr3 <= \"000\" & address(31 downto 3);\n";
    file << "            when \"01\" =>\n";
    file << "                addr0 <= \"000\" & address_plus_one(31 downto 3);\n";
    file << "                addr1 <= \"000\" & address(31 downto 3);\n";
    file << "                addr2 <= \"000\" & address(31 downto 3);\n";
    file << "                addr3 <= \"000\" & address(31 downto 3);\n";
    file << "            when \"10\" =>\n";
    file << "                addr0 <= \"000\" & address_plus_one(31 downto 3);\n";
    file << "                addr1 <= \"000\" & address_plus_one(31 downto 3);\n";
    file << "                addr2 <= \"000\" & address(31 downto 3);\n";
    file << "                addr3 <= \"000\" & address(31 downto 3);\n";
    file << "            when \"11\" =>\n";
    file << "                addr0 <= \"000\" & address_plus_one(31 downto 3);\n";
    file << "                addr1 <= \"000\" & address_plus_one(31 downto 3);\n";
    file << "                addr2 <= \"000\" & address_plus_one(31 downto 3);\n";
    file << "                addr3 <= \"000\" & address(31 downto 3);\n";
    file << "            when others =>\n";
    file << "                addr0 <= address;\n";
    file << "                addr1 <= address;\n";
    file << "                addr2 <= address;\n";
    file << "                addr3 <= address;\n";
    file << "\n";
    file << "        end case;\n";
    file << "    end process;\n";

    file << "    process (clock)\n";
    file << "    begin\n";
    file << "        if clock'event and clock = '1' then\n";
    file << "            addr_sel_reg <= addr_sel;\n";
    file << "        end if;\n";
    file << "    end process;\n";
    file << "\n";
    file << "    process (addr_sel_reg, out0, out1, out2, out3)\n";
    file << "    begin\n";
    file << "        case addr_sel_reg is\n";
    file << "            when \"00\" =>\n";
    file << "                data_o <= out0 & out1 & out2 & out3;\n";
    file << "            when \"01\" =>\n";
    file << "                data_o <= out1 & out2 & out3 & out0;\n";
    file << "            when \"10\" =>\n";
    file << "                data_o <= out2 & out3 & out0 & out1;\n";
    file << "            when \"11\" =>\n";
    file << "                data_o <= out3 & out0 & out1 & out2;\n";
    file << "            when others =>\n";
    file << "                data_o <= out0 & out1 & out2 & out3;\n";
    file << "\n";
    file << "        end case;\n";
    file << "    end process;\n";

    print_processes(file);

    file << "end icache_memory_arch;\n";
}




int main(int argc, char** argv) {
    ifstream file;
    ofstream gen;
    string data;
    vector<string> mem;

    file.open(argv[1]);
    gen.open("icache_memory.vhd");

    while (file >> data) {
        if (data.compare(".text") == 0) {
            continue;
        }
        else if (data.compare(".data") == 0) {
            break;
        } else {
            mem.push_back(data);
        }
    }

    generate(gen, mem);

    file.close();
    gen.close();

    return 0;
}
