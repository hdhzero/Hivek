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

        sh_ex_i : in SH_EX;
        sh_ex_o : out SH_EX;
    );
end pipeline;

architecture pipeline_arch of pipeline is
    signal sh_ex_reg : SH_EX;
begin
    sh_ex_o <= sh_ex_reg;

    process (clock, reset)
    begin
        if reset = '1' then
            sh_ex_reg <= (others => (others => '0'));
        elsif clock'event and clock = '1' then
            sh_ex_reg <= sh_ex_i;
        end if;
    end process;
end pipeline_arch;
