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
    --process (din)
    --begin
        --if din.op0.control.alu_sh_sel = '0' then
            --dout.op0.alu_sh_data <= din.op0.alu_data;
    --end process;
end behavior;
