library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pack.all;

entity execution_stage_tb is
end execution_stage_tb;

architecture behavior of execution_stage_tb is
    signal clock  : std_logic;
    signal reset  : std_logic;
    signal sh_ex  : SH_EX;
    signal ex_mem : EX_MEM;
begin
    process
    begin
        clock <= '1';
        wait for 5 ns;
        clock <= '0';
        wait for 5 ns;
    end process;

    process
    begin
        reset <= '0';
        sh_ex.wren_back0 <= '0';
        sh_ex.wren_back1 <= '0';
        sh_ex.mem_load_0 <= '0';
        sh_ex.mem_load_1 <= '0';
        sh_ex.wren_addr0 <= "0000";
        sh_ex.wren_addr1 <= "0000";
        sh_ex.update_flags0 <= '0';
        sh_ex.update_flags1 <= '0';
        sh_ex.alu_op_0   <= ALU_ADD_OP;
        sh_ex.alu_op_1   <= ALU_ADD_OP;
        sh_ex.cond0      <= COND_AL;
        sh_ex.cond1      <= COND_AL;
        sh_ex.op2_src0   <= '0';
        sh_ex.op2_src1   <= '0';
        sh_ex.reg_av0    <= x"00000000";
        sh_ex.reg_bv0    <= x"00000000";
        sh_ex.reg_av1    <= x"00000000";
        sh_ex.reg_bv1    <= x"00000000";
        sh_ex.immd32_0   <= x"00000000";
        sh_ex.immd32_1   <= x"00000000";
        wait until clock'event and clock = '1';

        reset <= '0';
        sh_ex.wren_back0 <= '0';
        sh_ex.wren_back1 <= '0';
        sh_ex.mem_load_0 <= '0';
        sh_ex.mem_load_1 <= '0';
        sh_ex.wren_addr0 <= "0000";
        sh_ex.wren_addr1 <= "0000";
        sh_ex.update_flags0 <= '0';
        sh_ex.update_flags1 <= '0';

        sh_ex.alu_op_0   <= ALU_ADD_OP;
        sh_ex.alu_op_1   <= ALU_ADD_OP;
        sh_ex.cond0      <= COND_AL;
        sh_ex.cond1      <= COND_AL;
        sh_ex.op2_src0   <= '0';
        sh_ex.op2_src1   <= '0';
        sh_ex.reg_av0    <= x"00000000";
        sh_ex.reg_bv0    <= x"00000000";
        sh_ex.reg_av1    <= x"00000000";
        sh_ex.reg_bv1    <= x"00000000";
        sh_ex.immd32_0   <= x"00000000";
        sh_ex.immd32_1   <= x"00000000";
        wait until clock'event and clock = '1';

        reset <= '1';
        sh_ex.wren_back0 <= '0';
        sh_ex.wren_back1 <= '0';
        sh_ex.mem_load_0 <= '0';
        sh_ex.mem_load_1 <= '0';
        sh_ex.wren_addr0 <= "0000";
        sh_ex.wren_addr1 <= "0000";
        sh_ex.update_flags0 <= '0';
        sh_ex.update_flags1 <= '0';

        sh_ex.alu_op_0   <= ALU_ADD_OP;
        sh_ex.alu_op_1   <= ALU_ADD_OP;
        sh_ex.cond0      <= COND_AL;
        sh_ex.cond1      <= COND_AL;
        sh_ex.op2_src0   <= '0';
        sh_ex.op2_src1   <= '0';
        sh_ex.reg_av0    <= x"00000000";
        sh_ex.reg_bv0    <= x"00000000";
        sh_ex.reg_av1    <= x"00000000";
        sh_ex.reg_bv1    <= x"00000000";
        sh_ex.immd32_0   <= x"00000000";
        sh_ex.immd32_1   <= x"00000000";
        wait until clock'event and clock = '1';

        reset <= '0';
        sh_ex.wren_back0 <= '0';
        sh_ex.wren_back1 <= '0';
        sh_ex.mem_load_0 <= '0';
        sh_ex.mem_load_1 <= '0';
        sh_ex.wren_addr0 <= "0000";
        sh_ex.wren_addr1 <= "0000";
        sh_ex.update_flags0 <= '1';
        sh_ex.update_flags1 <= '0';

        sh_ex.alu_op_0   <= ALU_ADD_OP;
        sh_ex.alu_op_1   <= ALU_ADD_OP;
        sh_ex.cond0      <= COND_AL;
        sh_ex.cond1      <= COND_AL;
        sh_ex.op2_src0   <= '0';
        sh_ex.op2_src1   <= '0';
        sh_ex.reg_av0    <= x"00000005";
        sh_ex.reg_bv0    <= x"FFFFFFFF";
        sh_ex.reg_av1    <= x"00000000";
        sh_ex.reg_bv1    <= x"00000000";
        sh_ex.immd32_0   <= x"00000000";
        sh_ex.immd32_1   <= x"00000000";
        wait until clock'event and clock = '1';

        reset <= '0';
        sh_ex.wren_back0 <= '0';
        sh_ex.wren_back1 <= '0';
        sh_ex.mem_load_0 <= '0';
        sh_ex.mem_load_1 <= '0';
        sh_ex.wren_addr0 <= "0000";
        sh_ex.wren_addr1 <= "0000";
        sh_ex.update_flags0 <= '0';
        sh_ex.update_flags1 <= '0';

        sh_ex.alu_op_0   <= ALU_ADD_OP;
        sh_ex.alu_op_1   <= ALU_ADD_OP;
        sh_ex.cond0      <= COND_AL;
        sh_ex.cond1      <= COND_AL;
        sh_ex.op2_src0   <= '0';
        sh_ex.op2_src1   <= '0';
        sh_ex.reg_av0    <= x"00000000";
        sh_ex.reg_bv0    <= x"00000000";
        sh_ex.reg_av1    <= x"00000000";
        sh_ex.reg_bv1    <= x"00000000";
        sh_ex.immd32_0   <= x"00000000";
        sh_ex.immd32_1   <= x"00000000";
        wait until clock'event and clock = '1';

        reset <= '0';
        sh_ex.wren_back0 <= '0';
        sh_ex.wren_back1 <= '0';
        sh_ex.mem_load_0 <= '0';
        sh_ex.mem_load_1 <= '0';
        sh_ex.wren_addr0 <= "0000";
        sh_ex.wren_addr1 <= "0000";
        sh_ex.update_flags0 <= '0';
        sh_ex.update_flags1 <= '0';

        sh_ex.alu_op_0   <= ALU_ADD_OP;
        sh_ex.alu_op_1   <= ALU_ADD_OP;
        sh_ex.cond0      <= COND_AL;
        sh_ex.cond1      <= COND_AL;
        sh_ex.op2_src0   <= '0';
        sh_ex.op2_src1   <= '0';
        sh_ex.reg_av0    <= x"00000000";
        sh_ex.reg_bv0    <= x"00000000";
        sh_ex.reg_av1    <= x"00000000";
        sh_ex.reg_bv1    <= x"00000000";
        sh_ex.immd32_0   <= x"00000000";
        sh_ex.immd32_1   <= x"00000000";
        wait until clock'event and clock = '1';

        reset <= '0';
        sh_ex.wren_back0 <= '0';
        sh_ex.wren_back1 <= '0';
        sh_ex.mem_load_0 <= '0';
        sh_ex.mem_load_1 <= '0';
        sh_ex.wren_addr0 <= "0000";
        sh_ex.wren_addr1 <= "0000";
        sh_ex.update_flags0 <= '0';
        sh_ex.update_flags1 <= '0';

        sh_ex.alu_op_0   <= ALU_ADD_OP;
        sh_ex.alu_op_1   <= ALU_ADD_OP;
        sh_ex.cond0      <= COND_AL;
        sh_ex.cond1      <= COND_AL;
        sh_ex.op2_src0   <= '0';
        sh_ex.op2_src1   <= '0';
        sh_ex.reg_av0    <= x"00000000";
        sh_ex.reg_bv0    <= x"00000000";
        sh_ex.reg_av1    <= x"00000000";
        sh_ex.reg_bv1    <= x"00000000";
        sh_ex.immd32_0   <= x"00000000";
        sh_ex.immd32_1   <= x"00000000";
        wait until clock'event and clock = '1';

        wait;
    end process;

    execution_stage_u : execution_stage
    port map (
        clock     => clock,
        reset     => reset,
        from_pipe => sh_ex,
        to_pipe   => ex_mem
    );
end behavior;
