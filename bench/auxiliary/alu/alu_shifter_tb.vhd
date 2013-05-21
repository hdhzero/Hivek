library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity alu_shifter_tb is
end alu_shifter_tb;

architecture behavior of alu_shifter_tb is
    signal clock : std_logic;
    signal as_i  : alu_shifter_in_t;
    signal as_o  : alu_shifter_out_t;
begin
    process
    begin
        clock <= '0';
        wait for 5 ns;
        clock <= '1';
        wait for 5 ns;
    end process;

    process
    begin
        as_i.alu_op     <= ALU_ADD;
        as_i.shift_type <= SH_SLL;
        as_i.carry_in   <= '0';
        as_i.operand_a  <= x"00000000";
        as_i.operand_b  <= x"00000000";
        as_i.shift_amt  <= "00000";
        wait until clock'event and clock = '1';

        as_i.alu_op     <= ALU_ADD;
        as_i.shift_type <= SH_SLL;
        as_i.carry_in   <= '0';
        as_i.operand_a  <= x"00000000";
        as_i.operand_b  <= x"00000001";
        as_i.shift_amt  <= "00001";
        wait until clock'event and clock = '1';

        as_i.alu_op     <= ALU_SUB;
        as_i.shift_type <= SH_SLL;
        as_i.carry_in   <= '0';
        as_i.operand_a  <= x"00000000";
        as_i.operand_b  <= x"00000001";
        as_i.shift_amt  <= "00011";
        wait until clock'event and clock = '1';

        as_i.alu_op     <= ALU_ADD;
        as_i.shift_type <= SH_SLL;
        as_i.carry_in   <= '0';
        as_i.operand_a  <= x"00000000";
        as_i.operand_b  <= x"00000000";
        as_i.shift_amt  <= "00000";
        wait until clock'event and clock = '1';

        wait;
    end process;

    alu_shifter_u : alu_shifter
    port map (
        din  => as_i,
        dout => as_o
    );
end behavior;
