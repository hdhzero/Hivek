library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pack.all;

entity verify_flags is
    port (
        condition : in cond_flags_t;
        zero      : in std_logic;
        negative  : in std_logic;
        carry     : in std_logic;
        overflow  : in std_logic;
        execute   : out std_logic
    );
end verify_flags;

architecture behavior of verify_flags is
begin
    process (condition, zero, negative, carry, overflow)
    begin
        case condition is
            when COND_EQ => -- 1
                if zero = '1' then
                    execute <= '1';
                else
                    execute <= '0';
                end if;

            when COND_NE => -- 2
                if zero = '0' then
                    execute <= '1';
                else
                    execute <= '0';
                end if;

            when COND_CS => -- 3
                if carry = '1' then
                    execute <= '1';
                else
                    execute <= '0';
                end if;

            when COND_CC => -- 4
                if carry = '0' then
                    execute <= '1';
                else
                    execute <= '0';
                end if;

            when COND_MI => -- 5
                if negative = '1' then
                    execute <= '1';
                else
                    execute <= '0';
                end if;

            when COND_PL => -- 6
                if negative = '0' then
                    execute <= '1';
                else
                    execute <= '0';
                end if;

            when COND_VS => -- 7
                if overflow = '1' then
                    execute <= '1';
                else
                    execute <= '0';
                end if;

            when COND_VC => -- 8
                if overflow = '0' then
                    execute <= '1';
                else
                    execute <= '0';
                end if;

            when COND_HI => -- 9 
                if carry = '1' and zero = '0' then
                    execute <= '1';
                else
                    execute <= '0';
                end if;

            when COND_LS => -- 10
                if carry = '0' or zero = '1' then
                    execute <= '1';
                else
                    execute <= '0';
                end if;

            when COND_GE => -- 11
                if negative = overflow then
                    execute <= '1';
                else
                    execute <= '0';
                end if;

            when COND_LT => -- 12
                if negative /= overflow then
                    execute <= '1';
                else
                    execute <= '0';
                end if;

            when COND_GT => -- 13
                if zero = '0' and negative = overflow then
                    execute <= '1';
                else
                    execute <= '0';
                end if;

            when COND_LE => -- 14
                if zero = '1' or negative /= overflow then
                    execute <= '1';
                else
                    execute <= '0';
                end if;

            when COND_AL => -- 15
                execute <= '1';

            when others => -- 16
                execute <= '0';
        end case;
    end process;
end behavior;
