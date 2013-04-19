library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity reg_block is
    generic (
        vendor : string := "ALTERA"
    );
    port (
        clock  : in std_logic;
        sel    : in std_logic;
        load0  : in std_logic;
        load1  : in std_logic;
        addr0  : in std_logic_vector(4 downto 0);
        addr1  : in std_logic_vector(4 downto 0);
        rdaddr : in std_logic_vector(4 downto 0);
        din0   : in std_logic_vector(31 downto 0);
        din1   : in std_logic_vector(31 downto 0);
        dout   : out std_logic_vector(31 downto 0)
    );
end reg_block;

architecture reg_block of reg_block is
    signal dout0 : std_logic_vector(31 downto 0);
    signal dout1 : std_logic_vector(31 downto 0);

begin
    dout <= dout0 when sel = '0' else dout1;

    reg_bram0 : reg_bram
    port map (
        clock  => clock,
        wren   => load0,
        wraddr => addr0,
        rdaddr => rdaddr,
        din    => din0,
        dout   => dout0
    );

    reg_bram1 : reg_bram
    port map (
        clock  => clock,
        wren   => load1,
        wraddr => addr1,
        rdaddr => rdaddr,
        din    => din1,
        dout   => dout1
    );

end reg_block;
