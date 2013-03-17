library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hiveck_pack.all;

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
    signal res  : std_logic_vector(31 downto 0);
    signal cin  : std_logic_vector(31 downto 0);
    signal cf   : std_logic_vector(1 downto 0);
    signal bits : std_logic_vector(2 downto 0);
begin
    result        <= res;
    zero_flag     <= '1' when res = ZERO(31 downto 0) else '0';
    negative_flag <= res(31);

    cin <= ONE(31 downto 0) when carry_in = '1' else ZERO(31 downto 0);

    op1  <= unsigned(operand_a);
    op2  <= unsigned(operand_b);
    c    <= unsigned(cin);
    one  <= unsigned(ONE(31 downto 0));
    bits <= res(31) & op1(31) & op2(31);

    process (operation)
    begin
        case op is
            -- add
            when "000" =>
                res <= std_logic_vector(op1 + op2);

            -- sub
            when "001" =>
                res <= std_logic_vector(op1 - op2);

            -- adc
            when "010" =>
                res <= std_logic_vector(op1 + op2 + c); 

            -- sbc
            when "011" =>
                res <= std_logic_vector(op1 - op2 + c - one);

            -- and
            when "100" =>
                res <= operand_a and operand_b;

            -- or
            when "101" =>
                res <= operand_a or operand_b;

            -- nor
            when "110" =>
                res <= operand_a nor operand_b;

            -- xor
            when "111" =>
                res <= operand_a xor operand_b;

            when others =>
                res <= ZERO(31 downto 0);
        end case;
    end process;

    process (res, operand_a, operand_b)
    begin
        case bits is 
            when "000" =>
                cf <= "00";
            when "001" =>
                cf <= "11";
            when "010" =>
                cf <= "11";
            when "011" =>
                cf <= "10";
            when "100" =>
                cf <= "01";
            when "101" =>
                cf <= "00";
            when "110" =>
                cf <= "00";
            when "111" =>
                cf <= "11";   
        end case;
    end process;

    -- update carry and overflow flags
    process (cf)
    begin
        carry_flag    <= cf(1);
        overflow_flag <= cf(1) xor cf(0);
    end process;

end ula_arc;
