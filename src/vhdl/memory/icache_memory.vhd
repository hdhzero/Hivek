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
    0 => "1111100000000000",
    1 => "1100000000001000",
    2 => "1111100000000100",
    3 => "1111100000110000",
    4 => "1111100000000100",
    5 => "1111100000110000",
    6 => "1100000000000000",
    7 => "1100000000000000",
    8 => "1111100000111000",
    9 => "0111100000000101",
    10 => "1111100110000101",
    11 => "0011100000000000",
    12 => "0111100000101100",
    13 => "1111100001000000",
    14 => "0011100000000001",
    15 => "0111100000000101",
    16 => "1111100000110000",
    17 => "0011100000000000",
    18 => "1100000000000000",
    19 => "1111100100010110",
    20 => "1111100010000110",
    21 => "0111100000000110",
    22 => "1111100010001010",
    23 => "0000000000000000",
    24 => "0001001000000000",
    25 => "1111100000010111",
    26 => "0011100001010011",
    others => "0000000000000000");

signal mem1_ram : mem_bram := (
    0 => "0010000000000100",
    1 => "1100001100000100",
    2 => "1010000100011100",
    3 => "0010000000101100",
    4 => "1010010100000101",
    5 => "0010001100001100",
    6 => "0010011100000101",
    7 => "0010100000000110",
    8 => "0010011000101100",
    9 => "0010010100000001",
    10 => "0010000001001100",
    11 => "0000000000000100",
    12 => "0010001100001100",
    13 => "0010001000001100",
    14 => "0100000001001001",
    15 => "0010011001001101",
    16 => "0100011001010100",
    17 => "0100100000010110",
    18 => "0011111000000100",
    19 => "1000000000001100",
    20 => "1011010100010100",
    21 => "1101011000001100",
    22 => "1110000010111100",
    23 => "0011100100000100",
    24 => "0001100010111100",
    25 => "0001100011001100",
    26 => "1111111100000100",
    others => "0000000000000000");

signal mem2_ram : mem_bram := (
    0 => "0011100000000000",
    1 => "0000000000001000",
    2 => "0011100000000100",
    3 => "0011100000110000",
    4 => "0011100000000100",
    5 => "0011100000110000",
    6 => "0000000111111111",
    7 => "0000000111111111",
    8 => "0011100000000001",
    9 => "0011100000000101",
    10 => "0111100000000000",
    11 => "1110100000000000",
    12 => "0011100000101100",
    13 => "0111000000000000",
    14 => "1111100000111000",
    15 => "0011100000000000",
    16 => "0111100000000001",
    17 => "1111001111111111",
    18 => "0011100000000000",
    19 => "0011100010001110",
    20 => "0011100010010110",
    21 => "0011100000000010",
    22 => "1100000000000011",
    23 => "0111100000000110",
    24 => "0111100000100011",
    25 => "0001011000000000",
    others => "0000000000000000");

signal mem3_ram : mem_bram := (
    0 => "0100000000000100",
    1 => "1100010000000100",
    2 => "1100001000100100",
    3 => "0100000000110100",
    4 => "1100011000000110",
    5 => "0100010000010100",
    6 => "1110011100000001",
    7 => "1110100000000010",
    8 => "0010010100000100",
    9 => "0110010100000100",
    10 => "0000000000000100",
    11 => "0000000000011100",
    12 => "0100010000010100",
    13 => "0000000001110101",
    14 => "0010101101010100",
    15 => "0010011100001101",
    16 => "0010010101001110",
    17 => "1111111100010100",
    18 => "0000000000000100",
    19 => "1010000000010100",
    20 => "1100000010100100",
    21 => "1111010010101100",
    22 => "1111100000000100",
    23 => "1101011011000100",
    24 => "0011011011001100",
    25 => "0001100010111100",
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
