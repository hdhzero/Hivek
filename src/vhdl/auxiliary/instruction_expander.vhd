library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity instruction_expander is
    port (
        instruction16 : in std_logic_vector(15 downto 0);
        instruction32 : out std_logic_vector(31 downto 0)
    );
end instruction_expander;

architecture behavior of instruction_expander is
    signal p : std_logic;
    signal opcode : std_logic_vector(4 downto 0);
    signal immd9  : std_logic_vector(7 downto 0);
    signal immd12 : std_logic_vector(11 downto 0);
    signal immd22 : std_logic_vector(21 downto 0);
    signal cond   : std_logic_vector(2 downto 0);
begin
    -- spliting the instructions in parts
    p      <= instruction16(12);
    opcode <= instruction16(13 downto 9);
    immd9  <= instruction16(8 downto 0);
    cond   <= instruction16(11 downto 9);

    -- sign extension of the immd from jump
    process (immd9)
    begin
        if immd9(8) = '0' then
            immd22 <= ONES(12 downto 0) & immd9;
        else
            immd22 <= ZERO(12 downto 0) & immd9;
        end if;
    end process;

    process (opcode)
    begin
        if opcode(4) = '1' then
            instruction32 <= "001010" & p & immd22 & cond;
        else
            instruction32 <= (others => '0');
        end if;
    end process;
end behavior;
