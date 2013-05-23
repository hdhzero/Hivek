library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity reg_bram is
    generic (
        vendor : string := "GENERIC"
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

architecture behavior of reg_bram is
    type bram is array (31 downto 0) of std_logic_vector(31 downto 0);
    signal ram : bram;

    signal dout_v0 : std_logic_vector(31 downto 0);
    signal dout_v1 : std_logic_vector(31 downto 0);

    signal wraddr_r : std_logic_vector(4 downto 0);
    signal rdaddr_r : std_logic_vector(4 downto 0);

    signal wren_r : std_logic;

    -- if you need to use a vendor bram because you want to or
    -- because the synthesis tool isnt inferring the bram from the
    -- generic code, instantiate the vendor component here
    component reg_bram_altera IS
	PORT
	(
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		rdaddress		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		wraddress		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		wren		: IN STD_LOGIC  := '0';
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
    end component;

begin
    process (wraddr_r, rdaddr_r, dout_v1, dout_v0, wren_r)
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

    generic_bram : if vendor = "GENERIC" generate
        process (clock)
        begin
            if clock'event and clock = '1' then
                if wren = '1' then
                    ram(to_integer(unsigned(wraddr))) <= din;
                end if;

                dout_v0 <= ram(to_integer(unsigned(rdaddr)));
            end if;
        end process;
    end generate;
end behavior;

