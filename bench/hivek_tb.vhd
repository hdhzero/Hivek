library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

library work;
use work.hivek_pkg.all;

entity hivek_tb is
end hivek_tb;

architecture behavior of hivek_tb is
    -------------
    -- signals --
    -------------

    signal clock : std_logic;
    signal reset : std_logic;

    signal hivek_i : hivek_in_t;
    signal hivek_o : hivek_out_t;

    signal i_wren   : std_logic;
    signal i_addr   : std_logic_vector(31 downto 0);
    signal i_data_i : std_logic_vector(63 downto 0);
    signal i_data_o : std_logic_vector(63 downto 0);

    signal i_data_i_sel : std_logic;
    signal iwren_file   : std_logic;
    signal iaddr_file   : std_logic_vector(31 downto 0);
    signal idata_file   : std_logic_vector(63 downto 0);

    signal sum : std_logic_vector(31 downto 0);

    file arquivo : text open read_mode is "prog.txt";


    ---------------
    -- functions --
    ---------------
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

    ----------------
    -- components --
    ----------------
    component icache_memory is
    generic (
        VENDOR     : string := "GENERIC";
        ADDR_WIDTH : integer := 8
    );
    port (
        clock   : in std_logic;
        wren    : in std_logic;
        address : in std_logic_vector(31 downto 0);
        data_i  : in std_logic_vector(63 downto 0);
        data_o  : out std_logic_vector(63 downto 0)
    );
    end component;

begin

    init_mem : process 
        variable linha : line;
        variable ss    : string(8 downto 1);
        variable data  : std_logic_vector(63 downto 0);
        variable i     : integer := 0;
    begin
        i := 0;

        readline(arquivo, linha);
        read(linha, ss);

        assert ss = "   .text"
            report "fault program. There is no .text header"
            severity ERROR; -- warning failure

        wait until clock'event and clock = '1';
        iwren_file <= '0';
        iaddr_file <= x"0FFFFFF8";
        idata_file <= x"0000000000000000";

        while ss /= "   .data" loop
            i := 7;

            while not endfile(arquivo) and i >= 0 loop
                readline(arquivo, linha);
                read(linha, ss);

                if ss = "   .data" then
                    exit;
                end if;

                data(8 * (i + 1) - 1 downto 8 * i) := str_to_std(ss);
                i := i - 1;
            end loop;

            while i >= 0 loop
                data(8 * (i + 1) - 1 downto 8 * i) := "00000000";
                i := i - 1;
            end loop;

            wait until clock'event and clock = '1';
            iwren_file <= '1';
            iaddr_file <= std_logic_vector(unsigned(iaddr_file) + x"00000008");
            idata_file <= data;

            assert iaddr_file = x"DEADBEAF"
                report integer'image(to_integer(unsigned(iaddr_file)))
                severity warning;
        end loop;

        wait until clock'event and clock = '1';
        idata_file <= data;
        iwren_file <= '0';
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

    i_wren   <= iwren_file;
    i_addr   <= iaddr_file; --when i_data_i_sel = '0' else
    i_data_i <= idata_file; 

    icache_memory_u : icache_memory
    generic map (
        VENDOR => "GENERIC",
        ADDR_WIDTH => 8
    )
    port map (
        clock   => clock,
        wren    => i_wren,
        address => i_addr,
        data_i  => i_data_i,
        data_o  => i_data_o
    );

    --dcache_memory_u : dcache_memory
    --port map (
        --clock => clock,
        --din   => dm_i,
        --dout  => dm_o
    --);

end behavior;

