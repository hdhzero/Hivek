library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity hivek_board is
    port (
        clock_50 : in std_logic;
        sw       : in std_logic_vector(9 downto 0);
        ledg     : out std_logic_vector(9 downto 0)
    );
end hivek_board;

architecture behavior of hivek_board is

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

    signal data_dram_led : std_logic_vector(31 downto 0);


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
    icache_sel <= "00" when SW(9) = '0' else "01";
    dcache_sel <= "00" when SW(8) = '0' else "01";
    LEDG(8 downto 0) <= data_dram_led(8 downto 0);
	 LEDG(9)    <= SW(0);
    clock      <= clock_50;
    reset      <= SW(7);

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

        wren_1  => '0',
        addr_1  => (others => '0'),
        din_1   => (others => '0'),
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

        a_wren_1   => '0',
        a_addr_1   => x"00000000",
        a_data_i_1 => (others => '0'),
        a_data_o_1 => data_dram_led,

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

