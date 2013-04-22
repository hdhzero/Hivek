library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity memory_bram is
    generic (
        VENDOR     : string  := "GENERIC";
        DATA_WIDTH : integer := 16;
        ADDR_WIDTH : integer := 8 -- 2 ^ ADDR_WIDTH addresses
    );
    port (
        clock  : in std_logic;
        wren   : in std_logic;
        addr   : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
        data_i : in std_logic_vector(DATA_WIDTH - 1 downto 0);
        data_o : out std_logic_vector(DATA_WIDTH - 1 downto 0)
    );
end memory_bram;

architecture behavior of memory_bram is
    constant NW : integer := 2 ** ADDR_WIDTH; -- number of words
    type bram_t is array (NW downto 0) of std_logic_vector(DATA_WIDTH - 1 downto 0);

    signal bram : bram_t;
begin
    process (clock)
    begin
        if clock'event and clock = '1' then
            if wren = '1' then
                bram(to_integer(unsigned(addr))) <= data_i;
            end if;

            data_o <= bram(to_integer(unsigned(addr)));
        end if;
    end process;
end behavior;
