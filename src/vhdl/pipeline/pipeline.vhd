library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

-- This file implements the pipeline
entity pipeline is
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : in pipeline_in_t;
        dout  : out pipeline_out_t
    );
end pipeline;

architecture behavior of pipeline is
begin
    process (clock, reset, din)
    begin

        --------------
        -- forwards --
        --------------

        -- icache
        dout.icache_addr <= din.if_o.icache_addr;

        -- dcache
        dout.dcache_wren_0 <= din.exec_o.op0.control.mem_wren;
        dout.dcache_wren_1 <= din.exec_o.op1.control.mem_wren;

        dout.dcache_addr_0 <= din.exec_o.op0.mem_addr;
        dout.dcache_addr_1 <= din.exec_o.op1.mem_addr;

        dout.dcache_data_0 <= din.exec_o.op0.mem_data_wr;
        dout.dcache_data_1 <= din.exec_o.op1.mem_data_wr;

        dout.exec_i.op0.mem_data <= din.dcache_data_0;
        dout.exec_i.op1.mem_data <= din.dcache_data_1;
        
        dout.exec2_i.op0.mem_data <= din.exec_o.op0.mem_data_rd;
        dout.exec2_i.op1.mem_data <= din.exec_o.op1.mem_data_rd;

        --TODO
        dout.if_i.instruction <= din.icache_data;

        dout.if_i.op0.j_addr <= din.iexp_o.op0.j_addr;
        dout.if_i.op1.j_addr <= din.iexp_o.op1.j_addr;

        dout.if_i.op0.j_take <= din.iexp_o.op0.j_take;
        dout.if_i.op1.j_take <= din.iexp_o.op1.j_take;

        dout.if_i.op0.jr_take <= '0';
        dout.if_i.op1.jr_take <= '0';

        dout.if_i.op0.restore <= '0';
        dout.if_i.op1.restore <= '0';

        dout.if_i.pc_wren <= '1';
        --end TODO

        -- wb id
        dout.id_i.op0.reg_wren <= din.wb_o.op0.control.reg_wren;
        dout.id_i.op1.reg_wren <= din.wb_o.op1.control.reg_wren;

        dout.id_i.op0.reg_dst <= din.wb_o.op0.reg_dst;
        dout.id_i.op1.reg_dst <= din.wb_o.op1.reg_dst;

        dout.id_i.op0.data_dst <= din.wb_o.op0.data_dst;
        dout.id_i.op1.data_dst <= din.wb_o.op1.data_dst;

        -- id id2
        dout.id2_i.op0.data_a <= din.id_o.op0.data_a;
        dout.id2_i.op1.data_a <= din.id_o.op1.data_a;

        dout.id2_i.op0.data_b <= din.id_o.op0.data_b;
        dout.id2_i.op1.data_b <= din.id_o.op1.data_b;

        
        if reset = '1' then
            dout.iexp_i.instruction <= ZERO;
        elsif clock'event and clock = '1' then
            -- if exp
            dout.iexp_i.instruction <= din.if_o.instruction;
            dout.iexp_i.inst_size   <= din.if_o.inst_size;
        end if;

        if reset = '1' then
            dout.id_i.op0.operation <= NOP;
            dout.id_i.op1.operation <= NOP;
        elsif clock'event and clock = '1' then
            -- exp id
            dout.id_i.op0.operation <= din.iexp_o.op0.operation;
            dout.id_i.op1.operation <= din.iexp_o.op1.operation;
        end if;

        if reset = '1' then
            dout.id2_i.op0.control.reg_wren <= '0';
            dout.id2_i.op0.control.mem_wren <= '0';
            dout.id2_i.op0.control.pr_wren  <= '0';

            dout.id2_i.op1.control.reg_wren <= '0';
            dout.id2_i.op1.control.mem_wren <= '0';
            dout.id2_i.op1.control.pr_wren  <= '0';
        elsif clock'event and clock = '1' then
            -- id id2
            dout.id2_i.op0.pr_reg <= din.id_o.op0.pr_reg;
            dout.id2_i.op1.pr_reg <= din.id_o.op1.pr_reg;

            dout.id2_i.op0.pr_data <= din.id_o.op0.pr_data;
            dout.id2_i.op1.pr_data <= din.id_o.op1.pr_data;

            dout.id2_i.op0.reg_a <= din.id_o.op0.reg_a;
            dout.id2_i.op1.reg_a <= din.id_o.op1.reg_a;

            dout.id2_i.op0.reg_b <= din.id_o.op0.reg_b;
            dout.id2_i.op1.reg_b <= din.id_o.op1.reg_b;

            dout.id2_i.op0.reg_c <= din.id_o.op0.reg_c;
            dout.id2_i.op1.reg_c <= din.id_o.op1.reg_c;

            dout.id2_i.op0.immd32 <= din.id_o.op0.immd32;
            dout.id2_i.op1.immd32 <= din.id_o.op1.immd32;

            dout.id2_i.op0.control <= din.id_o.op0.control;
            dout.id2_i.op1.control <= din.id_o.op1.control;
        end if;

        if reset = '1' then
            dout.exec_i.op0.control.reg_wren <= '0';
            dout.exec_i.op0.control.mem_wren <= '0';
            dout.exec_i.op0.control.pr_wren  <= '0';

            dout.exec_i.op1.control.reg_wren <= '0';
            dout.exec_i.op1.control.mem_wren <= '0';
            dout.exec_i.op1.control.pr_wren  <= '0';
        elsif clock'event and clock = '1' then
            -- id2 exec
            dout.exec_i.op0.pr_reg <= din.id2_o.op0.pr_reg;
            dout.exec_i.op1.pr_reg <= din.id2_o.op1.pr_reg;

            dout.exec_i.op0.pr_data <= din.id2_o.op0.pr_data;
            dout.exec_i.op1.pr_data <= din.id2_o.op1.pr_data;

            dout.exec_i.op0.data_a  <= din.id2_o.op0.data_a;
            dout.exec_i.op1.data_a <= din.id2_o.op1.data_a;

            dout.exec_i.op0.data_b <= din.id2_o.op0.data_b;
            dout.exec_i.op1.data_b <= din.id2_o.op1.data_b;

            dout.exec_i.op0.immd32 <= din.id2_o.op0.immd32;
            dout.exec_i.op1.immd32 <= din.id2_o.op1.immd32;

            dout.exec_i.op0.sh_immd <= din.id2_o.op0.sh_immd;
            dout.exec_i.op1.sh_immd <= din.id2_o.op1.sh_immd;

            dout.exec_i.op0.reg_dst <= din.id2_o.op0.reg_dst;
            dout.exec_i.op1.reg_dst <= din.id2_o.op1.reg_dst;

            dout.exec_i.op0.reg_a <= din.id2_o.op0.reg_a;
            dout.exec_i.op1.reg_a <= din.id2_o.op1.reg_a;

            dout.exec_i.op0.reg_b <= din.id2_o.op0.reg_b;
            dout.exec_i.op1.reg_b <= din.id2_o.op1.reg_b;

            dout.exec_i.op0.mem_data <= din.dcache_data_0;
            dout.exec_i.op1.mem_data <= din.dcache_data_1;

            dout.exec_i.op0.control <= din.id2_o.op0.control;
            dout.exec_i.op1.control <= din.id2_o.op1.control;
        end if;

        if reset = '1' then
            dout.exec2_i.op0.control.reg_wren <= '0';
            dout.exec2_i.op1.control.reg_wren <= '0';
       elsif clock'event and clock = '1' then
            -- exec exec2
            dout.exec2_i.op0.alu_data <= din.exec_o.op0.alu_data;
            dout.exec2_i.op1.alu_data <= din.exec_o.op1.alu_data;

            dout.exec2_i.op0.sh_data <= din.exec_o.op0.sh_data;
            dout.exec2_i.op1.sh_data <= din.exec_o.op1.sh_data;
    

            dout.exec2_i.op0.reg_dst <= din.exec_o.op0.reg_dst;
            dout.exec2_i.op1.reg_dst <= din.exec_o.op1.reg_dst;

            dout.exec2_i.op0.control.reg_wren <= din.exec_o.op0.control.reg_wren;
            dout.exec2_i.op1.control.reg_wren <= din.exec_o.op1.control.reg_wren;

            dout.exec2_i.op0.control.alu_sh_sel <= din.exec_o.op0.control.alu_sh_sel;
            dout.exec2_i.op1.control.alu_sh_sel <= din.exec_o.op1.control.alu_sh_sel;

            dout.exec2_i.op0.control.alu_sh_mem_sel <= din.exec_o.op0.control.alu_sh_mem_sel;
            dout.exec2_i.op1.control.alu_sh_mem_sel <= din.exec_o.op1.control.alu_sh_mem_sel;

        end if;

        if reset = '1' then
            dout.wb_i.op0.control.reg_wren <= '0';
            dout.wb_i.op1.control.reg_wren <= '0';
        elsif clock'event and clock = '1' then
            -- exec2 wb
            dout.wb_i.op0.control.alu_sh_mem_sel <= din.exec2_o.op0.control.alu_sh_mem_sel;
            dout.wb_i.op1.control.alu_sh_mem_sel <= din.exec2_o.op1.control.alu_sh_mem_sel;

            dout.wb_i.op0.control.reg_wren <= din.exec2_o.op0.control.reg_wren;
            dout.wb_i.op1.control.reg_wren <= din.exec2_o.op1.control.reg_wren;

            dout.wb_i.op0.reg_dst <= din.exec2_o.op0.reg_dst;
            dout.wb_i.op1.reg_dst <= din.exec2_o.op1.reg_dst;

            dout.wb_i.op0.alu_sh_data <= din.exec2_o.op0.alu_sh_data;
            dout.wb_i.op1.alu_sh_data <= din.exec2_o.op1.alu_sh_data;

            dout.wb_i.op0.mem_data <= din.exec2_o.op0.mem_data;
            dout.wb_i.op1.mem_data <= din.exec2_o.op1.mem_data;
        end if;

    end process;
end behavior;
