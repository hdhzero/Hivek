library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity instruction_decode_stage is
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : in instruction_decode_stage_in_t;
        dout  : out instruction_decode_stage_out_t
    );
end instruction_decode_stage;

architecture behavior of instruction_decode_stage is
    signal odecoder_i0 : operation_decoder_in_t;
    signal odecoder_o0 : operation_decoder_out_t;

    signal odecoder_i1 : operation_decoder_in_t;
    signal odecoder_o1 : operation_decoder_out_t;

    signal reg_bank_i : register_bank_in_t;
    signal reg_bank_o : register_bank_out_t;
begin
    -----------------
    -- operation 0 --
    -----------------

    -- register value
    dout.op0.data_a  <= reg_bank_o.op0.data_a;
    dout.op0.data_b  <= reg_bank_o.op0.data_b;

    -- immd
    dout.op0.immd32 <= odecoder_o0.immd32;

    -- control
    dout.op0.control <= odecoder_o0.control;

    -----------------
    -- operation 1 --
    -----------------

    -- register value
    dout.op0.data_a  <= reg_bank_o.op0.data_a;
    dout.op0.data_b  <= reg_bank_o.op0.data_b;

    -- immd
    dout.op0.immd32 <= odecoder_o0.immd32;

    -- control
    dout.op0.control <= odecoder_o0.control;

    ---------------
    -- port maps --
    ---------------

    operation_decoder_u0 : operation_decoder
    port map (
        din  => odecoder_i0,
        dout => odecoder_o0
    );

    operation_decoder_u1 : operation_decoder
    port map (
        din  => odecoder_i1,
        dout => odecoder_o1
    );

    reg_bank_i.op0.wren <= din.op0.reg_wren;
    reg_bank_i.op1.wren <= din.op1.reg_wren;

    reg_bank_i.op0.reg_a <= odecoder_o0.reg_a;
    reg_bank_i.op1.reg_a <= odecoder_o1.reg_a;

    reg_bank_i.op0.reg_b <= odecoder_o0.reg_b;
    reg_bank_i.op1.reg_b <= odecoder_o1.reg_b;

    reg_bank_i.op0.reg_c <= din.op0.reg_dst;
    reg_bank_i.op1.reg_c <= din.op1.reg_dst;

    reg_bank_i.op0.data_c <= din.op0.data_dst;
    reg_bank_i.op1.data_c <= din.op1.data_dst;

    register_bank_u : register_bank
    generic map (
        vendor => "GENERIC"
    )
    port map (
        clock  => clock,
        reset  => reset,
        din    => reg_bank_i,
        dout   => reg_bank_o
    );
end behavior;
