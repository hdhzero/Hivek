library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pack.all;

entity single_register is
    port (
        clock : in std_logic;
        reset : in std_logic;
        load1 : in std_logic;
        load2 : in std_logic;
        din1  : in std_logic_vector(31 downto 0);
        din2  : in std_logic_vector(31 downto 0);
        dout  : out std_logic_vector(31 downto 0)
    );
end single_register;

architecture single_register_arch of single_register is
    signal reg_r : std_logic_vector(31 downto 0);
    signal reg_i : std_logic_vector(31 downto 0);
    signal load  : std_logic;
begin
    dout  <= reg_r;
    load  <= load1 or load2;
    reg_i <= din1 when load1 = '1' else din2;

    process (clock, reset, load, reg_i)
    begin
        if reset = '1' then
            reg_r <= (others => '0');
        elsif clock'event and clock = '1' then
            if load = '1' then
                reg_r <= reg_i;
            end if;
        end if;
    end process;
end single_register_arch;
