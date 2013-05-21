library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity register_bank_tb is
end register_bank_tb;

architecture behavior of register_bank_tb is
    signal clock   : std_logic;
    signal reset   : std_logic;
    signal load0   : std_logic;
    signal load1   : std_logic;
    signal reg_a0  : std_logic_vector(4 downto 0);
    signal reg_b0  : std_logic_vector(4 downto 0);
    signal reg_a1  : std_logic_vector(4 downto 0);
    signal reg_b1  : std_logic_vector(4 downto 0);
    signal reg_c0  : std_logic_vector(4 downto 0);
    signal reg_c1  : std_logic_vector(4 downto 0);
    signal din_c0  : std_logic_vector(31 downto 0);
    signal din_c1  : std_logic_vector(31 downto 0);
    signal dout_a0 : std_logic_vector(31 downto 0);
    signal dout_b0 : std_logic_vector(31 downto 0);
    signal dout_a1 : std_logic_vector(31 downto 0);
    signal dout_b1 : std_logic_vector(31 downto 0);
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
        load0  <= '0';
        load1  <= '0';
        reg_a0 <= "00000";
        reg_b0 <= "00000";
        reg_a1 <= "00000";
        reg_b1 <= "00000";
        reg_c0 <= "00000";
        reg_c1 <= "00000";
        din_c0 <= x"00000000";
        din_c1 <= x"00000000";
        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';

        -- r1 = 1
        reset  <= '0';
        load0  <= '1';
        load1  <= '0';
        reg_a0 <= "00000";
        reg_b0 <= "00000";
        reg_a1 <= "00000";
        reg_b1 <= "00000";
        reg_c0 <= "00001";
        reg_c1 <= "00000";
        din_c0 <= x"00000001";
        din_c1 <= x"00000000";
        wait until clock'event and clock = '1';

        -- r2 = 2
        reset  <= '0';
        load0  <= '0';
        load1  <= '1';
        reg_a0 <= "00000";
        reg_b0 <= "00000";
        reg_a1 <= "00000";
        reg_b1 <= "00000";
        reg_c0 <= "00000";
        reg_c1 <= "00010";
        din_c0 <= x"00000000";
        din_c1 <= x"00000002";
        wait until clock'event and clock = '1';

        -- read r1 and r2
        reset  <= '0';
        load0  <= '0';
        load1  <= '0';
        reg_a0 <= "00001";
        reg_b0 <= "00010";
        reg_a1 <= "00010";
        reg_b1 <= "00001";
        reg_c0 <= "00000";
        reg_c1 <= "00000";
        din_c0 <= x"00000000";
        din_c1 <= x"00000000";
        wait until clock'event and clock = '1';

        -- testing read and write on same clock
        -- r3 = 3 and r4 = 4
        reset  <= '0';
        load0  <= '1';
        load1  <= '1';
        reg_a0 <= "00011";
        reg_b0 <= "00100";
        reg_a1 <= "00011";
        reg_b1 <= "00011";
        reg_c0 <= "00011";
        reg_c1 <= "00100";
        din_c0 <= x"00000003";
        din_c1 <= x"00000004";
        wait until clock'event and clock = '1';

        reset  <= '0';
        load0  <= '0';
        load1  <= '0';
        reg_a0 <= "00000";
        reg_b0 <= "00000";
        reg_a1 <= "00000";
        reg_b1 <= "00000";
        reg_c0 <= "00000";
        reg_c1 <= "00000";
        din_c0 <= x"00000000";
        din_c1 <= x"00000000";
        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';

        reset  <= '0';
        load0  <= '0';
        load1  <= '0';
        reg_a0 <= "00001";
        reg_b0 <= "00010";
        reg_a1 <= "00011";
        reg_b1 <= "00100";
        reg_c0 <= "00000";
        reg_c1 <= "00000";
        din_c0 <= x"00000000";
        din_c1 <= x"00000000";
        wait until clock'event and clock = '1';

        reset  <= '0';
        load0  <= '0';
        load1  <= '0';
        reg_a0 <= "00100";
        reg_b0 <= "00011";
        reg_a1 <= "00010";
        reg_b1 <= "00001";
        reg_c0 <= "00000";
        reg_c1 <= "00000";
        din_c0 <= x"00000000";
        din_c1 <= x"00000000";
        wait until clock'event and clock = '1';

        reset  <= '0';
        load0  <= '0';
        load1  <= '0';
        reg_a0 <= "00001";
        reg_b0 <= "00010";
        reg_a1 <= "00011";
        reg_b1 <= "00100";
        reg_c0 <= "00000";
        reg_c1 <= "00000";
        din_c0 <= x"00000000";
        din_c1 <= x"00000000";
        wait until clock'event and clock = '1';

        reset  <= '0';
        load0  <= '0';
        load1  <= '0';
        reg_a0 <= "00100";
        reg_b0 <= "00011";
        reg_a1 <= "00010";
        reg_b1 <= "00001";
        reg_c0 <= "00000";
        reg_c1 <= "00000";
        din_c0 <= x"00000000";
        din_c1 <= x"00000000";
        wait until clock'event and clock = '1';

        reset  <= '0';
        load0  <= '0';
        load1  <= '0';
        reg_a0 <= "00001";
        reg_b0 <= "00001";
        reg_a1 <= "00001";
        reg_b1 <= "00001";
        reg_c0 <= "00000";
        reg_c1 <= "00000";
        din_c0 <= x"00000000";
        din_c1 <= x"00000000";
        wait until clock'event and clock = '1';

        reset  <= '0';
        load0  <= '0';
        load1  <= '0';
        reg_a0 <= "00010";
        reg_b0 <= "00010";
        reg_a1 <= "00010";
        reg_b1 <= "00010";
        reg_c0 <= "00000";
        reg_c1 <= "00000";
        din_c0 <= x"00000000";
        din_c1 <= x"00000000";
        wait until clock'event and clock = '1';

        reset  <= '0';
        load0  <= '0';
        load1  <= '0';
        reg_a0 <= "00011";
        reg_b0 <= "00011";
        reg_a1 <= "00011";
        reg_b1 <= "00011";
        reg_c0 <= "00000";
        reg_c1 <= "00000";
        din_c0 <= x"00000000";
        din_c1 <= x"00000000";
        wait until clock'event and clock = '1';

        reset  <= '0';
        load0  <= '0';
        load1  <= '0';
        reg_a0 <= "00100";
        reg_b0 <= "00100";
        reg_a1 <= "00100";
        reg_b1 <= "00100";
        reg_c0 <= "00000";
        reg_c1 <= "00000";
        din_c0 <= x"00000000";
        din_c1 <= x"00000000";
        wait until clock'event and clock = '1';

        reset  <= '0';
        load0  <= '0';
        load1  <= '0';
        reg_a0 <= "00000";
        reg_b0 <= "00000";
        reg_a1 <= "00000";
        reg_b1 <= "00000";
        reg_c0 <= "00000";
        reg_c1 <= "00000";
        din_c0 <= x"00000000";
        din_c1 <= x"00000000";
        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';

        -- read and write in the same cycle
        -- 7 and 8
        reset  <= '0';
        load0  <= '1';
        load1  <= '1';
        reg_a0 <= "00111";
        reg_b0 <= "01000";
        reg_a1 <= "00111";
        reg_b1 <= "00111";
        reg_c0 <= "00111";
        reg_c1 <= "01000";
        din_c0 <= x"00000007";
        din_c1 <= x"00000008";
        wait until clock'event and clock = '1';
       
        reset  <= '0';
        load0  <= '1';
        load1  <= '0';
        reg_a0 <= "01000";
        reg_b0 <= "00111";
        reg_a1 <= "00111";
        reg_b1 <= "01000";
        reg_c0 <= "01000";
        reg_c1 <= "00000";
        din_c0 <= x"00000009";
        din_c1 <= x"00000000";
        wait until clock'event and clock = '1';

        reset  <= '0';
        load0  <= '0';
        load1  <= '0';
        reg_a0 <= "00111";
        reg_b0 <= "01000";
        reg_a1 <= "01000";
        reg_b1 <= "00111";
        reg_c0 <= "00000";
        reg_c1 <= "00000";
        din_c0 <= x"00000000";
        din_c1 <= x"00000000";
        wait until clock'event and clock = '1';

        wait;        
    end process;

    register_bank_u : register_bank
    generic map (
        vendor => "GENERIC"
    )
    port map (
        clock   => clock,
        reset   => reset,
        load0   => load0,
        load1   => load1,
        reg_a0  => reg_a0,
        reg_b0  => reg_b0,
        reg_a1  => reg_a1,
        reg_b1  => reg_b1,
        reg_c0  => reg_c0,
        reg_c1  => reg_c1,
        din_c0  => din_c0,
        din_c1  => din_c1,
        dout_a0 => dout_a0,
        dout_b0 => dout_b0,
        dout_a1 => dout_a1,
        dout_b1 => dout_b1
    );
end behavior;
