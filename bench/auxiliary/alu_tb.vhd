library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity alu_tb is
end alu_tb;

architecture alu_tb_arch of alu_tb is
    signal alu_op : alu_op_t;
    signal cin    : std_logic;
    signal op_a   : std_logic_vector(31 downto 0);
    signal op_b   : std_logic_vector(31 downto 0);
    signal res    : std_logic_vector(31 downto 0);
    signal z_flag : std_logic;
    signal c_flag : std_logic;
    signal n_flag : std_logic;
    signal o_flag : std_logic;
begin
    alu_u : alu
    port map (
        alu_op => alu_op,
        cin    => cin,
        op_a   => op_a,
        op_b   => op_b,
        res    => res,
        z_flag => z_flag,
        c_flag => c_flag,
        n_flag => n_flag,
        o_flag => o_flag
    );

    process
    begin
        alu_op <= ALU_ADD_OP;
        cin    <= '0';
        op_a   <= x"00000005";
        op_b   <= x"00000007";
        wait for 10 ns;

        alu_op <= ALU_SUB_OP;
        cin    <= '0';
        op_a   <= x"00000005";
        op_b   <= x"00000007";
        wait for 10 ns;

        alu_op <= ALU_ADC_OP;
        cin    <= '0';
        op_a   <= x"00000005";
        op_b   <= x"00000007";
        wait for 10 ns;

        alu_op <= ALU_SBC_OP;
        cin    <= '0';
        op_a   <= x"00000005";
        op_b   <= x"00000007";
        wait for 10 ns;

        alu_op <= ALU_AND_OP;
        cin    <= '0';
        op_a   <= x"00000005";
        op_b   <= x"00000007";
        wait for 10 ns;

        alu_op <= ALU_OR_OP;
        cin    <= '0';
        op_a   <= x"00000005";
        op_b   <= x"00000007";
        wait for 10 ns;

        alu_op <= ALU_NOR_OP;
        cin    <= '0';
        op_a   <= x"00000005";
        op_b   <= x"00000007";
        wait for 10 ns;

        alu_op <= ALU_XOR_OP;
        cin    <= '0';
        op_a   <= x"00000005";
        op_b   <= x"00000007";
        wait for 10 ns;

        -----------------------------
        -----------------------------

        alu_op <= ALU_ADD_OP;
        cin    <= '0';
        op_a   <= x"FFFFFFFF";
        op_b   <= x"FFFFFFFF";
        wait for 10 ns;

        alu_op <= ALU_SUB_OP;
        cin    <= '0';
        op_a   <= x"FFFFFFFF";
        op_b   <= x"FFFFFFFF";
        wait for 10 ns;

        alu_op <= ALU_ADC_OP;
        cin    <= '0';
        op_a   <= x"FFFFFFFF";
        op_b   <= x"FFFFFFFF";
        wait for 10 ns;

        alu_op <= ALU_SBC_OP;
        cin    <= '0';
        op_a   <= x"FFFFFFFF";
        op_b   <= x"FFFFFFFF";
        wait for 10 ns;

        alu_op <= ALU_AND_OP;
        cin    <= '0';
        op_a   <= x"FFFFFFFF";
        op_b   <= x"FFFFFFFF";
        wait for 10 ns;

        alu_op <= ALU_OR_OP;
        cin    <= '0';
        op_a   <= x"FFFFFFFF";
        op_b   <= x"FFFFFFFF";
        wait for 10 ns;

        alu_op <= ALU_NOR_OP;
        cin    <= '0';
        op_a   <= x"FFFFFFFF";
        op_b   <= x"FFFFFFFF";
        wait for 10 ns;

        alu_op <= ALU_XOR_OP;
        cin    <= '0';
        op_a   <= x"FFFFFFFF";
        op_b   <= x"FFFFFFFF";
        wait for 10 ns;

        -----------------------------
        -----------------------------

        alu_op <= ALU_ADD_OP;
        cin    <= '0';
        op_a   <= x"0FFFFFFF";
        op_b   <= x"0FFFFFFF";
        wait for 10 ns;

        alu_op <= ALU_SUB_OP;
        cin    <= '0';
        op_a   <= x"0FFFFFFF";
        op_b   <= x"0FFFFFFF";
        wait for 10 ns;

        alu_op <= ALU_ADC_OP;
        cin    <= '0';
        op_a   <= x"0FFFFFFF";
        op_b   <= x"0FFFFFFF";
        wait for 10 ns;

        alu_op <= ALU_SBC_OP;
        cin    <= '0';
        op_a   <= x"0FFFFFFF";
        op_b   <= x"0FFFFFFF";
        wait for 10 ns;

        alu_op <= ALU_AND_OP;
        cin    <= '0';
        op_a   <= x"0FFFFFFF";
        op_b   <= x"0FFFFFFF";
        wait for 10 ns;

        alu_op <= ALU_OR_OP;
        cin    <= '0';
        op_a   <= x"0FFFFFFF";
        op_b   <= x"0FFFFFFF";
        wait for 10 ns;

        alu_op <= ALU_NOR_OP;
        cin    <= '0';
        op_a   <= x"0FFFFFFF";
        op_b   <= x"0FFFFFFF";
        wait for 10 ns;

        alu_op <= ALU_XOR_OP;
        cin    <= '0';
        op_a   <= x"0FFFFFFF";
        op_b   <= x"0FFFFFFF";
        wait for 10 ns;

        -----------------------------
        -----------------------------

        alu_op <= ALU_ADD_OP;
        cin    <= '0';
        op_a   <= x"7FFFFFFF";
        op_b   <= x"7FFFFFFF";
        wait for 10 ns;

        alu_op <= ALU_SUB_OP;
        cin    <= '0';
        op_a   <= x"7FFFFFFF";
        op_b   <= x"7FFFFFFF";
        wait for 10 ns;

        alu_op <= ALU_ADC_OP;
        cin    <= '0';
        op_a   <= x"7FFFFFFF";
        op_b   <= x"7FFFFFFF";
        wait for 10 ns;

        alu_op <= ALU_SBC_OP;
        cin    <= '0';
        op_a   <= x"7FFFFFFF";
        op_b   <= x"7FFFFFFF";
        wait for 10 ns;

        alu_op <= ALU_AND_OP;
        cin    <= '0';
        op_a   <= x"7FFFFFFF";
        op_b   <= x"7FFFFFFF";
        wait for 10 ns;

        alu_op <= ALU_OR_OP;
        cin    <= '0';
        op_a   <= x"7FFFFFFF";
        op_b   <= x"7FFFFFFF";
        wait for 10 ns;

        alu_op <= ALU_NOR_OP;
        cin    <= '0';
        op_a   <= x"7FFFFFFF";
        op_b   <= x"7FFFFFFF";
        wait for 10 ns;

        alu_op <= ALU_XOR_OP;
        cin    <= '0';
        op_a   <= x"7FFFFFFF";
        op_b   <= x"7FFFFFFF";
        wait for 10 ns;

        wait;
    end process;
    
end alu_tb_arch;
