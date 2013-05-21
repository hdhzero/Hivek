library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pack.all;

entity alu_shifter is
    port (
        alu_op       : in alu_op_t;
        shift_type   : in shift_type_t;
        carry_in     : in std_logic;
        operand_a    : in std_logic_vector(31 downto 0);
        operand_b    : in std_logic_vector(31 downto 0);
        shift_amt    : in std_logic_vector(4 downto 0);
        alu_result   : out std_logic_vector(31 downto 0);
        shift_result : out std_logic_vector(31 downto 0);
        carry_out    : out std_logic;
        cmp_flag     : out std_logic
    );
end alu_shifter;

architecture behavior of alu_shifter is
    signal left    : std_logic;
    signal logical : std_logic;

    signal tmp    : unsigned(31 downto 0);
    signal sh_tmp : std_logic_vector(31 downto 0);
begin
    left    <= '1' when shift_type = SH_SLL else '0';
    logical <= '1' when shift_type /= SH_SRA else '0';

    alu_u : alu
    port map (
        operation => alu_op,
        carry_in  => carr_in,
        operand_a => operand_a,
        operand_b => operand_b,
        result    => alu_result,
        carry_out => carry_out,
        cmp_flag  => cmp_flag
    );

    tmp <= unsigned(sh_tmp) + unsigned(operand_a);
    shift_result <= std_logic_vector(tmp);

    barrel_shifter_u : barrel_shifter
    port map (
        left    => left,
        logical => logical,
        shift   => shift_amt,
        input   => operand_b,
        output  => sh_tmp,
    );

end behavior;
