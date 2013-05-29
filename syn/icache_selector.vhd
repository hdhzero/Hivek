library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity icache_selector is
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
end icache_selector;

architecture behavior of icache_selector is

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

    signal wren    : std_logic;
    signal address : std_logic_vector(31 downto 0);
    signal data_i  : std_logic_vector(63 downto 0);
    signal data_o  : std_logic_vector(63 downto 0);

begin
    wren <= wren_0 when sel = "00" else
            wren_1 when sel = "01" else
            wren_2 when sel = "10" else
            wren_3;

    address <= addr_0 when sel = "00" else
               addr_1 when sel = "01" else
               addr_2 when sel = "10" else
               addr_3;

    data_i <= din_0 when sel = "00" else
              din_1 when sel = "01" else
              din_2 when sel = "10" else
              din_3;

    dout_0 <= data_o;
    dout_1 <= data_o;
    dout_2 <= data_o;
    dout_3 <= data_o;

    icache_memory_u : icache_memory
    generic map (
        VENDOR => VENDOR,
        ADDR_WIDTH => ADDR_WIDTH
    )
    port map (
        clock   => clock,
        wren    => wren,
        address => address,
        data_i  => data_i,
        data_o  => data_o
    );
end behavior;
