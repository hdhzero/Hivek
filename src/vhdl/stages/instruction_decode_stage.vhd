library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

type id_stage_path_o is record
    data_ra     : std_logic_vector(31 downto 0);
    data_rb     : std_logic_vector(31 downto 0);
    immd32      : std_logic_vector(31 downto 0);
    reg_dst_src : std_logic;
    reg_wren    : std_logic;
    mem_wren    : std_logic;
    alu_src     : std_logic;
    alu_op      : alu_op_t;
    sh_type     : shift_type_t;
    sh_amt_src  : std_logic;
end record;

type id_stage_path_i is record
    instruction : std_logic_vector(31 downto 0);
    reg_rc      : std_logic_vector(4 downto 0);
    data_rc     : std_logic_vector(31 downto 0);
    wren        : std_logic;
end record;

type id_stage_i_t is record
    op0 : id_stage_path_i; 
    op1 : id_stage_path_i;
end record;

type id_stage_o_t is record
    op0 : id_stage_path_o;
    op1 : id_stage_path_o;
end record;

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
