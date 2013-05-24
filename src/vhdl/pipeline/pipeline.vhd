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
    process (clock)
    begin
        if reset = '1' then

        elsif clock'event and clock = '1' then

            -- if exp
      --      if din.if_iexp_wren = '1' then
                dout.iexp_i.instruction <= din.if_o.instruction;
        --    end if;


            -- exp id
    --        if din.iexp_id_wren = '1' then
                dout.id_i.op0.operation <= din.iexp_o.op0.operation;
                dout.id_i.op1.operation <= din.iexp_o.op1.operation;
                -- TODO
                -- from wb_o.reg_wren
                dout.id_i.op0.reg_wren <= '0';

                -- from wb_o.reg_dst;
                dout.id_i.op0.reg_dst <= "00000";

                -- from wb_o.data_dst, where
                -- data_dst is mux from alu_sh and mem
                dout.id_i.op0.data_dst <= (others => '0');
     --       end if;

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

            dout.id2_i.op0.data_a <= din.id_o.op0.data_a;
            dout.id2_i.op1.data_a <= din.id_o.op1.data_a;

            dout.id2_i.op0.data_b <= din.id_o.op0.data_b;
            dout.id2_i.op1.data_b <= din.id_o.op1.data_b;

            dout.id2_i.op0.immd32 <= din.id_o.op0.immd32;
            dout.id2_i.op1.immd32 <= din.id_o.op1.immd32;

            dout.id2_i.op0.control <= din.id_o.op0.control;
            dout.id2_i.op1.control <= din.id_o.op1.control;

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

            --dout.exec_i.op0.mem_data <= din.id2_o.op0.mem_data;
            --dout.exec_i.op1.mem_data <= din.id2_o.op1.mem_data;

            dout.exec_i.op0.control <= din.id2_o.op0.control;
            dout.exec_i.op1.control <= din.id2_o.op1.control;
        end if;
    end process;
end behavior;
