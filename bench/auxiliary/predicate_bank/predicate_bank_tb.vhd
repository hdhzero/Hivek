library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity predicate_bank_tb is
end predicate_bank_tb;

architecture behavior of predicate_bank_tb is
    signal clock : std_logic;
    signal reset : std_logic;
    signal pb_i  : predicate_bank_in_t;
    signal pb_o  : predicate_bank_out_t;
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
        reset <= '1';
        pb_i.op0.wren   <= '0';
        pb_i.op0.data   <= '0';
        pb_i.op0.reg_pr <= "00";
        pb_i.op0.reg_a  <= "00";
        pb_i.op0.reg_b  <= "00";
        pb_i.op0.reg_c  <= "00";

        pb_i.op1.wren   <= '0';
        pb_i.op1.data   <= '0';
        pb_i.op1.reg_pr <= "00";
        pb_i.op1.reg_a  <= "00";
        pb_i.op1.reg_b  <= "00";
        pb_i.op1.reg_c  <= "00";
        wait until clock'event and clock = '1';

        reset <= '0';
        pb_i.op0.wren   <= '0';
        pb_i.op0.data   <= '0';
        pb_i.op0.reg_pr <= "00";
        pb_i.op0.reg_a  <= "00";
        pb_i.op0.reg_b  <= "00";
        pb_i.op0.reg_c  <= "00";

        pb_i.op1.wren   <= '0';
        pb_i.op1.data   <= '0';
        pb_i.op1.reg_pr <= "00";
        pb_i.op1.reg_a  <= "00";
        pb_i.op1.reg_b  <= "00";
        pb_i.op1.reg_c  <= "00";
        wait until clock'event and clock = '1';

        pb_i.op0.wren   <= '1';
        pb_i.op0.data   <= '0';
        pb_i.op0.reg_pr <= "00";
        pb_i.op0.reg_a  <= "00";
        pb_i.op0.reg_b  <= "00";
        pb_i.op0.reg_c  <= "01";

        pb_i.op1.wren   <= '1';
        pb_i.op1.data   <= '0';
        pb_i.op1.reg_pr <= "00";
        pb_i.op1.reg_a  <= "00";
        pb_i.op1.reg_b  <= "00";
        pb_i.op1.reg_c  <= "10";
        wait until clock'event and clock = '1';

        pb_i.op0.wren   <= '1';
        pb_i.op0.data   <= '1';
        pb_i.op0.reg_pr <= "10";
        pb_i.op0.reg_a  <= "00";
        pb_i.op0.reg_b  <= "00";
        pb_i.op0.reg_c  <= "10";

        pb_i.op1.wren   <= '1';
        pb_i.op1.data   <= '0';
        pb_i.op1.reg_pr <= "01";
        pb_i.op1.reg_a  <= "00";
        pb_i.op1.reg_b  <= "00";
        pb_i.op1.reg_c  <= "00";
        wait until clock'event and clock = '1';

        pb_i.op0.wren   <= '0';
        pb_i.op0.data   <= '0';
        pb_i.op0.reg_pr <= "00";
        pb_i.op0.reg_a  <= "01";
        pb_i.op0.reg_b  <= "10";
        pb_i.op0.reg_c  <= "00";

        pb_i.op1.wren   <= '0';
        pb_i.op1.data   <= '0';
        pb_i.op1.reg_pr <= "11";
        pb_i.op1.reg_a  <= "10";
        pb_i.op1.reg_b  <= "01";
        pb_i.op1.reg_c  <= "00";
        wait until clock'event and clock = '1';

        pb_i.op0.wren   <= '0';
        pb_i.op0.data   <= '0';
        pb_i.op0.reg_pr <= "00";
        pb_i.op0.reg_a  <= "00";
        pb_i.op0.reg_b  <= "00";
        pb_i.op0.reg_c  <= "00";

        pb_i.op1.wren   <= '0';
        pb_i.op1.data   <= '0';
        pb_i.op1.reg_pr <= "00";
        pb_i.op1.reg_a  <= "00";
        pb_i.op1.reg_b  <= "00";
        pb_i.op1.reg_c  <= "00";
        wait until clock'event and clock = '1';

        wait;
    end process;

    predicate_bank_u : predicate_bank
    port map (
        clock => clock,
        reset => reset,
        din   => pb_i,
        dout  => pb_o
    );
end behavior;

