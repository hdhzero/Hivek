library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity alu_tb is
end alu_tb;

architecture behavior of alu_tb is
    signal clock : std_logic;
    signal din   : alu_in_t;
    signal dout  : alu_out_t;
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
        din.operation <= ALU_ADD;
        din.carry_in  <= '0';
        din.operand_a <= x"00000000";
        din.operand_b <= x"00000000";
        wait until clock'event and clock = '1';

        din.operation <= ALU_ADD;
        din.carry_in  <= '0';
        din.operand_a <= x"00000001";
        din.operand_b <= x"FFFFFFFF";
        wait until clock'event and clock = '1';

        din.operation <= ALU_CMPGT;
        din.carry_in  <= '0';
        din.operand_a <= x"00000001";
        din.operand_b <= x"FFFFFFFF";
        wait until clock'event and clock = '1';

        din.operation <= ALU_CMPGTU;
        din.carry_in  <= '0';
        din.operand_a <= x"00000001";
        din.operand_b <= x"FFFFFFFF";
        wait until clock'event and clock = '1';

        din.operation <= ALU_CMPLT;
        din.carry_in  <= '0';
        din.operand_a <= x"00000001";
        din.operand_b <= x"FFFFFFFF";
        wait until clock'event and clock = '1';

        din.operation <= ALU_CMPLTU;
        din.carry_in  <= '0';
        din.operand_a <= x"00000001";
        din.operand_b <= x"FFFFFFFF";
        wait until clock'event and clock = '1';

        din.operation <= ALU_ADC;
        din.carry_in  <= '1';
        din.operand_a <= x"00000001";
        din.operand_b <= x"00000000";
        wait until clock'event and clock = '1';

        din.operation <= ALU_ADD;
        din.carry_in  <= '0';
        din.operand_a <= x"00000000";
        din.operand_b <= x"00000000";
        wait until clock'event and clock = '1';

        wait;
    end process;

    alu_u : alu
    port map (
        din => din,
        dout => dout
    );
end behavior;

