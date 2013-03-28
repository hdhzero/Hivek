library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pack.all;

entity clock_generator is
    port (
        clock   : in std_logic;
        reset   : in std_logic;
        creset  : out std_logic;
        clock1x : out std_logic;
        clock2x : out std_logic
    );
end clock_generator;

architecture behavior of clock_generator is

begin
    clock1x <= clock;
end clock_generator;
