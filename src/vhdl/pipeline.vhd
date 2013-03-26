library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- This file implements the pipeline
entity pipeline is
    generic (
        stages : natural := 7
    );
    port (
        clock : in std_logic;
        reset : in std_logic;
    );
end pipeline;

architecture pipeline_arch of pipeline is

    signal 
begin
    process (clock, reset)
    begin
        
    end process;
end pipeline_arch;
