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
    --bank0.reg_dst <= 
        --pipe_i.bank0.reg_rc when pipe_i.bank0.reg_dst_src = '0' 
        --else  pipe_i.bank0.reg_ra;

    --process
    --begin
        --if pipe_i.bank
    --end process;
end behavior;

