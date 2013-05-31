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
    signal carry_r   : std_logic_vector(1 downto 0);

    signal alu_sh_i0 : alu_shifter_in_t;
    signal alu_sh_i1 : alu_shifter_in_t;

    signal alu_sh_o0 : alu_shifter_out_t;
    signal alu_sh_o1 : alu_shifter_out_t;

    signal pb_i : predicate_bank_in_t;
    signal pb_o : predicate_bank_out_t;

    signal mem_addr_0 : unsigned(31 downto 0);
    signal mem_addr_1 : unsigned(31 downto 0);
begin
    process (clock)
    begin
        if clock'event and clock = '1' then
            carry_r(0) <= alu_sh_o0.carry_out;
            carry_r(1) <= alu_sh_o1.carry_out;
        end if;
    end process;


    process (din, pb_o, alu_sh_o0, alu_sh_o1, carry_r, mem_addr_0, mem_addr_1)
        variable mem_addr_0 : unsigned(31 downto 0);
        variable mem_addr_1 : unsigned(31 downto 0);
        variable operand_a0 : std_logic_vector(31 downto 0);
        variable operand_b0 : std_logic_vector(31 downto 0);
        variable operand_a1 : std_logic_vector(31 downto 0);
        variable operand_b1 : std_logic_vector(31 downto 0);
    begin

        -- forwarding
        -- rA0
        if din.op0.e_e2_wr = '1' and din.op0.e_e2_dst = din.op0.reg_a
            and din.op0.e_e2_alu_sh_sel = '0' then
                operand_a0 := din.op0.e_e2_alu_sh_data;
        elsif din.op1.e_e2_wr = '1' and din.op1.e_e2_dst = din.op0.reg_a
            and din.op1.e_e2_alu_sh_sel = '0' then
                operand_a0 := din.op1.e_e2_alu_sh_data;

        elsif din.op0.e2_wb_wr = '1' and din.op0.e2_wb_dst = din.op0.reg_a then
            operand_a0 := din.op0.e2_wb_alu_sh_mem_data;
        elsif din.op1.e2_wb_wr = '1' and din.op1.e2_wb_dst = din.op0.reg_a then
            operand_a0 := din.op1.e2_wb_alu_sh_mem_data;

        elsif din.op0.wb_delay_wr = '1' and din.op0.wb_delay_dst = din.op0.reg_a then
            operand_a0 := din.op0.wb_delay_data;
        elsif din.op1.wb_delay_wr = '1' and din.op1.wb_delay_dst = din.op0.reg_a then
            operand_a0 := din.op1.wb_delay_data;
        else
            operand_a0 := din.op0.data_a;
        end if;

        -- rA1
        if din.op0.e_e2_wr = '1' and din.op0.e_e2_dst = din.op1.reg_a
            and din.op0.e_e2_alu_sh_sel = '0' then
                operand_a1 := din.op0.e_e2_alu_sh_data;
        elsif din.op1.e_e2_wr = '1' and din.op1.e_e2_dst = din.op1.reg_a
            and din.op1.e_e2_alu_sh_sel = '0' then
                operand_a1 := din.op1.e_e2_alu_sh_data;

        elsif din.op0.e2_wb_wr = '1' and din.op0.e2_wb_dst = din.op1.reg_a then
            operand_a1 := din.op0.e2_wb_alu_sh_mem_data;
        elsif din.op1.e2_wb_wr = '1' and din.op1.e2_wb_dst = din.op1.reg_a then
            operand_a1 := din.op1.e2_wb_alu_sh_mem_data;

        elsif din.op0.wb_delay_wr = '1' and din.op0.wb_delay_dst = din.op1.reg_a then
            operand_a1 := din.op0.wb_delay_data;
        elsif din.op1.wb_delay_wr = '1' and din.op1.wb_delay_dst = din.op1.reg_a then
            operand_a1 := din.op1.wb_delay_data;
        else
            operand_a1 := din.op1.data_a;
        end if;

        -- rB0
        if din.op0.e_e2_wr = '1' and din.op0.e_e2_dst = din.op0.reg_b
            and din.op0.e_e2_alu_sh_sel = '0' then
                operand_b0 := din.op0.e_e2_alu_sh_data;
        elsif din.op1.e_e2_wr = '1' and din.op1.e_e2_dst = din.op0.reg_b
            and din.op1.e_e2_alu_sh_sel = '0' then
                operand_b0 := din.op1.e_e2_alu_sh_data;

        elsif din.op0.e2_wb_wr = '1' and din.op0.e2_wb_dst = din.op0.reg_b then
            operand_b0 := din.op0.e2_wb_alu_sh_mem_data;
        elsif din.op1.e2_wb_wr = '1' and din.op1.e2_wb_dst = din.op0.reg_b then
            operand_b0 := din.op1.e2_wb_alu_sh_mem_data;

        elsif din.op0.wb_delay_wr = '1' and din.op0.wb_delay_dst = din.op0.reg_b then
            operand_b0 := din.op0.wb_delay_data;
        elsif din.op1.wb_delay_wr = '1' and din.op1.wb_delay_dst = din.op0.reg_b then
            operand_b0 := din.op1.wb_delay_data;
        else
            operand_b0 := din.op0.data_b;
        end if;

        -- rA1
        if din.op0.e_e2_wr = '1' and din.op0.e_e2_dst = din.op1.reg_b
            and din.op0.e_e2_alu_sh_sel = '0' then
                operand_b1 := din.op0.e_e2_alu_sh_data;
        elsif din.op1.e_e2_wr = '1' and din.op1.e_e2_dst = din.op1.reg_b
            and din.op1.e_e2_alu_sh_sel = '0' then
                operand_b1 := din.op1.e_e2_alu_sh_data;

        elsif din.op0.e2_wb_wr = '1' and din.op0.e2_wb_dst = din.op1.reg_b then
            operand_b1 := din.op0.e2_wb_alu_sh_mem_data;
        elsif din.op1.e2_wb_wr = '1' and din.op1.e2_wb_dst = din.op1.reg_b then
            operand_b1 := din.op1.e2_wb_alu_sh_mem_data;

        elsif din.op0.wb_delay_wr = '1' and din.op0.wb_delay_dst = din.op1.reg_b then
            operand_b1 := din.op0.wb_delay_data;
        elsif din.op1.wb_delay_wr = '1' and din.op1.wb_delay_dst = din.op1.reg_b then
            operand_b1 := din.op1.wb_delay_data;
        else
            operand_b1 := din.op1.data_b;
        end if;

        -- end forwarding
        alu_sh_i0.alu_op <= din.op0.control.alu_op;
        alu_sh_i1.alu_op <= din.op1.control.alu_op;

        alu_sh_i0.sh_type <= din.op0.control.sh_type;
        alu_sh_i1.sh_type <= din.op1.control.sh_type;

        -- shift ammount select
        if din.op0.control.sh_amt_src_sel = '0' then
            alu_sh_i0.shift_amt <= din.op0.sh_immd;
        else
            alu_sh_i0.shift_amt <= operand_b0(4 downto 0); --din.op0.data_b(4 downto 0);
        end if;

        if din.op1.control.sh_amt_src_sel = '0' then
            alu_sh_i1.shift_amt <= din.op1.sh_immd;
        else
            alu_sh_i1.shift_amt <= operand_b1(4 downto 0); --din.op1.data_b(4 downto 0);
        end if;

        -- operand a
        alu_sh_i0.operand_a <= operand_a0; --din.op0.data_a;
        alu_sh_i1.operand_a <= operand_a1; --din.op1.data_a;

        alu_sh_i0.pr_data_a <= pb_o.op0.data_a;
        alu_sh_i0.pr_data_b <= pb_o.op0.data_b;

        alu_sh_i1.pr_data_a <= pb_o.op0.data_a;
        alu_sh_i1.pr_data_b <= pb_o.op1.data_b;

        alu_sh_i0.carry_in <= carry_r(0);
        alu_sh_i1.carry_in <= carry_r(1);

        -- reg immd select
        if din.op0.control.reg_immd_sel = '0' then
            alu_sh_i0.operand_b <= operand_b0; --din.op0.data_b;
        else
            alu_sh_i0.operand_b <= din.op0.immd32;
        end if;

        if din.op1.control.reg_immd_sel = '0' then
            alu_sh_i1.operand_b <= operand_b1; --din.op1.data_b;
        else
            alu_sh_i1.operand_b <= din.op1.immd32;
        end if;

        -- wrens 0
        if pb_o.op0.data_pr = din.op0.pr_data then
            dout.op0.control.reg_wren <= din.op0.control.reg_wren;
            dout.op0.control.mem_wren <= din.op0.control.mem_wren;
            dout.op0.jr_take          <= din.op0.control.jr_take;
            pb_i.op0.wren             <= din.op0.control.pr_wren;

            if din.op0.control.j_take = '1' then
                if din.op0.j_take = '1' then
                    dout.op0.restore <= '0';
                else
                    dout.op0.restore <= '1';
                end if;
            else
                dout.op0.restore <= '0';
            end if;
        else
            dout.op0.control.reg_wren <= '0';
            dout.op0.control.mem_wren <= '0';
            dout.op0.jr_take          <= '0';
            pb_i.op0.wren             <= '0';

            if din.op0.control.j_take = '1' then
                if din.op0.j_take = '1' then
                    dout.op0.restore <= '1';
                else
                    dout.op0.restore <= '0';
                end if;
            else
                dout.op0.restore <= '0';
            end if;
        end if;

        -- wrens 1
        if pb_o.op1.data_pr = din.op1.pr_data then
            dout.op1.control.reg_wren <= din.op1.control.reg_wren;
            dout.op1.control.mem_wren <= din.op1.control.mem_wren;
            dout.op1.jr_take          <= din.op1.control.jr_take;
            pb_i.op1.wren             <= din.op1.control.pr_wren;

            if din.op1.control.j_take = '1' then
                if din.op1.j_take = '1' then
                    dout.op1.restore <= '0';
                else
                    dout.op1.restore <= '1';
                end if;
            else
                dout.op1.restore <= '0';
            end if;
        else
            dout.op1.control.reg_wren <= '0';
            dout.op1.control.mem_wren <= '0';
            dout.op1.jr_take          <= '0';
            pb_i.op1.wren             <= '0';

            if din.op1.control.j_take = '1' then
                if din.op1.j_take = '1' then
                    dout.op1.restore <= '1';
                else
                    dout.op1.restore <= '0';
                end if;
            else
                dout.op1.restore <= '0';
            end if;
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

        mem_addr_0 := unsigned(operand_a0) + unsigned(din.op0.immd32);
        mem_addr_1 := unsigned(operand_a1) + unsigned(din.op1.immd32);

        dout.op0.mem_data_wr <= operand_b0; --din.op0.data_b;
        dout.op0.mem_addr    <= std_logic_vector(mem_addr_0);

        dout.op1.mem_data_wr <= operand_b1; --din.op1.data_b;
        dout.op1.mem_addr    <= std_logic_vector(mem_addr_1);

        dout.op0.mem_data_rd <= din.op0.mem_data;
        dout.op1.mem_data_rd <= din.op1.mem_data;

        -- jumps!
        dout.op0.jr_addr <= din.op0.data_b;
        dout.op1.jr_addr <= din.op1.data_b;

        dout.op0.restore_sz <= din.op0.restore_sz;
        dout.op1.restore_sz <= din.op1.restore_sz;

        dout.op0.restore_addr <= din.op0.restore_addr;
        dout.op1.restore_addr <= din.op1.restore_addr;
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
