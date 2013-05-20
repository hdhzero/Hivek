library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity instruction_decode_stage is
    port (
        clock  : in std_logic;
        reset  : in std_logic;

        -- instructions
        operation0 : in std_logic_vector(31 downto 0);
        operation1 : in std_logic_vector(31 downto 0);

        -- data signals 
        immd320_o : out std_logic_vector(31 downto 0);
        immd321_o : out std_logic_vector(31 downto 0);

        data_a0_o : out std_logic_vector(31 downto 0);
        data_b0_o : out std_logic_vector(31 downto 0);

        data_a1_o : out std_logic_vector(31 downto 0);
        data_b1_o : out std_logic_vector(31 downto 0);

        -- control signals
        reg_dst_src0_o    : out std_logic;
        reg_wren0_o       : out std_logic;
        mem_wren0_o       : out std_logic;
        alu_src0_o        : out std_logic;
        alu_op0_o         : out alu_op_t;
        shift_type0_o     : out shift_type_t;
        shift_ammt_src0_o : out std_logic;

        reg_dst_src1_o    : out std_logic;
        reg_wren1_o       : out std_logic;
        mem_wren1_o       : out std_logic;
        alu_src1_o        : out std_logic;
        alu_op1_o         : out alu_op_t;
        shift_type1_o     : out shift_type_t;
        shift_ammt_src1_o : out std_logic;

        reg_dst0_i : in std_logic_vector(4 downto 0);
        reg_dst1_i : in std_logic_vector(4 downto 0);

    );
end instruction_decode_stage;

architecture behavior of instruction_decode_stage is
    alias immd12_0 : std_logic_vector(11 downto 0) is instruction0(24 downto 13);
    alias immd12_1 : std_logic_vector(11 downto 0) is instruction1(24 downto 13);
    alias reg_a0 : std_logic_vector(4 downto 0) is instruction0(7 downto 3);
begin
    instruction_decoder_u0 : instruction_decoder
    port map (
        instruction => pipe_i.bank0.instruction,
        control => bank0.control
    );

    instruction_decoder_u1 : instruction_decoder
    port map (
        instruction => pipe_i.bank1.instruction,
        control => bank1.control
    );

    register_bank_u : register_bank
    port map (
        clock  => clock,
        reset  => reset,
        load0  => reg_wren_i_0,
        load1  => reg_wren_i_1,
        reg_a0 => reg_a0,
        reg_b0 => reg_b0,
        reg_a1 => reg_a1,
        reg_b1 => reg_b1,
        reg_c0 => reg_dst_i_0,
        reg_c1 => reg_dst_i_1,
        dout_a0 => reg_a_data_0,
        dout_b0 => reg_b_data_0,
        dout_a1 => reg_a_data_1,
    );
end behavior;
