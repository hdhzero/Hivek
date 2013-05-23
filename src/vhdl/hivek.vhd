library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity hivek is
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : in hivek_in_t;
        dout  : out hivek_out_t
    );
end hivek;

architecture behavior of hivek is
    signal pipe_i : pipeline_in_t;
    signal pipe_o : pipeline_out_t;

    signal if_i : instruction_fetch_stage_in_t;
    signal if_o : instruction_fetch_stage_out_t;

    signal iexp_i : instruction_expansion_stage_in_t;
    signal iexp_o : instruction_expansion_stage_out_t;

    signal id_i : instruction_decode_stage_in_t;
    signal id_o : instruction_decode_stage_out_t;

    signal id2_i : instruction_decode2_stage_in_t;
    signal id2_o : instruction_decode2_stage_out_t;

    signal exec_i : execution_stage_in_t;
    signal exec_o : execution_stage_out_t;

    signal exec2_i : execution2_stage_in_t;
    signal exec2_o : execution2_stage_out_t;

    signal wb_i : writeback_stage_in_t;
    signal wb_o : writeback_stage_out_t;
begin
    pipeline_u : pipeline
    port map (
        clock => clock,
        reset => reset,
        din   => pipe_i,
        dout  => pipe_o
    );

    dout.icache_addr <= if_o.icache_addr;
    if_i.instruction <= din.instruction;
    -- TODO
    if_i.op0.jmp_addr <= x"00000000";
    if_i.op0.jmp_taken <= '0';
    if_i.op1.jmp_addr <= x"00000000";
    if_i.op1.jmp_taken <= '0';


    instruction_fetch_stage_u : instruction_fetch_stage
    port map (
        clock => clock,
        reset => reset,
        din   => if_i,
        dout  => if_o
    );

    instruction_expansion_stage_u : instruction_expansion_stage
    port map (
        din  => iexp_i,
        dout => iexp_o
    );

    instruction_decode_stage_u : instruction_decode_stage
    port map (
        clock => clock,
        reset => reset,
        din   => id_i,
        dout  => id_o
    );

    instruction_decode2_stage_u : instruction_decode2_stage
    port map (
        din  => id2_i,
        dout => id2_o
    );

    execution_stage_u : execution_stage
    port map (
        clock => clock,
        reset => reset,
        din   => exec_i,
        dout  => exec_o
    );

    execution2_stage_u : execution2_stage
    port map (
        din  => exec2_i,
        dout => exec2_o
    );

    writeback_stage_u : writeback_stage
    port map (
        din  => wb_i,
        dout => wb_o
    );
end behavior;
