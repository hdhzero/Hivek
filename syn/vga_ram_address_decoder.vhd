library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_ram_address_decoder is
    port (
        pixel_x : in std_logic_vector(9 downto 0);
        pixel_y : in std_logic_vector(9 downto 0);
        bit_pos : out std_logic_vector(31 downto 0);
        address : out std_logic_vector(31 downto 0)
    );
end vga_ram_address_decoder;

architecture behavior of vga_ram_address_decoder is
    type rom_t is array (0 to 31) of std_logic_vector(31 downto 0);

    constant rom : rom_t := (
        0 => "00000000000000000000000000000001",
        1 => "00000000000000000000000000000010",
        2 => "00000000000000000000000000000100",
        3 => "00000000000000000000000000001000",
        4 => "00000000000000000000000000010000",
        5 => "00000000000000000000000000100000",
        6 => "00000000000000000000000001000000",
        7 => "00000000000000000000000010000000",
        8 => "00000000000000000000000100000000",
        9 => "00000000000000000000001000000000",
        10 => "00000000000000000000010000000000",
        11 => "00000000000000000000100000000000",
        12 => "00000000000000000001000000000000",
        13 => "00000000000000000010000000000000",
        14 => "00000000000000000100000000000000",
        15 => "00000000000000001000000000000000",
        16 => "00000000000000010000000000000000",
        17 => "00000000000000100000000000000000",
        18 => "00000000000001000000000000000000",
        19 => "00000000000010000000000000000000",
        20 => "00000000000100000000000000000000",
        21 => "00000000001000000000000000000000",
        22 => "00000000010000000000000000000000",
        23 => "00000000100000000000000000000000",
        24 => "00000001000000000000000000000000",
        25 => "00000010000000000000000000000000",
        26 => "00000100000000000000000000000000",
        27 => "00001000000000000000000000000000",
        28 => "00010000000000000000000000000000",
        29 => "00100000000000000000000000000000",
        30 => "01000000000000000000000000000000",
        31 => "10000000000000000000000000000000"
    );
begin
    process (pixel_x, pixel_y)
        variable x  : std_logic_vector(8 downto 0);
        variable y  : std_logic_vector(8 downto 0);
        variable t  : std_logic_vector(8 downto 0);
        variable t0 : std_logic_vector(11 downto 0);
        variable t1 : std_logic_vector(9 downto 0);
        variable a  : integer;
        variable as : integer;
        variable b  : integer;
        variable b0 : integer;
        variable b1 : integer;
        variable c  : integer;
        variable d  : integer;
        variable k  : integer;
        variable z  : integer;
    begin
        x := pixel_x(9 downto 1);
        y := pixel_y(9 downto 1);
        t := x(8 downto 5) & "00000";

        t0 := y & "000";
        t1 := y & "0";

        a  := to_integer(unsigned(x(8 downto 5)));
        as := to_integer(unsigned(t));
        b0 := to_integer(unsigned(t0));
        b1 := to_integer(unsigned(t1));
        b  := b0 + b1;
        k  := to_integer(unsigned(x));
        z  := 31 - (k - as);

        address <= std_logic_vector(to_unsigned((b + a), 32));

        if unsigned(x) < 320 and unsigned(y) < 240 then
            bit_pos <= rom(z);
        else
            bit_pos <= (others => '0');
        end if;

    end process;
end behavior;
