library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

library work;
use work.hivek_pkg.all;

entity hivek_tb is
end hivek_tb;

architecture behavior of hivek_tb is
    signal clock : std_logic;
    signal reset : std_logic;

    signal hivek_i : hivek_in_t;
    signal hivek_o : hivek_out_t;

    signal idata_file : std_logic_vector(63 downto 0);

    file arquivo : text open read_mode is "prog.txt";
--    file saida   : text open write_mode is "saida.txt";

    function str_to_std(s : string(8 downto 1)) return std_logic_vector is
        variable vetor : std_logic_vector(7 downto 0);
    begin
        for i in s'range loop
            if s(i) = '1' then
                vetor(i - 1) := '1';
            else
                vetor(i - 1) := '0';
            end if;
        end loop;

        return vetor;
    end function str_to_std;
begin

    init_mem : process 
        variable linha : line;
        variable ss    : string(8 downto 1);
        variable data  : std_logic_vector(63 downto 0);
        variable flag  : integer := 0;
        variable i     : integer := 0;
    begin
        flag := 0;
        i := 0;

        readline(arquivo, linha);
        read(linha, ss);

        assert ss = "   .text"
            report "fault program. There is no .text header"
            severity ERROR; -- warning failure

        while ss /= ".data" loop
            i := 7;

            while not endfile(arquivo) loop
                readline(arquivo, linha);
                read(linha, ss);

                if ss = "   .data" then
                    exit;
                end if;

                if i >= 0 then
                    data(8 * (i + 1) - 1 downto 8 * i) := str_to_std(ss);
                    i := i - 1;
                end if;
            end loop;

            while i >= 0 loop
                data(8 * (i + 1) - 1 downto 8 * i) := "00000000";
                i := i - 1;
            end loop;

            wait until clock'event and clock = '1';
            idata_file <= data;
        end loop;

        wait;
    end process;

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
        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';
        reset <= '0';

        reset <= '1';
        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';
        reset <= '0';

        wait;
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

