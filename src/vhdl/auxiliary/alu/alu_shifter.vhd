library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity alu_shifter is
    port (
        din  : in alu_shifter_in_t;
        dout : out alu_shifter_out_t
    );
end alu_shifter;

architecture behavior of alu_shifter is
    signal tmp    : unsigned(31 downto 0);

    signal bsh_i : barrel_shifter_in_t;
    signal bsh_o : barrel_shifter_out_t;

    signal alu_i : alu_in_t;
    signal alu_o : alu_out_t;
begin
    alu_i.operation <= din.alu_op;
    alu_i.carry_in  <= din.carry_in;
    alu_i.operand_a <= din.operand_a;
    alu_i.operand_b <= din.operand_b;

    dout.alu_result   <= alu_o.result;
    dout.shift_result <= std_logic_vector(tmp);
    dout.carry_out    <= alu_o.carry_out;
    dout.cmp_flag     <= alu_o.cmp_flag;

    alu_u : alu
    port map (
        din  => alu_i,
        dout => alu_o
    );

    tmp <= unsigned(bsh_o.output) + unsigned(din.operand_a);

    bsh_i.left    <= '1' when din.shift_type = SH_SLL else '0';
    bsh_i.logical <= '1' when din.shift_type /= SH_SRA else '0';
    bsh_i.shift   <= din.shift_amt;
    bsh_i.input   <= din.operand_b;

    barrel_shifter_u : barrel_shifter
    port map (
        din  => bsh_i,
        dout => bsh_o
    );

end behavior;
