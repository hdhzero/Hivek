library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

library work;
use work.hivek_pkg.all;

entity hivek_tb is
end hivek_tb;

architecture behavior of hivek_tb is
    -- constants
    constant ADDR_WIDTH : integer := 8;
    constant DUAL_ADDR_WIDTH : integer := 8;
    constant DUAL_DATA_WIDTH : integer := 32;
    constant VENDOR : string := "GENERIC";

    -------------
    -- signals --
    -------------

    signal clock : std_logic;
    signal reset : std_logic;

    signal hivek_i : hivek_in_t;
    signal hivek_o : hivek_out_t;

    signal icache_sel : std_logic_vector(1 downto 0);
    signal dcache_sel : std_logic_vector(1 downto 0);

    signal mem_ready  : std_logic;
    signal iwren_file : std_logic;
    signal iaddr_file : std_logic_vector(31 downto 0);
    signal idata_file : std_logic_vector(63 downto 0);

    signal da_wren_file   : std_logic;
    signal da_addr_file   : std_logic_vector(31 downto 0);
    signal da_data_i_file : std_logic_vector(31 downto 0);

    signal db_wren_file   : std_logic;
    signal db_addr_file   : std_logic_vector(31 downto 0);
    signal db_data_i_file : std_logic_vector(31 downto 0);

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
    component icache_selector is
    generic (
        VENDOR     : string := "GENERIC";
        ADDR_WIDTH : integer := 8
    );
    port (
        clock  : in std_logic;
        sel    : in std_logic_vector(1 downto 0);

        wren_0 : in std_logic;
        addr_0 : in std_logic_vector(31 downto 0);
        din_0  : in std_logic_vector(63 downto 0);
        dout_0 : out std_logic_vector(63 downto 0);

        wren_1 : in std_logic;
        addr_1 : in std_logic_vector(31 downto 0);
        din_1  : in std_logic_vector(63 downto 0);
        dout_1 : out std_logic_vector(63 downto 0);

        wren_2 : in std_logic;
        addr_2 : in std_logic_vector(31 downto 0);
        din_2  : in std_logic_vector(63 downto 0);
        dout_2 : out std_logic_vector(63 downto 0);

        wren_3 : in std_logic;
        addr_3 : in std_logic_vector(31 downto 0);
        din_3  : in std_logic_vector(63 downto 0);
        dout_3 : out std_logic_vector(63 downto 0)
    );
    end component;

    component dcache_selector is
    generic (
        VENDOR     : string  := "GENERIC";
        ADDR_WIDTH : integer := 8 -- 2 ^ ADDR_WIDTH addresses
    );
    port (
        clock    : in std_logic;
        sel      : in std_logic_vector(1 downto 0);

        a_wren_0   : in std_logic;
        a_addr_0   : in std_logic_vector(31 downto 0);
        a_data_i_0 : in std_logic_vector(31 downto 0);
        a_data_o_0 : out std_logic_vector(31 downto 0);

        b_wren_0   : in std_logic;
        b_addr_0   : in std_logic_vector(31 downto 0);
        b_data_i_0 : in std_logic_vector(31 downto 0);
        b_data_o_0 : out std_logic_vector(31 downto 0);

        a_wren_1   : in std_logic;
        a_addr_1   : in std_logic_vector(31 downto 0);
        a_data_i_1 : in std_logic_vector(31 downto 0);
        a_data_o_1 : out std_logic_vector(31 downto 0);

        b_wren_1   : in std_logic;
        b_addr_1   : in std_logic_vector(31 downto 0);
        b_data_i_1 : in std_logic_vector(31 downto 0);
        b_data_o_1 : out std_logic_vector(31 downto 0);

        a_wren_2   : in std_logic;
        a_addr_2   : in std_logic_vector(31 downto 0);
        a_data_i_2 : in std_logic_vector(31 downto 0);
        a_data_o_2 : out std_logic_vector(31 downto 0);

        b_wren_2   : in std_logic;
        b_addr_2   : in std_logic_vector(31 downto 0);
        b_data_i_2 : in std_logic_vector(31 downto 0);
        b_data_o_2 : out std_logic_vector(31 downto 0);

        a_wren_3   : in std_logic;
        a_addr_3   : in std_logic_vector(31 downto 0);
        a_data_i_3 : in std_logic_vector(31 downto 0);
        a_data_o_3 : out std_logic_vector(31 downto 0);

        b_wren_3   : in std_logic;
        b_addr_3   : in std_logic_vector(31 downto 0);
        b_data_i_3 : in std_logic_vector(31 downto 0);
        b_data_o_3 : out std_logic_vector(31 downto 0)
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
        mem_ready  <= '0';
        iwren_file <= '0';
        iaddr_file <= x"0FFFFFF8";
        idata_file <= x"0000000000000000";

        da_wren_file   <= '0';
        da_addr_file   <= x"0FFFFFFC";
        da_data_i_file <= x"00000000";

        db_wren_file   <= '0';
        db_addr_file   <= x"00000000";
        da_data_i_file <= x"00000000";

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

--            assert iaddr_file = x"DEADBEAF"
--                report integer'image(to_integer(unsigned(iaddr_file)))
--                severity warning;
        end loop;

        wait until clock'event and clock = '1';
        idata_file <= data;
        iwren_file <= '0';

        while not endfile(arquivo) loop
            i := 3;

            while not endfile(arquivo) and i >= 0 loop
                readline(arquivo, linha);
                read(linha, ss);

                data(8 * (i + 1) - 1 downto 8 * i) := str_to_std(ss);
                i := i - 1;
            end loop;

            while i >= 0 loop
                data(8 * (i + 1) - 1 downto 8 * i) := "00000000";
                i := i - 1;
            end loop;

            wait until clock'event and clock = '1';
            da_wren_file <= '1';
            da_addr_file <= std_logic_vector(unsigned(da_addr_file) + x"00000004");
            da_data_i_file <= data(31 downto 0);
        end loop;

        wait until clock'event and clock = '1';
        mem_ready <= '1';
        da_wren_file <= '0';
        da_addr_file <= x"00000000";
        da_data_i_file <= x"00000000";

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
        icache_sel <= "01";
        dcache_sel <= "01";
        wait until clock'event and clock = '1';

        reset <= '0';
        wait until mem_ready'event and mem_ready = '1';
        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';

        reset <= '1';
        icache_sel <= "00";
        dcache_sel <= "00";
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

    icache_selector_u : icache_selector
    generic map (
        VENDOR => VENDOR, 
        ADDR_WIDTH => ADDR_WIDTH
    )
    port map (
        clock   => clock,
        sel     => icache_sel,

        wren_0  => '0',
        addr_0  => hivek_o.icache_addr,
        din_0   => (others => '0'),
        dout_0  => hivek_i.icache_data,

        wren_1  => iwren_file,
        addr_1  => iaddr_file,
        din_1   => idata_file,
        dout_1  => open,

        wren_2  => '0',
        addr_2  => (others => '0'),
        din_2   => (others => '0'),
        dout_2  => open,

        wren_3  => '0',
        addr_3  => (others => '0'),
        din_3   => (others => '0'),
        dout_3  => open
    );

    dcache_selector_u : dcache_selector
    generic map (
        VENDOR => VENDOR,
        ADDR_WIDTH => DUAL_ADDR_WIDTH
    )
    port map (
        clock    => clock,
        sel      => dcache_sel,

        a_wren_0   => hivek_o.op0.dcache_wren,
        a_addr_0   => hivek_o.op0.dcache_addr,
        a_data_i_0 => hivek_o.op0.dcache_data,
        a_data_o_0 => hivek_i.op0.dcache_data,

        b_wren_0   => hivek_o.op1.dcache_wren,
        b_addr_0   => hivek_o.op1.dcache_addr,
        b_data_i_0 => hivek_o.op1.dcache_data,
        b_data_o_0 => hivek_i.op1.dcache_data,

        a_wren_1   => da_wren_file,
        a_addr_1   => da_addr_file,
        a_data_i_1 => da_data_i_file,
        a_data_o_1 => open,

        b_wren_1   => '0', 
        b_addr_1   => (others => '0'),
        b_data_i_1 => (others => '0'),
        b_data_o_1 => open,

        a_wren_2   => '0',
        a_addr_2   => (others => '0'),
        a_data_i_2 => (others => '0'),
        a_data_o_2 => open,

        b_wren_2   => '0',
        b_addr_2   => (others => '0'),
        b_data_i_2 => (others => '0'),
        b_data_o_2 => open,

        a_wren_3   => '0',
        a_addr_3   => (others => '0'),
        a_data_i_3 => (others => '0'),
        a_data_o_3 => open,

        b_wren_3   => '0',
        b_addr_3   => (others => '0'),
        b_data_i_3 => (others => '0'),
        b_data_o_3 => open
    ); 

end behavior;

