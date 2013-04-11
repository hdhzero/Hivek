library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pack.all;

entity reg_bram is
    generic (
        vendor : string := "ALTERA"
    );
    port (
        clock  : in std_logic;
        wren   : in std_logic;
        wraddr : in std_logic_vector(4 downto 0);
        rdaddr : in std_logic_vector(4 downto 0);
        din    : in std_logic_vector(31 downto 0);
        dout   : out std_logic_vector(31 downto 0)
    );
end reg_bram;

architecture reg_bram of reg_bram is
    type bram is array (31 downto 0) of std_logic_vector(31 downto 0);
    signal ram : bram;

    signal dout_v0 : std_logic_vector(31 downto 0);
    signal dout_v1 : std_logic_vector(31 downto 0);

    signal wraddr_r : std_logic_vector(4 downto 0);
    signal rdaddr_r : std_logic_vector(4 downto 0);

    signal wren_r : std_logic;
begin
    process (wraddr_r, rdaddr_r, dout_v1, dout_v0)
    begin
        if wraddr_r = rdaddr_r and wren_r = '1' then
            dout <= dout_v1;
        else
            dout <= dout_v0;
        end if;
    end process;

    process (clock)
    begin
        if clock'event and clock = '1' then
            dout_v1  <= din;
            wraddr_r <= wraddr;
            rdaddr_r <= rdaddr;
            wren_r   <= wren;
        end if;
    end process;

    altera_bram : if vendor = "ALTERA" generate
        reg_bram_u : reg_bram_altera
        port map (
            clock     => clock,
            data      => din,
            rdaddress => rdaddr,
            wraddress => wraddr,
            wren      => wren,
            q         => dout_v0
        );
    end generate;

end reg_bram;

