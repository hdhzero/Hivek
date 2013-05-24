library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity register_bank_tb is
end register_bank_tb;

architecture behavior of register_bank_tb is
    signal clock : std_logic;
    signal reset : std_logic;
    signal rb_i  : register_bank_in_t;
    signal rb_o  : register_bank_out_t;
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
        reset  <= '1';
        rb_i.op0.wren  <= '0';
        rb_i.op1.wren  <= '0';
        rb_i.op0.reg_a <= "00000";
        rb_i.op0.reg_b <= "00000";
        rb_i.op1.reg_a <= "00000";
        rb_i.op1.reg_b <= "00000";
        rb_i.op0.reg_c <= "00000";
        rb_i.op1.reg_c <= "00000";
        rb_i.op0.data_c <= x"00000000";
        rb_i.op1.data_c <= x"00000000";
        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';

        reset <= '0';
        rb_i.op0.wren  <= '0';
        rb_i.op1.wren  <= '0';
        rb_i.op0.reg_a <= "00000";
        rb_i.op0.reg_b <= "00000";
        rb_i.op1.reg_a <= "00000";
        rb_i.op1.reg_b <= "00000";
        rb_i.op0.reg_c <= "00000";
        rb_i.op1.reg_c <= "00000";
        rb_i.op0.data_c <= x"00000000";
        rb_i.op1.data_c <= x"00000000";
        wait until clock'event and clock = '1';

        rb_i.op0.wren  <= '1';
        rb_i.op1.wren  <= '0';
        rb_i.op0.reg_a <= "00000";
        rb_i.op0.reg_b <= "00000";
        rb_i.op1.reg_a <= "00000";
        rb_i.op1.reg_b <= "00000";
        rb_i.op0.reg_c <= "00001";
        rb_i.op1.reg_c <= "00000";
        rb_i.op0.data_c <= x"0000000A";
        rb_i.op1.data_c <= x"00000000";
        wait until clock'event and clock = '1';

        rb_i.op0.wren  <= '1';
        rb_i.op1.wren  <= '0';
        rb_i.op0.reg_a <= "00000";
        rb_i.op0.reg_b <= "00000";
        rb_i.op1.reg_a <= "00000";
        rb_i.op1.reg_b <= "00000";
        rb_i.op0.reg_c <= "00010";
        rb_i.op1.reg_c <= "00000";
        rb_i.op0.data_c <= x"00000014";
        rb_i.op1.data_c <= x"00000000";
        wait until clock'event and clock = '1';

        rb_i.op0.wren  <= '1';
        rb_i.op1.wren  <= '0';
        rb_i.op0.reg_a <= "00000";
        rb_i.op0.reg_b <= "00000";
        rb_i.op1.reg_a <= "00000";
        rb_i.op1.reg_b <= "00000";
        rb_i.op0.reg_c <= "00011";
        rb_i.op1.reg_c <= "00000";
        rb_i.op0.data_c <= x"0000001A";
        rb_i.op1.data_c <= x"00000000";
        wait until clock'event and clock = '1';

        rb_i.op0.wren  <= '0';
        rb_i.op1.wren  <= '0';
        rb_i.op0.reg_a <= "00001";
        rb_i.op0.reg_b <= "00010";
        rb_i.op1.reg_a <= "00011";
        rb_i.op1.reg_b <= "00000";
        rb_i.op0.reg_c <= "00000";
        rb_i.op1.reg_c <= "00000";
        rb_i.op0.data_c <= x"00000000";
        rb_i.op1.data_c <= x"00000000";
        wait until clock'event and clock = '1';

        rb_i.op0.wren  <= '0';
        rb_i.op1.wren  <= '0';
        rb_i.op0.reg_a <= "00000";
        rb_i.op0.reg_b <= "00000";
        rb_i.op1.reg_a <= "00000";
        rb_i.op1.reg_b <= "00000";
        rb_i.op0.reg_c <= "00000";
        rb_i.op1.reg_c <= "00000";
        rb_i.op0.data_c <= x"00000000";
        rb_i.op1.data_c <= x"00000000";
        wait until clock'event and clock = '1';

        rb_i.op0.wren  <= '0';
        rb_i.op1.wren  <= '0';
        rb_i.op0.reg_a <= "00001";
        rb_i.op0.reg_b <= "00010";
        rb_i.op1.reg_a <= "00011";
        rb_i.op1.reg_b <= "00000";
        rb_i.op0.reg_c <= "00000";
        rb_i.op1.reg_c <= "00000";
        rb_i.op0.data_c <= x"00000000";
        rb_i.op1.data_c <= x"00000000";
        wait until clock'event and clock = '1';


        wait;        
    end process;

    register_bank_u : register_bank
    generic map (
        vendor => "GENERIC"
    )
    port map (
        clock => clock,
        reset => reset,
        din   => rb_i,
        dout  => rb_o
    );
end behavior;
