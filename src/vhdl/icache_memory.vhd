library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity icache_memory is
    generic (
    );
    port (
        clock   : in std_logic;
        load    : in std_logic;
        address : in std_logic_vector(31 downto 0);
        data_i  : in std_logic_vector(63 downto 0);
        data_o  : in std_logic_vector(63 downto 0)
    );
end icache_memory;

architecture icache_memory_arch of icache_memory is
    type ram is array (0 to ) of std_logic_vector(15 downto 0);

    signal mem0 : ram;
    signal mem1 : ram;
    signal mem2 : ram;
    signal mem3 : ram;

    signal addr0 : std_logic_vector();
    signal addr1 : std_logic_vector();
    signal addr2 : std_logic_vector();
    signal addr3 : std_logic_vector();

    signal out0 : std_logic_vector(15 downto 0);
    signal out1 : std_logic_vector(15 downto 0);
    signal out2 : std_logic_vector(15 downto 0);
    signal out3 : std_logic_vector(15 downto 0);

    signal address_plus_one : std_logic_vector();
    signal addr_sel : std_logic_vector(1 downto 0);

begin
    address_plus_one <= std_logic_vector(unsigned(address) + ONE());
    addr_sel <= address(2 downto 1);

    process (addr_sel, address, address_plus_one)
    begin
        case addr_sel is
            when "00" =>
                addr0 <= address;
                addr1 <= address;
                addr2 <= address;
                addr3 <= address;
            when "01" =>
                addr0 <= address_plus_one;
                addr1 <= address;
                addr2 <= address;
                addr3 <= address;
            when "10" =>
                addr0 <= address_plus_one;
                addr1 <= address_plus_one;
                addr2 <= address;
                addr3 <= address;
            when "11" =>
                addr0 <= address_plus_one;
                addr1 <= address_plus_one;
                addr2 <= address_plus_one;
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
            out1 <= mem0(to_integer(unsigned(addr1)));
            out2 <= mem0(to_integer(unsigned(addr2)));
            out3 <= mem0(to_integer(unsigned(addr3)));
        end if;
    end process;
end icache_memory_arch;
