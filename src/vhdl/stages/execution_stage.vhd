library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity execution_stage is
    port (
        clock      : in std_logic;
        reset      : in std_logic;
        from_sh_ex : in SH_EX;
        to_ex_mem  : out EX_MEM
    );
end execution_stage;

architecture behavior of execution_stage is
begin
    bank0_o.reg_wren <= bank0_i.reg_wren and 
end behavior;
