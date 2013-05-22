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
end behavior;
