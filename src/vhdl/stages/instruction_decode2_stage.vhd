library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity instruction_decode2_stage is
    port (
        din  : in instruction_decode2_stage_in_t;
        dout : out instruction_decode2_stage_out_t
    );
end instruction_decode2_stage;

architecture behavior of instruction_decode2_stage is
begin
    process (din)
    begin
        -- predicate
        dout.op0.pr_reg  <= din.op0.pr_reg;
        dout.op0.pr_data <= din.op0.pr_data;

        dout.op1.pr_reg  <= din.op1.pr_reg;
        dout.op1.pr_data <= din.op1.pr_data;

        -- reg_addr
        dout.op0.reg_a <= din.op0.reg_a;
        dout.op0.reg_b <= din.op0.reg_b;

        dout.op1.reg_a <= din.op1.reg_a;
        dout.op1.reg_b <= din.op1.reg_b;

        if din.op0.control.reg_dst_sel = '0' then
            dout.op0.reg_dst <= din.op0.reg_c;
        else
            dout.op0.reg_dst <= din.op0.reg_b;
        end if;

        if din.op1.control.reg_dst_sel = '0' then
            dout.op1.reg_dst <= din.op1.reg_c;
        else
            dout.op1.reg_dst <= din.op1.reg_b;
        end if;

        -- data
        dout.op0.data_a <= din.op0.data_a;
        dout.op0.data_b <= din.op0.data_b;

        dout.op1.data_a <= din.op1.data_a;
        dout.op1.data_b <= din.op1.data_b;

        -- immd
        if din.op0.control.immd_pc_sel = '0' then
            dout.op0.immd32 <= din.op0.immd32;
        else
            dout.op0.immd32 <= din.next_pc;
        end if;

        if din.op1.control.immd_pc_sel = '0' then
            dout.op1.immd32 <= din.op1.immd32;
        else
            dout.op1.immd32 <= din.next_pc;
        end if;

        -- sh_immd
        dout.op0.sh_immd <= din.op0.sh_immd;
        dout.op1.sh_immd <= din.op1.sh_immd;


        -- jump
        dout.op0.restore_addr <= din.op0.restore_addr;
        dout.op0.restore_sz   <= din.op0.restore_sz;
        dout.op0.j_take       <= din.op0.j_take;

        dout.op1.restore_addr <= din.op1.restore_addr;
        dout.op1.restore_sz   <= din.op1.restore_sz;
        dout.op1.j_take       <= din.op1.j_take;

        -------------
        -- control --
        -------------

        -- alu_op
        dout.op0.control.alu_op <= din.op0.control.alu_op;
        dout.op1.control.alu_op <= din.op1.control.alu_op;

        -- shift_type
        dout.op0.control.sh_type <= din.op0.control.sh_type;
        dout.op1.control.sh_type <= din.op1.control.sh_type;

        -- bshift_sel
        dout.op0.control.bshift_sel <= din.op0.control.bshift_sel;
        dout.op1.control.bshift_sel <= din.op1.control.bshift_sel;

        -- wrens
        dout.op0.control.reg_wren <= din.op0.control.reg_wren;
        dout.op0.control.mem_wren <= din.op0.control.mem_wren;
        dout.op0.control.pr_wren  <= din.op0.control.pr_wren;
        dout.op0.control.j_take   <= din.op0.control.j_take;
        dout.op0.control.jr_take  <= din.op0.control.jr_take;

        dout.op1.control.reg_wren <= din.op1.control.reg_wren;
        dout.op1.control.mem_wren <= din.op1.control.mem_wren;
        dout.op1.control.pr_wren  <= din.op1.control.pr_wren;
        dout.op1.control.j_take   <= din.op1.control.j_take;
        dout.op1.control.jr_take  <= din.op1.control.jr_take;

        -- alu_sh_sel
        dout.op0.control.alu_sh_sel <= din.op0.control.alu_sh_sel;
        dout.op1.control.alu_sh_sel <= din.op1.control.alu_sh_sel;

        -- reg_immd_sel
        dout.op0.control.reg_immd_sel <= din.op0.control.reg_immd_sel;
        dout.op1.control.reg_immd_sel <= din.op1.control.reg_immd_sel;


         -- alu_sh_mem_sel
        dout.op0.control.alu_sh_mem_sel <= din.op0.control.alu_sh_mem_sel;
        dout.op1.control.alu_sh_mem_sel <= din.op1.control.alu_sh_mem_sel;
       
        -- sh_amt_src_sel
        dout.op0.control.sh_amt_src_sel <= din.op0.control.sh_amt_src_sel;
        dout.op1.control.sh_amt_src_sel <= din.op1.control.sh_amt_src_sel;

    end process;
end behavior;

