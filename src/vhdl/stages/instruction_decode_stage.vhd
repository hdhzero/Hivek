library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity instruction_decode_stage is
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : instruction_decode_stage_in_t;
        dout  : instruction_decode_stage_out_t
    );
end instruction_decode_stage;

architecture behavior of instruction_decode_stage is
    signal idecoder_i0 : instruction_decoder_in_t;
    signal idecoder_o0 : instruction_decoder_out_t;

    signal idecoder_i1 : instruction_decoder_in_t;
    signal idecoder_o1 : instruction_decoder_out_t;

    signal reg_bank_i : register_bank_in_t;
    signal reg_bank_o : register_bank_out_t;
begin
    -----------------
    -- operation 0 --
    -----------------

    -- register value
    dout.op0.data_ra  <= reg_bank_o.op0.data_ra;
    dout.op0.data_rb  <= reg_bank_o.op0.data_rb;

    -- immd
    dout.op0.immd32   <= idecoder_o0.immd32;

    -- control
    dout.op0.control <= idecoder_o0.control;

    -----------------
    -- operation 1 --
    -----------------

    -- register value
    dout.op0.data_ra  <= reg_bank_o.op0.data_ra;
    dout.op0.data_rb  <= reg_bank_o.op0.data_rb;

    -- immd
    dout.op0.immd32   <= idecoder_o0.immd32;

    -- control
    dout.op0.control <= idecoder_o0.control;

    ---------------
    -- port maps --
    ---------------

    instruction_decoder_u0 : instruction_decoder
    port map (
        din  => idecoder_i0,
        dout => idecoder_o0
    );

    instruction_decoder_u1 : instruction_decoder
    port map (
        din  => idecoder_i1,
        dout => idecoder_o1
    );

    register_bank_u : register_bank
    port map (
        clock  => clock,
        reset  => reset,
        din    => reg_bank_i,
        dout   => reg_bank_o
    );
end behavior;
