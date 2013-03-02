library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
    port (
        operation     : in std_logic_vector(2 downto 0);
        carry_in      : in std_logic;
        operand_a     : in std_logic_vector(31 downto 0);
        operand_b     : in std_logic_vector(31 downto 0);
        result        : out std_logic_vector(31 downto 0);
        zero_flag     : out std_logic;
        carry_flag    : out std_logic;
        negative_flag : out std_logic;
        overflow_flag : out std_logic
    );
end ula;

architecture ula_arch of ula is
    signal res : std_logic_vector(31 downto 0);
begin
    result        <= res;
    zero_flag     <= '1' when res = ZERO(31 downto 0) else '0';
    negative_flag <= '1' when res(31) = '1' else '0';

    process (operation)
    begin
        case op is
            -- add
            when "000" =>

            -- sub
            when "001" =>

            -- 
            when "010" =>

            --
            when "011" =>

            --
            when "100" =>

            --
            when "101" =>

            --
            when "110" =>

            --
            when "111" =>


            when others =>
        end case;
    end process;
end ula_arc;
