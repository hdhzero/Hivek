library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity icache_memory is
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
--    signal mem0 : ram;
--    signal mem1 : ram;
--    signal mem2 : ram;
--    signal mem3 : ram;




 signal mem0 : ram := (
        0 => x"0000",
        1 => x"0002",
        2 => x"0006",
        others => x"0000");
    signal mem1 : ram := (
        0 => x"0000",
        1 => x"8003",
        2 => x"0006",
        others => x"0000");
    signal mem2 : ram := (
        0 => x"0001",
        1 => x"4004",
        others => x"0000");
    signal mem3 : ram := (
        0 => x"0001",
        1 => x"0005",
        others => x"0000");
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
    ONE <= (3 => '1', others => '0');
    address_plus_one <= std_logic_vector(unsigned(address) + unsigned(ONE));
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

    process (clock, load, data_i, addr0, addr1, addr2, addr3)
    begin
        if clock'event and clock = '1' then
            if load = '1' then
                mem0(to_integer(unsigned(addr0))) <= data_i(63 downto 48);
                mem1(to_integer(unsigned(addr1))) <= data_i(47 downto 32);
                mem2(to_integer(unsigned(addr2))) <= data_i(31 downto 16);
                mem3(to_integer(unsigned(addr3))) <= data_i(15 downto 0);
            end if;

            out0 <= mem0(to_integer(unsigned(addr0)));
            out1 <= mem1(to_integer(unsigned(addr1)));
            out2 <= mem2(to_integer(unsigned(addr2)));
            out3 <= mem3(to_integer(unsigned(addr3)));
        end if;
    end process;
end icache_memory_arch;
