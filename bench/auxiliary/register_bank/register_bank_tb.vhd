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

        -- r1 = 1
        reset  <= '0';
        rb_i.op0.wren  <= '1';
        rb_i.op1.wren  <= '0';
        rb_i.op0.reg_a <= "00000";
        rb_i.op0.reg_b <= "00000";
        rb_i.op1.reg_a <= "00000";
        rb_i.op1.reg_b <= "00000";
        rb_i.op0.reg_c <= "00001";
        rb_i.op1.reg_c <= "00000";
        rb_i.op0.data_c <= x"00000001";
        rb_i.op1.data_c <= x"00000000";
        wait until clock'event and clock = '1';

        -- r2 = 2
        reset  <= '0';
        rb_i.op0.wren  <= '0';
        rb_i.op1.wren  <= '1';
        rb_i.op0.reg_a <= "00000";
        rb_i.op0.reg_b <= "00000";
        rb_i.op1.reg_a <= "00000";
        rb_i.op1.reg_b <= "00000";
        rb_i.op0.reg_c <= "00000";
        rb_i.op1.reg_c <= "00010";
        rb_i.op0.data_c <= x"00000000";
        rb_i.op1.data_c <= x"00000002";
        wait until clock'event and clock = '1';

        -- read r1 and r2
        reset  <= '0';
        rb_i.op0.wren  <= '0';
        rb_i.op1.wren  <= '0';
        rb_i.op0.reg_a <= "00001";
        rb_i.op0.reg_b <= "00010";
        rb_i.op1.reg_a <= "00010";
        rb_i.op1.reg_b <= "00001";
        rb_i.op0.reg_c <= "00000";
        rb_i.op1.reg_c <= "00000";
        rb_i.op0.data_c <= x"00000000";
        rb_i.op1.data_c <= x"00000000";
        wait until clock'event and clock = '1';

        -- testing read and write on same clock
        -- r3 = 3 and r4 = 4
        reset  <= '0';
        rb_i.op0.wren  <= '1';
        rb_i.op1.wren  <= '1';
        rb_i.op0.reg_a <= "00011";
        rb_i.op0.reg_b <= "00100";
        rb_i.op1.reg_a <= "00011";
        rb_i.op1.reg_b <= "00011";
        rb_i.op0.reg_c <= "00011";
        rb_i.op1.reg_c <= "00100";
        rb_i.op0.data_c <= x"00000003";
        rb_i.op1.data_c <= x"00000004";
        wait until clock'event and clock = '1';

        reset  <= '0';
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

        reset  <= '0';
        rb_i.op0.wren  <= '0';
        rb_i.op1.wren  <= '0';
        rb_i.op0.reg_a <= "00001";
        rb_i.op0.reg_b <= "00010";
        rb_i.op1.reg_a <= "00011";
        rb_i.op1.reg_b <= "00100";
        rb_i.op0.reg_c <= "00000";
        rb_i.op1.reg_c <= "00000";
        rb_i.op0.data_c <= x"00000000";
        rb_i.op1.data_c <= x"00000000";
        wait until clock'event and clock = '1';

        reset  <= '0';
        rb_i.op0.wren  <= '0';
        rb_i.op1.wren  <= '0';
        rb_i.op0.reg_a <= "00100";
        rb_i.op0.reg_b <= "00011";
        rb_i.op1.reg_a <= "00010";
        rb_i.op1.reg_b <= "00001";
        rb_i.op0.reg_c <= "00000";
        rb_i.op1.reg_c <= "00000";
        rb_i.op0.data_c <= x"00000000";
        rb_i.op1.data_c <= x"00000000";
        wait until clock'event and clock = '1';

        reset  <= '0';
        rb_i.op0.wren  <= '0';
        rb_i.op1.wren  <= '0';
        rb_i.op0.reg_a <= "00001";
        rb_i.op0.reg_b <= "00010";
        rb_i.op1.reg_a <= "00011";
        rb_i.op1.reg_b <= "00100";
        rb_i.op0.reg_c <= "00000";
        rb_i.op1.reg_c <= "00000";
        rb_i.op0.data_c <= x"00000000";
        rb_i.op1.data_c <= x"00000000";
        wait until clock'event and clock = '1';

        reset  <= '0';
        rb_i.op0.wren  <= '0';
        rb_i.op1.wren  <= '0';
        rb_i.op0.reg_a <= "00100";
        rb_i.op0.reg_b <= "00011";
        rb_i.op1.reg_a <= "00010";
        rb_i.op1.reg_b <= "00001";
        rb_i.op0.reg_c <= "00000";
        rb_i.op1.reg_c <= "00000";
        rb_i.op0.data_c <= x"00000000";
        rb_i.op1.data_c <= x"00000000";
        wait until clock'event and clock = '1';

        reset  <= '0';
        rb_i.op0.wren  <= '0';
        rb_i.op1.wren  <= '0';
        rb_i.op0.reg_a <= "00001";
        rb_i.op0.reg_b <= "00001";
        rb_i.op1.reg_a <= "00001";
        rb_i.op1.reg_b <= "00001";
        rb_i.op0.reg_c <= "00000";
        rb_i.op1.reg_c <= "00000";
        rb_i.op0.data_c <= x"00000000";
        rb_i.op1.data_c <= x"00000000";
        wait until clock'event and clock = '1';

        reset  <= '0';
        rb_i.op0.wren  <= '0';
        rb_i.op1.wren  <= '0';
        rb_i.op0.reg_a <= "00010";
        rb_i.op0.reg_b <= "00010";
        rb_i.op1.reg_a <= "00010";
        rb_i.op1.reg_b <= "00010";
        rb_i.op0.reg_c <= "00000";
        rb_i.op1.reg_c <= "00000";
        rb_i.op0.data_c <= x"00000000";
        rb_i.op1.data_c <= x"00000000";
        wait until clock'event and clock = '1';

        reset  <= '0';
        rb_i.op0.wren  <= '0';
        rb_i.op1.wren  <= '0';
        rb_i.op0.reg_a <= "00011";
        rb_i.op0.reg_b <= "00011";
        rb_i.op1.reg_a <= "00011";
        rb_i.op1.reg_b <= "00011";
        rb_i.op0.reg_c <= "00000";
        rb_i.op1.reg_c <= "00000";
        rb_i.op0.data_c <= x"00000000";
        rb_i.op1.data_c <= x"00000000";
        wait until clock'event and clock = '1';

        reset  <= '0';
        rb_i.op0.wren  <= '0';
        rb_i.op1.wren  <= '0';
        rb_i.op0.reg_a <= "00100";
        rb_i.op0.reg_b <= "00100";
        rb_i.op1.reg_a <= "00100";
        rb_i.op1.reg_b <= "00100";
        rb_i.op0.reg_c <= "00000";
        rb_i.op1.reg_c <= "00000";
        rb_i.op0.data_c <= x"00000000";
        rb_i.op1.data_c <= x"00000000";
        wait until clock'event and clock = '1';

        reset  <= '0';
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

        -- read and write in the same cycle
        -- 7 and 8
        reset  <= '0';
        rb_i.op0.wren  <= '1';
        rb_i.op1.wren  <= '1';
        rb_i.op0.reg_a <= "00111";
        rb_i.op0.reg_b <= "01000";
        rb_i.op1.reg_a <= "00111";
        rb_i.op1.reg_b <= "00111";
        rb_i.op0.reg_c <= "00111";
        rb_i.op1.reg_c <= "01000";
        rb_i.op0.data_c <= x"00000007";
        rb_i.op1.data_c <= x"00000008";
        wait until clock'event and clock = '1';
       
        reset  <= '0';
        rb_i.op0.wren  <= '1';
        rb_i.op1.wren  <= '0';
        rb_i.op0.reg_a <= "01000";
        rb_i.op0.reg_b <= "00111";
        rb_i.op1.reg_a <= "00111";
        rb_i.op1.reg_b <= "01000";
        rb_i.op0.reg_c <= "01000";
        rb_i.op1.reg_c <= "00000";
        rb_i.op0.data_c <= x"00000009";
        rb_i.op1.data_c <= x"00000000";
        wait until clock'event and clock = '1';

        reset  <= '0';
        rb_i.op0.wren  <= '0';
        rb_i.op1.wren  <= '0';
        rb_i.op0.reg_a <= "00111";
        rb_i.op0.reg_b <= "01000";
        rb_i.op1.reg_a <= "01000";
        rb_i.op1.reg_b <= "00111";
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
