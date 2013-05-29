library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity icache_memory is
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
end icache_memory;
architecture icache_memory_arch of icache_memory is
    signal addr0 : std_logic_vector(31 downto 0);
    signal addr1 : std_logic_vector(31 downto 0);
    signal addr2 : std_logic_vector(31 downto 0);
    signal addr3 : std_logic_vector(31 downto 0);

    signal out0 : std_logic_vector(15 downto 0);
    signal out1 : std_logic_vector(15 downto 0);
    signal out2 : std_logic_vector(15 downto 0);
    signal out3 : std_logic_vector(15 downto 0);

    signal wren0 : std_logic;
    signal wren1 : std_logic;
    signal wren2 : std_logic;
    signal wren3 : std_logic;

    signal address_plus_one : std_logic_vector(31 downto 0);
    signal addr_sel         : std_logic_vector(1 downto 0);
    signal addr_sel_reg     : std_logic_vector(1 downto 0);
    type mem_bram is array (2 ** ADDR_WIDTH - 1 downto 0) of std_logic_vector(15 downto 0);

signal mem0_ram : mem_bram := (
    0 => "0111100000000000",
    1 => "0100000000001001",
    2 => "0111100000000000",
    3 => "0111100000000000",
    4 => "0111100000000000",
    5 => "0111100000000000",
    6 => "0111100000000000",
    7 => "0111100000000000",
    8 => "0100000000000000",
    others => "0000000000000000");

signal mem1_ram : mem_bram := (
    0 => "0000000000000100",
    1 => "0000000100000100",
    2 => "0000000000000100",
    3 => "0000000000000100",
    4 => "0000000000000100",
    5 => "0000000000000100",
    6 => "0000000000000100",
    7 => "0000000000000100",
    8 => "0011111000000100",
    others => "0000000000000000");

signal mem2_ram : mem_bram := (
    0 => "0011100000000000",
    1 => "0111100000000000",
    2 => "0111100000000000",
    3 => "0111100000000000",
    4 => "0101011000000000",
    5 => "0111100000000000",
    6 => "0101001000000000",
    7 => "0111100000000000",
    8 => "0011001111111111",
    others => "0000000000000000");

signal mem3_ram : mem_bram := (
    0 => "0000000000000100",
    1 => "0000000000000100",
    2 => "0000000000000100",
    3 => "0000000000000100",
    4 => "0000000100000100",
    5 => "0000000000000100",
    6 => "0000001000000100",
    7 => "0000000000000100",
    8 => "1111111111000100",
    others => "0000000000000000");

begin
    address_plus_one <= std_logic_vector(unsigned(address) + x"00000008");
    addr_sel <= address(2 downto 1);
    wren0 <= wren;
    wren1 <= wren;
    wren2 <= wren;
    wren3 <= wren;

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
    process (clock)
    begin
        if clock'event and clock = '1' then
            addr_sel_reg <= addr_sel;
        end if;
    end process;

    process (addr_sel_reg, out0, out1, out2, out3)
    begin
        case addr_sel_reg is
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
    process (clock)
    begin
        if clock'event and clock = '1' then
            out0 <= mem0_ram(to_integer(unsigned(addr0(ADDR_WIDTH - 1 downto 0))));
        end if;
    end process;

    process (clock)
    begin
        if clock'event and clock = '1' then
            out1 <= mem1_ram(to_integer(unsigned(addr1(ADDR_WIDTH - 1 downto 0))));
        end if;
    end process;

    process (clock)
    begin
        if clock'event and clock = '1' then
            out2 <= mem2_ram(to_integer(unsigned(addr2(ADDR_WIDTH - 1 downto 0))));
        end if;
    end process;

    process (clock)
    begin
        if clock'event and clock = '1' then
            out3 <= mem3_ram(to_integer(unsigned(addr3(ADDR_WIDTH - 1 downto 0))));
        end if;
    end process;

end icache_memory_arch;
