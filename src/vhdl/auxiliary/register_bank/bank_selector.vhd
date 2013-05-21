library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity bank_selector is
    port (
        clock  : in std_logic;
        load0  : in std_logic;
        load1  : in std_logic;
        addrc0 : in std_logic_vector(4 downto 0);
        addrc1 : in std_logic_vector(4 downto 0);
        addra0 : in std_logic_vector(4 downto 0);
        addra1 : in std_logic_vector(4 downto 0);
        addrb0 : in std_logic_vector(4 downto 0);
        addrb1 : in std_logic_vector(4 downto 0);
        sel_a0 : out std_logic;
        sel_a1 : out std_logic;
        sel_b0 : out std_logic;
        sel_b1 : out std_logic

    );
end bank_selector;

architecture bank_selector of bank_selector is
    type selectors_t is array (31 downto 0) of std_logic;
    signal selectors : selectors_t;

    signal addra0_r : std_logic_vector(4 downto 0);
    signal addra1_r : std_logic_vector(4 downto 0);
    signal addrb0_r : std_logic_vector(4 downto 0);
    signal addrb1_r : std_logic_vector(4 downto 0);
begin
    sel_a0 <= selectors(to_integer(unsigned(addra0_r)));
    sel_a1 <= selectors(to_integer(unsigned(addra1_r)));
    sel_b0 <= selectors(to_integer(unsigned(addrb0_r)));
    sel_b1 <= selectors(to_integer(unsigned(addrb1_r)));

    process (clock, load0, load1, addrc0, addrc1)
    begin
        if clock'event and clock = '1' then
            addra0_r <= addra0;
            addra1_r <= addra1;
            addrb0_r <= addrb0;
            addrb1_r <= addrb1;
        
            if load0 = '1' then
                selectors(to_integer(unsigned(addrc0))) <= '0';
            end if;

            if load1 = '1' then
                selectors(to_integer(unsigned(addrc1))) <= '1';
            end if;
        end if;
    end process;

end bank_selector;

