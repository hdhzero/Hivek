library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pack.all;

entity reg_bram_tb is
end reg_bram_tb;

architecture reg_bram_tb of reg_bram_tb is
    signal clock  : std_logic;
    signal wren   : std_logic;
    signal wraddr : std_logic_vector(4 downto 0);
    signal rdaddr : std_logic_vector(4 downto 0);
    signal din    : std_logic_vector(31 downto 0);
    signal dout   : std_logic_vector(31 downto 0);
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
        wren   <= '0';
        wraddr <= "00000";
        rdaddr <= "00000";
        din    <= x"00000000";
        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';

        wren   <= '1';
        wraddr <= "00000";
        rdaddr <= "00000";
        din    <= x"00000001";
        wait until clock'event and clock = '1';

        wren   <= '0';
        wraddr <= "00000";
        rdaddr <= "00000";
        din    <= x"00000000";
        wait until clock'event and clock = '1';

        wait;
    end process;

    reg_bram_u : reg_bram
    generic map (
        vendor => "ALTERA"
    )
    port map (
        clock  => clock,
        wren   => wren,
        wraddr => wraddr,
        rdaddr => rdaddr,
        din    => din,
        dout   => dout
    );
end reg_bram_tb;
