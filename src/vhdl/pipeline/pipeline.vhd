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
        din   : in pipeline_in_t;
        dout  : out pipeline_out_t
    );
end pipeline;

architecture behavior of pipeline is
begin
    process (clock)
    begin
        if reset = '1' then

        elsif clock'event and clock = '1' then

            -- if exp
            if din.if_iexp_wren = '1' then
                dout.iexp_i.instruction <= din.if_o.instruction;
            end if;


            -- exp id
            if din.iexp_id_wren = '1' then
                dout.id_i.op0.operation <= din.iexp_o.op0.operation;
                dout.id_i.op1.operation <= din.iexp_o.op1.operation;
            end if;
        end if;
    end process;
end behavior;
