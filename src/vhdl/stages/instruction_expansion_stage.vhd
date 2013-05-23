library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity instruction_expansion_stage is
    port (
        din  : in instruction_expansion_stage_in_t;
        dout : out instruction_expansion_stage_out_t
    );
end instruction_expansion_stage;

architecture behavior of instruction_expansion_stage is
begin
    dout.op0.operation <= din.instruction(63 downto 32);
    dout.op1.operation <= din.instruction(31 downto 0);
end behavior;
