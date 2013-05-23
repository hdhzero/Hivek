library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dcache_memory is
    generic (
        VENDOR     : string  := "GENERIC";
        ADDR_WIDTH : integer := 8 -- 2 ^ ADDR_WIDTH addresses
    );
    port (
        clock    : in std_logic;

        a_wren   : in std_logic;
        a_addr   : in std_logic_vector(31 downto 0);
        a_data_i : in std_logic_vector(31 downto 0);
        a_data_o : out std_logic_vector(31 downto 0);

        b_wren   : in std_logic;
        b_addr   : in std_logic_vector(31 downto 0);
        b_data_i : in std_logic_vector(31 downto 0);
        b_data_o : out std_logic_vector(31 downto 0)
    );
end dcache_memory;

architecture dcache_memory_arch of dcache_memory is
    component dual_memory_bram is
    generic (
        DATA_WIDTH : integer := 32;
        ADDR_WIDTH : integer := 8 -- 2 ^ ADDR_WIDTH addresses
    );
    port (
        a_clock  : in std_logic;
        a_wren   : in std_logic;
        a_addr   : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
        a_data_i : in std_logic_vector(DATA_WIDTH - 1 downto 0);
        a_data_o : out std_logic_vector(DATA_WIDTH - 1 downto 0);

        b_clock  : in std_logic;
        b_wren   : in std_logic;
        b_addr   : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
        b_data_i : in std_logic_vector(DATA_WIDTH - 1 downto 0);
        b_data_o : out std_logic_vector(DATA_WIDTH - 1 downto 0)
    );
    end component;

begin
    generic_ram : if VENDOR = "GENERIC" generate
        dual_memory_bram_u : dual_memory_bram
        generic map (
            DATA_WIDTH => 32,
            ADDR_WIDTH => ADDR_WIDTH
        )
        port map (
            a_clock  => clock,
            a_wren   => a_wren,
            a_addr   => a_addr(ADDR_WIDTH - 1 downto 0),
            a_data_i => a_data_i,
            a_data_o => a_data_o,

            b_clock  => clock,
            b_wren   => b_wren,
            b_addr   => b_addr(ADDR_WIDTH - 1 downto 0),
            b_data_i => b_data_i,
            b_data_o => b_data_o
        );
    end generate;
end dcache_memory_arch;
