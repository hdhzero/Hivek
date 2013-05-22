library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity hivek_tb is
end hivek_tb;

architecture behavior of hivek_tb is
    signal clock : std_logic;
    signal reset : std_logic;

    signal hivek_i : hivek_in_t;
    signal hivek_o : hivek_out_t;

    --signal im_i : icache_memory_in_t;
    --signal im_o : icache_memory_out_t;

    --signal dm_i : dcache_memory_in_t;
    --signal dm_o : dcache_memory_out_t;

begin
    process
    begin
        clock <= '0';
        wait for 5 ns;
        clock <= '1';
        wait for 5 ns;
    end process;

    hivek_u : hivek
    port map (
        clock => clock,
        reset => reset,
        din   => hivek_i,
        dout  => hivek_o
    );

    --icache_memory_u : icache_memory
    --port map (
        --clock => clock
        --din   => im_i,
        --dout  => im_o
    --);

    --dcache_memory_u : dcache_memory
    --port map (
        --clock => clock,
        --din   => dm_i,
        --dout  => dm_o
    --);

end behavior;

