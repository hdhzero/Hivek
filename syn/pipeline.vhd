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
    type pipeline_state_t is (init, init2, running, jump_0, restore_0);

    signal current_state : pipeline_state_t;
    signal next_state    : pipeline_state_t;

begin
    process (clock, reset)
    begin
        if reset = '1' then
            current_state <= init;
        elsif clock'event and clock = '1' then
            current_state <= next_state;
        end if;
    end process;

    process (clock, reset, din, current_state)
        variable restore         : std_logic;
        variable jump            : std_logic;
        variable jr_jump         : std_logic;
        variable if_iexp_wren    : std_logic;
        variable iexp_id_wren    : std_logic;
        variable id_id2_wren     : std_logic;
        variable id2_exec_wren   : std_logic;
        variable exec_exec2_wren : std_logic;
        variable exec2_wb_wren   : std_logic;
        variable inst_sz_sel     : std_logic;
        variable restore_sz_sel  : std_logic;
        variable pc_wren         : std_logic;
    begin
        -- machine state
        restore := din.exec_o.op0.restore or din.exec_o.op1.restore;
        jump    := din.iexp_o.op0.j_take  or din.iexp_o.op1.j_take;
        jr_jump := din.exec_o.op0.jr_take or din.exec_o.op1.jr_take;

        case current_state is
            when init =>
                if_iexp_wren    := '0';
                iexp_id_wren    := '0';
                id_id2_wren     := '0';
                id2_exec_wren   := '0';
                exec_exec2_wren := '0';
                exec2_wb_wren   := '0';
                inst_sz_sel     := '0';
                restore_sz_sel  := '0';
                pc_wren         := '0';
                next_state      <= init2;

            when init2 =>
                if_iexp_wren    := '0';
                iexp_id_wren    := '0';
                id_id2_wren     := '0';
                id2_exec_wren   := '0';
                exec_exec2_wren := '0';
                exec2_wb_wren   := '0';
                inst_sz_sel     := '1';
                restore_sz_sel  := '0';
                pc_wren         := '1';
                next_state      <= running;

            when running =>
                if restore = '1' then
                    if_iexp_wren    := '0';
                    iexp_id_wren    := '0';
                    id_id2_wren     := '0';
                    id2_exec_wren   := '0';
                    exec_exec2_wren := '1';
                    exec2_wb_wren   := '1';
                    inst_sz_sel     := '0';
                    restore_sz_sel  := '1';
                    pc_wren         := '1';
                    next_state      <= restore_0;
                elsif jr_jump = '1' then
                    if_iexp_wren    := '0';
                    iexp_id_wren    := '0';
                    id_id2_wren     := '0';
                    id2_exec_wren   := '0';
                    exec_exec2_wren := '1';
                    exec2_wb_wren   := '1';
                    inst_sz_sel     := '1';
                    restore_sz_sel  := '0';
                    pc_wren         := '0';
                    next_state      <= running;
                elsif jump = '1' then
                    if_iexp_wren    := '0';
                    iexp_id_wren    := '1';
                    id_id2_wren     := '1';
                    id2_exec_wren   := '1';
                    exec_exec2_wren := '1';
                    exec2_wb_wren   := '1';
                    inst_sz_sel     := '1';
                    restore_sz_sel  := '0';
                    pc_wren         := '1';
                    next_state      <= jump_0;
                else
                    if_iexp_wren    := '1';
                    iexp_id_wren    := '1';
                    id_id2_wren     := '1';
                    id2_exec_wren   := '1';
                    exec_exec2_wren := '1';
                    exec2_wb_wren   := '1';
                    inst_sz_sel     := '0';
                    restore_sz_sel  := '0';
                    pc_wren         := '1';
                    next_state      <= running;
                end if;

            when jump_0 =>
                    if_iexp_wren    := '0';
                    iexp_id_wren    := '1';
                    id_id2_wren     := '1';
                    id2_exec_wren   := '1';
                    exec_exec2_wren := '1';
                    exec2_wb_wren   := '1';
                    inst_sz_sel     := '1';
                    restore_sz_sel  := '0';
                    pc_wren         := '1';
                    next_state      <= running; --jump_1;

            when restore_0 =>
                    if_iexp_wren    := '0';
                    iexp_id_wren    := '0';
                    id_id2_wren     := '0';
                    id2_exec_wren   := '0';
                    exec_exec2_wren := '1';
                    exec2_wb_wren   := '1';
                    inst_sz_sel     := '0';
                    restore_sz_sel  := '1';
                    pc_wren         := '1';
                    next_state      <= running; --jump_1;

            when others =>
                if_iexp_wren    := '0';
                iexp_id_wren    := '0';
                id_id2_wren     := '0';
                id2_exec_wren   := '0';
                exec_exec2_wren := '0';
                exec2_wb_wren   := '0';
                inst_sz_sel     := '0';
                restore_sz_sel  := '0';
                pc_wren         := '0';
                next_state      <= init;
        end case;

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

        -- instruction fetch
        dout.if_i.instruction <= din.icache_data;

        dout.if_i.op0.j_addr <= din.iexp_o.op0.j_addr;
        dout.if_i.op1.j_addr <= din.iexp_o.op1.j_addr;

        dout.if_i.op0.j_take <= din.iexp_o.op0.j_take;
        dout.if_i.op1.j_take <= din.iexp_o.op1.j_take;

        dout.if_i.op0.jr_addr <= din.exec_o.op0.jr_addr;
        dout.if_i.op1.jr_addr <= din.exec_o.op1.jr_addr;

        dout.if_i.op0.jr_take <= din.exec_o.op0.jr_take;
        dout.if_i.op1.jr_take <= din.exec_o.op1.jr_take;

        dout.if_i.op0.restore <= din.exec_o.op0.restore;
        dout.if_i.op1.restore <= din.exec_o.op1.restore;

        dout.if_i.op0.restore_addr <= din.exec_o.op0.restore_addr;
        dout.if_i.op1.restore_addr <= din.exec_o.op1.restore_addr;

        dout.if_i.op0.restore_sz <= din.exec_o.op0.restore_sz;
        dout.if_i.op1.restore_sz <= din.exec_o.op1.restore_sz;

        dout.if_i.inst_sz_sel    <= inst_sz_sel;
        dout.if_i.restore_sz_sel <= restore_sz_sel;
        dout.if_i.pc_wren <= pc_wren;

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


        -- TODO: add state 
        -- if exp
        if clock'event and clock = '1' then
            if reset = '1' then
                dout.iexp_i.instruction <= ZERO;
            else
                if if_iexp_wren = '1' then
                    dout.iexp_i.instruction <= din.if_o.instruction;
                    dout.iexp_i.inst_size   <= din.if_o.inst_size;
                    dout.iexp_i.current_pc  <= din.if_o.current_pc;
                    dout.iexp_i.next_pc     <= din.if_o.next_pc;
                    dout.iexp_i.restore_sz  <= din.if_o.restore_sz;
                else
                    dout.iexp_i.instruction <= ZERO;
                end if;
            end if;
        end if;

        -- exp id
        if reset = '1' then
            dout.id_i.op0.operation    <= NOP;
            dout.id_i.op0.j_take       <= '0';

            dout.id_i.op1.operation    <= NOP;
            dout.id_i.op1.j_take       <= '0';
        elsif clock'event and clock = '1' then
            if iexp_id_wren = '1' then
                dout.id_i.op0.operation    <= din.iexp_o.op0.operation;
                dout.id_i.op0.j_take       <= din.iexp_o.op0.j_take;
                dout.id_i.op0.restore_addr <= din.iexp_o.op0.restore_addr;
                dout.id_i.op0.restore_sz   <= din.iexp_o.op0.restore_sz;

                dout.id_i.op1.operation    <= din.iexp_o.op1.operation;
                dout.id_i.op1.j_take       <= din.iexp_o.op1.j_take;
                dout.id_i.op1.restore_addr <= din.iexp_o.op1.restore_addr;
                dout.id_i.op1.restore_sz   <= din.iexp_o.op1.restore_sz;
            else
                dout.id_i.op0.operation    <= NOP;
                dout.id_i.op0.j_take       <= '0';

                dout.id_i.op1.operation    <= NOP;
                dout.id_i.op1.j_take       <= '0';
            end if;
        end if;

        -- id id2
        if reset = '1' then
            dout.id2_i.op0.pr_reg <= "00";
            dout.id2_i.op1.pr_reg <= "00";

            dout.id2_i.op0.pr_data <= '0';
            dout.id2_i.op1.pr_data <= '0';

            dout.id2_i.op0.control.reg_wren <= '0';
            dout.id2_i.op0.control.mem_wren <= '0';
            dout.id2_i.op0.control.pr_wren  <= '0';
            dout.id2_i.op0.control.j_take   <= '0';
            dout.id2_i.op0.control.jr_take  <= '0';

            dout.id2_i.op1.control.reg_wren <= '0';
            dout.id2_i.op1.control.mem_wren <= '0';
            dout.id2_i.op1.control.pr_wren  <= '0';
            dout.id2_i.op1.control.j_take   <= '0';
            dout.id2_i.op1.control.jr_take  <= '0';

            dout.id2_i.op0.j_take <= '0';
            dout.id2_i.op1.j_take <= '0';
        elsif clock'event and clock = '1' then
            if id_id2_wren = '1' then
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

                dout.id2_i.op0.restore_addr <= din.id_o.op0.restore_addr;
                dout.id2_i.op0.restore_sz   <= din.id_o.op0.restore_sz;
                dout.id2_i.op0.j_take       <= din.id_o.op0.j_take;

                dout.id2_i.op1.restore_addr <= din.id_o.op1.restore_addr;
                dout.id2_i.op1.restore_sz   <= din.id_o.op1.restore_sz;
                dout.id2_i.op1.j_take       <= din.id_o.op1.j_take;
            else
                dout.id2_i.op0.pr_reg <= "00";
                dout.id2_i.op1.pr_reg <= "00";

                dout.id2_i.op0.pr_data <= '0';
                dout.id2_i.op1.pr_data <= '0';

                dout.id2_i.op0.control.reg_wren <= '0';
                dout.id2_i.op0.control.mem_wren <= '0';
                dout.id2_i.op0.control.pr_wren  <= '0';
                dout.id2_i.op0.control.j_take   <= '0';
                dout.id2_i.op0.control.jr_take  <= '0';

                dout.id2_i.op1.control.reg_wren <= '0';
                dout.id2_i.op1.control.mem_wren <= '0';
                dout.id2_i.op1.control.pr_wren  <= '0';
                dout.id2_i.op1.control.j_take   <= '0';
                dout.id2_i.op1.control.jr_take  <= '0';

                dout.id2_i.op0.j_take <= '0';
                dout.id2_i.op1.j_take <= '0';
            end if;
        end if;

        if reset = '1' then
            dout.exec_i.op0.control.reg_wren <= '0';
            dout.exec_i.op0.control.mem_wren <= '0';
            dout.exec_i.op0.control.pr_wren  <= '0';
            dout.exec_i.op0.control.j_take   <= '0';
            dout.exec_i.op0.control.jr_take  <= '0';

            dout.exec_i.op1.control.reg_wren <= '0';
            dout.exec_i.op1.control.mem_wren <= '0';
            dout.exec_i.op1.control.pr_wren  <= '0';
            dout.exec_i.op1.control.j_take   <= '0';
            dout.exec_i.op1.control.jr_take  <= '0';

            dout.exec_i.op0.pr_reg <= "00";
            dout.exec_i.op1.pr_reg <= "00";

            dout.exec_i.op0.pr_data <= '0';
            dout.exec_i.op1.pr_data <= '0';

            dout.exec_i.op0.j_take <= '0';
            dout.exec_i.op1.j_take <= '0';

        elsif clock'event and clock = '1' then
            -- id2 exec
            if id2_exec_wren = '1' then
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

                dout.exec_i.op0.restore_addr <= din.id2_o.op0.restore_addr;
                dout.exec_i.op0.restore_sz   <= din.id2_o.op0.restore_sz;
                dout.exec_i.op0.j_take       <= din.id2_o.op0.j_take;

                dout.exec_i.op1.restore_addr <= din.id2_o.op1.restore_addr;
                dout.exec_i.op1.restore_sz   <= din.id2_o.op1.restore_sz;
                dout.exec_i.op1.j_take       <= din.id2_o.op1.j_take;
            else
                dout.exec_i.op0.control.reg_wren <= '0';
                dout.exec_i.op0.control.mem_wren <= '0';
                dout.exec_i.op0.control.pr_wren  <= '0';
                dout.exec_i.op0.control.j_take   <= '0';
                dout.exec_i.op0.control.jr_take  <= '0';

                dout.exec_i.op1.control.reg_wren <= '0';
                dout.exec_i.op1.control.mem_wren <= '0';
                dout.exec_i.op1.control.pr_wren  <= '0';
                dout.exec_i.op1.control.j_take   <= '0';
                dout.exec_i.op1.control.jr_take  <= '0';

                dout.exec_i.op0.pr_reg <= "00";
                dout.exec_i.op1.pr_reg <= "00";

                dout.exec_i.op0.pr_data <= '0';
                dout.exec_i.op1.pr_data <= '0';

                dout.exec_i.op0.j_take <= '0';
                dout.exec_i.op1.j_take <= '0';
            end if;
        end if;

        if reset = '1' then
            dout.exec2_i.op0.control.reg_wren <= '0';
            dout.exec2_i.op1.control.reg_wren <= '0';
        elsif clock'event and clock = '1' then
            -- exec exec2
            if exec_exec2_wren = '1' then
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
            else
                dout.exec2_i.op0.control.reg_wren <= '0';
                dout.exec2_i.op1.control.reg_wren <= '0';
            end if;
        end if;

        if reset = '1' then
            dout.wb_i.op0.control.reg_wren <= '0';
            dout.wb_i.op1.control.reg_wren <= '0';
        elsif clock'event and clock = '1' then
            -- exec2 wb
            if exec2_wb_wren = '1' then
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
            else
                dout.wb_i.op0.control.reg_wren <= '0';
                dout.wb_i.op1.control.reg_wren <= '0';
            end if;
        end if;
    end process;
end behavior;
