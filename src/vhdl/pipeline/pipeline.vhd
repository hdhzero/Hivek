library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

-- This file implements the pipeline
entity pipeline is
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : pipeline_in_t;
        dout  : pipeline_out_t
    );
end pipeline;

architecture pipeline_arch of pipeline is
begin
end pipeline_arch;
