library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity predicate_bank is
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : in predicate_bank_in_t;
        dout  : out predicate_bank_out_t
    );
end predicate_bank;

architecture behavior of predicate_bank is
    type ram_t is array (3 downto 0) of std_logic;
    signal ram : ram_t;
begin
    dout.op0.data_a <= ram(to_integer(unsigned(din.op0.reg_a)));
    dout.op1.data_a <= ram(to_integer(unsigned(din.op1.reg_a)));

    dout.op0.data_b <= ram(to_integer(unsigned(din.op0.reg_b)));
    dout.op1.data_b <= ram(to_integer(unsigned(din.op1.reg_b)));

    dout.op0.data_pr <= ram(to_integer(unsigned(din.op0.reg_pr)));
    dout.op1.data_pr <= ram(to_integer(unsigned(din.op1.reg_pr)));

    process (clock, reset)
    begin
        if reset = '1' then
            ram(0) <= '1';
            ram(1) <= '1';
            ram(2) <= '1';
            ram(3) <= '1';
        elsif clock'event and clock = '1' then
            if din.op0.wren = '1' and din.op0.reg_c /= "00" then
                ram(to_integer(unsigned(din.op0.reg_c))) <= din.op0.data;
            end if;

            if din.op1.wren = '1' and din.op1.reg_c /= "00" then
                ram(to_integer(unsigned(din.op1.reg_c))) <= din.op1.data;
            end if;
        end if;
    end process;
end behavior;
