library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity hivek_board_tb is
end hivek_board_tb;

architecture behavior of hivek_board_tb is
    component hivek_board is
    port (
        clock_50 : in std_logic;
        sw       : in std_logic_vector(9 downto 0);
        key      : in std_logic_vector(2 downto 0);
        ledg     : out std_logic_vector(9 downto 0);
        vga_hs   : out std_logic;
        vga_vs   : out std_logic;
        vga_r    : out std_logic_vector(3 downto 0);
        vga_g    : out std_logic_vector(3 downto 0);
        vga_b    : out std_logic_vector(3 downto 0) 
    );
    end component;

    signal clock_50 : std_logic;
    signal sw       : std_logic_vector(9 downto 0);
    signal key      : std_logic_vector(2 downto 0);
    signal ledg     : std_logic_vector(9 downto 0);
    signal vga_hs   : std_logic;
    signal vga_vs   : std_logic;
    signal vga_r    : std_logic_vector(3 downto 0);
    signal vga_g    : std_logic_vector(3 downto 0);
    signal vga_b    : std_logic_vector(3 downto 0);

begin
    process
    begin
        clock_50 <= '0';
        wait for 10 ns;
        clock_50 <= '1';
        wait for 10 ns;
    end process;

    process
    begin
        key <= "111";
        sw  <= "0000000000";
        wait until clock_50'event and clock_50 = '1';
        wait until clock_50'event and clock_50 = '1';
        key <= "110";

        wait;
    end process;

    hivek_board_u : hivek_board
    port map (
        clock_50 => clock_50,
        sw     => sw,
        key    => key,
        ledg   => ledg,
        vga_hs => vga_hs,
        vga_vs => vga_vs,
        vga_r  => vga_r,
        vga_g  => vga_g,
        vga_b  => vga_b
    );
end behavior;
