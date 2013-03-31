library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pack.all;

entity memory_stage is
    port (
        clock   : in std_logic;
        clock2x : in std_logic;
    );
end memory_stage;

architecture behavior of memory_stage is
begin
end behavior;
