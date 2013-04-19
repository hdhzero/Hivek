library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity register_bank is
    generic (
        vendor : string := "ALTERA"
    );
    port (
        clock   : in std_logic;
        reset   : in std_logic;
        load0   : in std_logic;
        load1   : in std_logic;
        reg_a0  : in std_logic_vector(4 downto 0);
        reg_b0  : in std_logic_vector(4 downto 0);
        reg_a1  : in std_logic_vector(4 downto 0);
        reg_b1  : in std_logic_vector(4 downto 0);
        reg_c0  : in std_logic_vector(4 downto 0);
        reg_c1  : in std_logic_vector(4 downto 0);
        din_c0  : in std_logic_vector(31 downto 0);
        din_c1  : in std_logic_vector(31 downto 0);
        dout_a0 : out std_logic_vector(31 downto 0);
        dout_b0 : out std_logic_vector(31 downto 0);
        dout_a1 : out std_logic_vector(31 downto 0);
        dout_b1 : out std_logic_vector(31 downto 0)
    );
end register_bank;

architecture register_bank_arch1 of register_bank is
    signal sel_a0 : std_logic;
    signal sel_b0 : std_logic;
    signal sel_a1 : std_logic;
    signal sel_b1 : std_logic;
begin

    bank_selector_u : bank_selector
    port map (
        clock => clock,
        load0 => load0,
        load1 => load1,
        addrc0 => reg_c0,
        addrc1 => reg_c1,
        addra0 => reg_a0,
        addra1 => reg_a1,
        addrb0 => reg_b0,
        addrb1 => reg_b1,
        sel_a0 => sel_a0,
        sel_a1 => sel_a1,
        sel_b0 => sel_b0,
        sel_b1 => sel_b1        
    );
    
    reg_block_a0 : reg_block
    generic map (
        vendor => vendor
    )
    port map (
        clock  => clock,
        sel    => sel_a0,
        load0  => load0,
        load1  => load1,
        addr0  => reg_c0,
        addr1  => reg_c1,
        rdaddr => reg_a0,
        din0   => din_c0,
        din1   => din_c1,
        dout   => dout_a0
    );

    reg_block_a1 : reg_block
    generic map (
        vendor => vendor
    )
    port map (
        clock  => clock,
        sel    => sel_a1,
        load0  => load0,
        load1  => load1,
        addr0  => reg_c0,
        addr1  => reg_c1,
        rdaddr => reg_a1,
        din0   => din_c0,
        din1   => din_c1,
        dout   => dout_a1
    );

    reg_block_b0 : reg_block
    generic map (
        vendor => vendor
    )
    port map (
        clock  => clock,
        sel    => sel_b0,
        load0  => load0,
        load1  => load1,
        addr0  => reg_c0,
        addr1  => reg_c1,
        rdaddr => reg_b0,
        din0   => din_c0,
        din1   => din_c1,
        dout   => dout_b0
    );

    reg_block_b1 : reg_block
    generic map (
        vendor => vendor
    )
    port map (
        clock  => clock,
        sel    => sel_b1,
        load0  => load0,
        load1  => load1,
        addr0  => reg_c0,
        addr1  => reg_c1,
        rdaddr => reg_b1,
        din0   => din_c0,
        din1   => din_c1,
        dout   => dout_b1
    );

end register_bank_arch1;
