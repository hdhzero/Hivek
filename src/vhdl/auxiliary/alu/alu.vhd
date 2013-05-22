library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity alu is
    port (
        din  : in alu_in_t;
        dout : out alu_out_t
    );
end alu;

architecture behavior of alu is
    signal tmp   : std_logic_vector(32 downto 0);
    signal tmpc  : std_logic_vector(32 downto 0);
    signal carry : std_logic_vector(32 downto 0);
    signal opa   : std_logic_vector(31 downto 0);
    signal opb   : std_logic_vector(31 downto 0);
    signal nob   : std_logic_vector(31 downto 0);
begin
    opa   <= din.operand_a;
    carry <= ONE(32 downto 0) when din.carry_in = '1' else 
             ZERO(32 downto 0);

    tmp  <= std_logic_vector(unsigned('0' & opa) + unsigned('0' & opb));
    tmpc <= std_logic_vector(unsigned(tmp) + unsigned(carry));

    process (din.operation, din.operand_a, din.operand_b)
    begin
        case din.operation is
            when ALU_CMPEQ =>
                if din.operand_a = din.operand_b then
                    dout.cmp_flag <= '1';
                else
                    dout.cmp_flag <= '0';
                end if;

            when ALU_CMPLT =>
                if signed(din.operand_a) < signed(din.operand_b) then
                    dout.cmp_flag <= '1';
                else
                    dout.cmp_flag <= '0';
                end if;

            when ALU_CMPLTU =>
                if unsigned(din.operand_a) < unsigned(din.operand_b) then
                    dout.cmp_flag <= '1';
                else
                    dout.cmp_flag <= '0';
                end if;

            when ALU_CMPGT =>
                if signed(din.operand_a) > signed(din.operand_b) then
                    dout.cmp_flag <= '1';
                else
                    dout.cmp_flag <= '0';
                end if;

            when ALU_CMPGTU =>
                if unsigned(din.operand_a) > unsigned(din.operand_b) then
                    dout.cmp_flag <= '1';
                else
                    dout.cmp_flag <= '0';
                end if;

            when others =>
                dout.cmp_flag <= '0';
        end case;
    end process;

    nob <= not din.operand_b;

    process (din.operation, din.operand_b, nob)
    begin
        case din.operation is
            when ALU_SUB =>
                opb <= std_logic_vector(unsigned(nob) + x"00000001");
            when ALU_SBC =>
                opb <= not din.operand_b;
            when others =>
                opb <= din.operand_b;
        end case;
    end process;
    
    process (din.operation, tmp, tmpc)
    begin
        case din.operation is
            when ALU_ADD =>
                dout.result    <= tmp(31 downto 0);
                dout.carry_out <= tmp(32);
            when ALU_SUB =>
                dout.result    <= tmp(31 downto 0);
                dout.carry_out <= tmp(32);
            when ALU_ADC =>
                dout.result    <= tmpc(31 downto 0);
                dout.carry_out <= tmpc(32);
            when ALU_SBC =>
                dout.result    <= tmpc(31 downto 0);
                dout.carry_out <= tmpc(32);
            when ALU_AND =>
                dout.result    <= din.operand_a and din.operand_b;
                dout.carry_out <= '0';
            when ALU_OR =>
                dout.result    <= din.operand_a or din.operand_b;
                dout.carry_out <= '0';
            when ALU_NOR =>
                dout.result    <= din.operand_a nor din.operand_b;
                dout.carry_out <= '0';
            when ALU_XOR =>
                dout.result    <= din.operand_a xor din.operand_b;
                dout.carry_out <= '0';
            when others =>
                dout.result    <= tmp(31 downto 0);
                dout.carry_out <= tmp(32);
        end case;
    end process;
end behavior;
