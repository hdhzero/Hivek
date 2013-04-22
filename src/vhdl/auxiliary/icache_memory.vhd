library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity icache_memory is
    generic (
        VENDOR     : string := "GENERIC";
        ADDR_WIDTH : integer := 8
    );
    port (
        clock   : in std_logic;
        load    : in std_logic;
        address : in std_logic_vector(31 downto 0);
        data_i  : in std_logic_vector(63 downto 0);
        data_o  : out std_logic_vector(63 downto 0)
    );
end icache_memory;

architecture icache_memory_arch of icache_memory is
    type ram is array (0 to 127) of std_logic_vector(15 downto 0);

    -- 2x32 16, 16, 2x16, 32, 2x32, 32, 2x16 j
    -- 16 = 00 - 0, 32 = 01 - 4, 2x16 = 10 - 8, 2x32 = 11 - F

    signal addr0 : std_logic_vector(31 downto 0);
    signal addr1 : std_logic_vector(31 downto 0);
    signal addr2 : std_logic_vector(31 downto 0);
    signal addr3 : std_logic_vector(31 downto 0);

    signal out0 : std_logic_vector(15 downto 0);
    signal out1 : std_logic_vector(15 downto 0);
    signal out2 : std_logic_vector(15 downto 0);
    signal out3 : std_logic_vector(15 downto 0);

    signal address_plus_one : std_logic_vector(31 downto 0);
    signal addr_sel         : std_logic_vector(1 downto 0);
    signal ONE : std_logic_vector(31 downto 0);

begin
    address_plus_one <= std_logic_vector(unsigned(address) + unsigned(ONE(31 downto 0)));
    addr_sel <= address(2 downto 1);

    process (addr_sel, address, address_plus_one)
    begin
        case addr_sel is
            when "00" =>
                addr0 <= "000" & address(31 downto 3);
                addr1 <= "000" & address(31 downto 3);
                addr2 <= "000" & address(31 downto 3);
                addr3 <= "000" & address(31 downto 3);
            when "01" =>
                addr0 <= "000" & address_plus_one(31 downto 3);
                addr1 <= "000" & address(31 downto 3);
                addr2 <= "000" & address(31 downto 3);
                addr3 <= "000" & address(31 downto 3);
            when "10" =>
                addr0 <= "000" & address_plus_one(31 downto 3);
                addr1 <= "000" & address_plus_one(31 downto 3);
                addr2 <= "000" & address(31 downto 3);
                addr3 <= "000" & address(31 downto 3);
            when "11" =>
                addr0 <= "000" & address_plus_one(31 downto 3);
                addr1 <= "000" & address_plus_one(31 downto 3);
                addr2 <= "000" & address_plus_one(31 downto 3);
                addr3 <= "000" & address(31 downto 3);
            when others =>
                addr0 <= address;
                addr1 <= address;
                addr2 <= address;
                addr3 <= address;

        end case;
    end process;

    process (addr_sel, out0, out1, out2, out3)
    begin
        case addr_sel is
            when "00" =>
                data_o <= out0 & out1 & out2 & out3;
            when "01" =>
                data_o <= out1 & out2 & out3 & out0;
            when "10" =>
                data_o <= out2 & out3 & out0 & out1;
            when "11" =>
                data_o <= out3 & out0 & out1 & out2;
            when others =>
                data_o <= out0 & out1 & out2 & out3;

        end case;
    end process;

    mem0 : memory_bram
    generic map (
        VENDOR => VENDOR,
        DATA_WIDTH => 16,
        ADDR_WIDTH => ADDR_WIDTH
    )
    port map (
        clock  => clock,
        wren   => wren,
        addr   => addr0,
        data_i => data_i(63 downto 48),
        data_o => out0
    );

    mem1 : memory_bram
    generic map (
        VENDOR => VENDOR,
        DATA_WIDTH => 16,
        ADDR_WIDTH => ADDR_WIDTH
    )
    port map (
        clock  => clock,
        wren   => wren,
        addr   => addr1,
        data_i => data_i(47 downto 32),
        data_o => out1
    );

    mem2 : memory_bram
    generic map (
        VENDOR => VENDOR,
        DATA_WIDTH => 16,
        ADDR_WIDTH => ADDR_WIDTH
    )
    port map (
        clock  => clock,
        wren   => wren,
        addr   => addr2,
        data_i => data_i(31 downto 16),
        data_o => out2
    );

    mem3 : memory_bram
    generic map (
        VENDOR => VENDOR,
        DATA_WIDTH => 16,
        ADDR_WIDTH => ADDR_WIDTH
    )
    port map (
        clock  => clock,
        wren   => wren,
        addr   => addr3,
        data_i => data_i(15 downto 0),
        data_o => out3
    );

end icache_memory_arch;
