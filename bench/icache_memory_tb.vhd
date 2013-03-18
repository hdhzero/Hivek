library ieee;
use ieee.std_logic_1164.all;

library work;
use work.hivek_pack.all;

entity icache_memory_tb is
end icache_memory_tb;

architecture icache_memory_tb of icache_memory_tb is
    signal clock   : std_logic;
    signal load    : std_logic;
    signal address : std_logic_vector(31 downto 0);
    signal data_i  : std_logic_vector(63 downto 0);
    signal data_o  : std_logic_vector(63 downto 0);
begin
    process
    begin
        clock <= '1';
        wait for 5 ns;
        clock <= '0';
        wait for 5 ns;
    end process;

    process
    begin
        load    <= '0';
        address <= x"00000000";
        data_i  <= x"0000000000000000";
        wait for 10 ns;

        load    <= '1';
        address <= x"00000000";
        data_i  <= x"0000000000000000";
        wait for 10 ns;

        load    <= '0';
        address <= x"00000003";
        data_i  <= x"0000000000000007";
        wait for 50 ns;

        load    <= '1';
        address <= x"00000003";
        data_i  <= x"0000000000000007";
        wait for 10 ns;

        load    <= '0';
        address <= x"00000003";
        data_i  <= x"0000000000000007";
        wait for 10 ns;

        wait;
    end process;

    icache_memory_u : icache_memory
    port map (
        clock   => clock,
        load    => load,
        address => address,
        data_i  => data_i,
        data_o  => data_o
    );

end icache_memory_tb;
