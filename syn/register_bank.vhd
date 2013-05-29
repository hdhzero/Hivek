library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity register_bank is
    generic (
        vendor : string := "GENERIC"
    );
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : in register_bank_in_t;
        dout  : out register_bank_out_t
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
        clock  => clock,
        reset  => reset,
        load0  => din.op0.wren,
        load1  => din.op1.wren,
        addrc0 => din.op0.reg_c,
        addrc1 => din.op1.reg_c,
        addra0 => din.op0.reg_a,
        addra1 => din.op1.reg_a,
        addrb0 => din.op0.reg_b,
        addrb1 => din.op1.reg_b,
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
        load0  => din.op0.wren,
        load1  => din.op1.wren,
        addr0  => din.op0.reg_c,
        addr1  => din.op1.reg_c,
        rdaddr => din.op0.reg_a,
        din0   => din.op0.data_c,
        din1   => din.op1.data_c,
        dout   => dout.op0.data_a
    );

    reg_block_a1 : reg_block
    generic map (
        vendor => vendor
    )
    port map (
        clock  => clock,
        sel    => sel_a1,
        load0  => din.op0.wren,
        load1  => din.op1.wren,
        addr0  => din.op0.reg_c,
        addr1  => din.op1.reg_c,
        rdaddr => din.op1.reg_a,
        din0   => din.op0.data_c,
        din1   => din.op1.data_c,
        dout   => dout.op1.data_a
    );

    reg_block_b0 : reg_block
    generic map (
        vendor => vendor
    )
    port map (
        clock  => clock,
        sel    => sel_b0,
        load0  => din.op0.wren,
        load1  => din.op1.wren,
        addr0  => din.op0.reg_c,
        addr1  => din.op1.reg_c,
        rdaddr => din.op0.reg_b,
        din0   => din.op0.data_c,
        din1   => din.op1.data_c,
        dout   => dout.op0.data_b
    );

    reg_block_b1 : reg_block
    generic map (
        vendor => vendor
    )
    port map (
        clock  => clock,
        sel    => sel_b1,
        load0  => din.op0.wren,
        load1  => din.op1.wren,
        addr0  => din.op0.reg_c,
        addr1  => din.op1.reg_c,
        rdaddr => din.op1.reg_b,
        din0   => din.op0.data_c,
        din1   => din.op1.data_c,
        dout   => dout.op1.data_b
    );

end register_bank_arch1;
