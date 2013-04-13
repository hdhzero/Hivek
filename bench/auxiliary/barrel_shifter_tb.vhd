library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity barrel_shifter_tb is
end barrel_shifter_tb;

architecture behavior of barrel_shifter_tb is
    signal clock   : std_logic;
    signal left    : std_logic; -- '1' for left, '0' for right
    signal logical : std_logic; -- '1' for logical, '0' for arithmetic
    signal shift   : std_logic_vector(4 downto 0);  -- shift count
    signal input   : std_logic_vector (31 downto 0);
    signal output  : std_logic_vector (31 downto 0);
begin
    process
    begin
        clock <= '0';
        wait for 5 ns;
        clock <= '1';
        wait for 5 ns;
    end process;

    process
    begin
        left    <= '1';
        logical <= '1';
        shift   <= "00000";
        input   <= x"00000000";
        wait for 10 ns;

        left    <= '0';
        logical <= '1';
        shift   <= "00000";
        input   <= x"00000000";
        wait for 10 ns;

        left    <= '1';
        logical <= '1';
        shift   <= "00000";
        input   <= x"00000000";
        wait for 10 ns;

        wait;
    end process;

    barrel_shifter_u : barrel_shifter
    port map (
        left    => left,
        logical => logical,
        shift   => shift,
        input   => input,
        output  => output
    );

end behavior;
