library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity barrel_shifter_tb is
end barrel_shifter_tb;

architecture behavior of barrel_shifter_tb is
    signal clock      : std_logic;
    signal bshifter_i : barrel_shifter_in_t;
    signal bshifter_o : barrel_shifter_out_t;
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
        bshifter_i.left    <= '0';
        bshifter_i.logical <= '0';
        bshifter_i.shift   <= "00011";
        bshifter_i.input   <= x"F0000003";
        wait until clock'event and clock = '1';

        bshifter_i.left    <= '0';
        bshifter_i.logical <= '1';
        bshifter_i.shift   <= "00011";
        bshifter_i.input   <= x"F0000003";
        wait until clock'event and clock = '1';

        bshifter_i.left    <= '1';
        bshifter_i.logical <= '0';
        bshifter_i.shift   <= "00011";
        bshifter_i.input   <= x"F0000003";
        wait until clock'event and clock = '1';

        bshifter_i.left    <= '1';
        bshifter_i.logical <= '1';
        bshifter_i.shift   <= "00011";
        bshifter_i.input   <= x"F0000003";
        wait until clock'event and clock = '1';
 
        wait;
    end process;

    barrel_shifter_u : barrel_shifter
    port map (
        din  => bshifter_i,
        dout => bshifter_o
    );

end behavior;
