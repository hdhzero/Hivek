library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity execution_stage is
    port (
        clock      : in std_logic;
        reset      : in std_logic;
        pipe_i 
        pipe_o
        forward_i
        forward_o
        hazard_i
        hazard_o
    );
end execution_stage;

architecture behavior of execution_stage is
begin
    alu_shifter_u0 : alu_shifter
    port map (

    );

    alu_shifter_u1 : alu_shifter
    port map (

    );
end behavior;
