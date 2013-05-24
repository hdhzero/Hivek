library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity execution2_stage is
    port (
        din  : in execution2_stage_in_t;
        dout : out execution2_stage_out_t
    );
end execution2_stage;

architecture behavior of execution2_stage is
begin
    process (din)
    begin
        if din.op0.control.alu_sh_sel = '0' then
            dout.op0.alu_sh_data <= din.op0.alu_data;
        else
            dout.op0.alu_sh_data <= din.op0.sh_data;
        end if;

        if din.op1.control.alu_sh_sel = '0' then
            dout.op1.alu_sh_data <= din.op1.alu_data;
        else
            dout.op1.alu_sh_data <= din.op1.sh_data;
        end if;


        -- reg dst
        dout.op0.reg_dst <= din.op0.reg_dst;
        dout.op1.reg_dst <= din.op1.reg_dst;

        -- controls
        dout.op0.control.alu_sh_mem_sel <= din.op0.control.alu_sh_mem_sel;
        dout.op1.control.alu_sh_mem_sel <= din.op1.control.alu_sh_mem_sel;

        dout.op0.control.reg_wren <= din.op0.control.reg_wren;
        dout.op1.control.reg_wren <= din.op1.control.reg_wren;

    end process;
end behavior;
