library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity execution_stage is
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : in execution_stage_in_t;
        dout  : out execution_stage_out_t
    );
end execution_stage;

architecture behavior of execution_stage is
    signal alu_sh_i0 : alu_shifter_in_t;
    signal alu_sh_i1 : alu_shifter_in_t;

    signal alu_sh_o0 : alu_shifter_out_t;
    signal alu_sh_o1 : alu_shifter_out_t;

    signal pb_i : predicate_bank_in_t;
    signal pb_o : predicate_bank_out_t;
begin
    process (din, pb_o, alu_sh_o0, alu_sh_o1)
    begin
        alu_sh_i0.alu_op <= din.op0.control.alu_op;
        alu_sh_i1.alu_op <= din.op1.control.alu_op;

        alu_sh_i0.sh_type <= din.op0.control.sh_type;
        alu_sh_i1.sh_type <= din.op1.control.sh_type;

        -- shift ammount select
        if din.op0.control.sh_amt_src_sel = '0' then
            alu_sh_i0.shift_amt <= din.op0.sh_immd;
        else
            alu_sh_i0.shift_amt <= din.op0.data_b(4 downto 0);
        end if;

        if din.op1.control.sh_amt_src_sel = '0' then
            alu_sh_i1.shift_amt <= din.op1.sh_immd;
        else
            alu_sh_i1.shift_amt <= din.op1.data_b(4 downto 0);
        end if;

        -- operand a
        alu_sh_i0.operand_a <= din.op0.data_a;
        alu_sh_i1.operand_a <= din.op1.data_a;

        alu_sh_i0.pr_data_a <= pb_o.op0.data_a;
        alu_sh_i0.pr_data_b <= pb_o.op0.data_b;

        alu_sh_i1.pr_data_a <= pb_o.op0.data_a;
        alu_sh_i1.pr_data_b <= pb_o.op1.data_b;


        -- TODO
        alu_sh_i0.carry_in <= '0';
        alu_sh_i1.carry_in <= '0';

        -- reg immd select
        if din.op0.control.reg_immd_sel = '0' then
            alu_sh_i0.operand_b <= din.op0.data_b;
        else
            alu_sh_i0.operand_b <= din.op0.immd32;
        end if;

        if din.op1.control.reg_immd_sel = '0' then
            alu_sh_i1.operand_b <= din.op1.data_b;
        else
            alu_sh_i1.operand_b <= din.op1.immd32;
        end if;

        -- wrens 0
        if pb_o.op0.data_pr = din.op0.pr_data then
            dout.op0.control.reg_wren <= din.op0.control.reg_wren;
            dout.op0.control.mem_wren <= din.op0.control.mem_wren;
            pb_i.op0.wren <= din.op0.control.pr_wren;
        else
            dout.op0.control.reg_wren <= '0';
            dout.op0.control.mem_wren <= '0';
            pb_i.op0.wren <= '0';
        end if;

        -- wrens 1
        if pb_o.op1.data_pr = din.op1.pr_data then
            dout.op1.control.reg_wren <= din.op1.control.reg_wren;
            dout.op1.control.mem_wren <= din.op1.control.mem_wren;
            pb_i.op1.wren <= din.op1.control.pr_wren;
        else
            dout.op1.control.reg_wren <= '0';
            dout.op1.control.mem_wren <= '0';
            pb_i.op1.wren <= '0';
        end if;

        -- selectors
        dout.op0.control.alu_sh_sel <= din.op0.control.alu_sh_sel;
        dout.op1.control.alu_sh_sel <= din.op1.control.alu_sh_sel;

        dout.op0.control.alu_sh_mem_sel <= din.op0.control.alu_sh_mem_sel;
        dout.op1.control.alu_sh_mem_sel <= din.op1.control.alu_sh_mem_sel;

        -- data
        dout.op0.alu_data <= alu_sh_o0.alu_result;
        dout.op1.alu_data <= alu_sh_o1.alu_result;

        dout.op0.sh_data <= alu_sh_o0.shift_result;
        dout.op1.sh_data <= alu_sh_o1.shift_result;

        dout.op0.reg_dst <= din.op0.reg_dst;
        dout.op1.reg_dst <= din.op1.reg_dst;

        pb_i.op0.reg_a  <= din.op0.reg_a(1 downto 0);
        pb_i.op0.reg_b  <= din.op0.reg_a(1 downto 0);
        pb_i.op0.reg_c  <= din.op0.reg_dst(1 downto 0);
        pb_i.op0.reg_pr <= din.op0.pr_reg;
        pb_i.op0.data   <= alu_sh_o0.cmp_flag;

        pb_i.op1.reg_a  <= din.op1.reg_a(1 downto 0);
        pb_i.op1.reg_b  <= din.op1.reg_a(1 downto 0);
        pb_i.op1.reg_c  <= din.op1.reg_dst(1 downto 0);
        pb_i.op1.reg_pr <= din.op1.pr_reg;
        pb_i.op1.data   <= alu_sh_o1.cmp_flag;
    end process;

    alu_shifter_u0 : alu_shifter
    port map (
        din  => alu_sh_i0,
        dout => alu_sh_o0
    );

    alu_shifter_u1 : alu_shifter
    port map (
        din  => alu_sh_i1,
        dout => alu_sh_o1
    );

    predicate_bank_u : predicate_bank
    port map (
        clock => clock,
        reset => reset,
        din   => pb_i,
        dout  => pb_o
    );
end behavior;
