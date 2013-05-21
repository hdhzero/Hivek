library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity writeback_stage is
    port (
        din  : writeback_stage_in_t;
        dout : writeback_stage_out_t
    );
end writeback_stage;

architecture writeback_stage of writeback_stage is
begin
    process (din)
    begin
        dout.op0.reg_wren <= din.op0.reg_wren;
        dout.op1.reg_wren <= din.op1.reg_wren;
        
        if din.op0.rc_sel = '0' then
            dout.op0.reg_data <= din.op0.alu_shifter_data;
        else
            dout.op0.data_rc <= din.op0.mem_data;
        end if;

        if din.op1.rc_sel = '0' then
            dout.op1.data_rc <= din.op1.alu_shifter_data;
        else
            dout.op1.data_rc <= din.op1.mem_data;
        end if;
    end process;
end writeback_stage;
