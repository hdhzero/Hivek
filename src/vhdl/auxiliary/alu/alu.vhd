library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pack.all;

entity alu is
    port (
        din  : alu_in_t;
        dout : alu_out_t;
    );
end alu;

architecture behavior of alu is
    signal add : std_logic_vector(32 downto 0);
    signal sub : std_logic_vector(32 downto 0);
    signal carry : std_logic_vector(32 downto 0);
    signal opb : std_logic_vector(31 downto 0);
begin
    result    <= tmp(31 downto 0);
    carry_out <= tmp(32);
    carry     <= ONE(32 downto 0) when carry_in = '1' else 
                 ZERO(32 downto 0);

    tmp  <= std_logic_vector(unsigned('0' & opa) + unsigned('0' & opb));
    tmpc <= std_logic_vector(unsigned(tmp) + unsigned(carry));

    process (operation, operand_a, operand_b)
    begin
        case operation is
            when ALU_CMPEQ =>
                if operand_a = operand_b then
                    cmp_flag <= '1';
                else
                    cmp_flag <= '0';
                end if;

            when ALU_CMPLT =>
                if signed(operand_a) < signed(operand_b) then
                    cmp_flag <= '1';
                else
                    cmp_flag <= '0';
                end if;

            when ALU_CMPLTU =>
                if unsigned(operand_a) < unsigned(operand_b) then
                    cmp_flag <= '1';
                else
                    cmp_flag <= '0';
                end if;

            when ALU_CMPGT =>
                if signed(operand_a) > signed(operand_b) then
                    cmp_flag <= '1';
                else
                    cmp_flag <= '0';
                end if;

            when ALU_CMPGTU =>
                if unsigned(operand_a) > unsigned(operand_b) then
                    cmp_flag <= '1';
                else
                    cmp_flag <= '0';
                end if;

            when others =>
                cmp_flag <= '0';
        end case;
    end process;

    process (operation, operand_b)
    begin
        case operation is
            when ALU_SUB =>
                opb <= not operand_b;
            when ALU_SBC =>
                opb <= not operand_b;
            when others =>
                opb <= operand_b;
        end case;
    end process;
    
    process (operation)
    begin
        case operation is
            when ALU_ADD =>
                result    <= tmp(31 downto 0);
                carry_out <= tmp(32);
            when ALU_SUB =>
                result    <= tmp(31 downto 0);
                carry_out <= tmp(32);
            when ALU_ADC =>
                result    <= tmpc(31 downto 0);
                carry_out <= tmpc(32);
            when ALU_SBC =>
                result    <= tmpc(31 downto 0);
                carry_out <= tmpc(32);
            when ALU_AND =>
                result    <= operand_a and operand_b;
                carry_out <= '0';
            when ALU_OR =>
                result    <= operand_a or operand_b;
                carry_out <= '0';
            when ALU_NOR =>
                result    <= operand_a nor operand_b;
                carry_out <= '0';
            when ALU_XOR =>
                result    <= operand_a xor operand_b;
                carry_out <= '0';
            when others =>
                result    <= tmp(31 downto 0);
                carry_out <= tmp(32);
        end case;
    end process;
end behavior;
