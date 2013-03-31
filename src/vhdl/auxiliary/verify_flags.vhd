library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pack.all;

entity verify_flags is
    port (
        condition : cond_flags_t;
        z, n      : std_logic;
        c, o      : std_logic;
        execute   : out std_logic
    );
end verify_flags;

architecture behavior of verify_flags is
begin
    process (condition)
    begin
        case condition is
            when COND_EQ => -- 1
                if z = '1' then
                    execute <= '1';
                else
                    execute <= '0';
                end if;

            when COND_NE => -- 2
                if z = '0' then
                    execute <= '1';
                else
                    execute <= '0';
                end if;

            when COND_CS => -- 3
                if c = '1' then
                    execute <= '1';
                else
                    execute <= '0';
                end if;

            when COND_CC => -- 4
                if c = '0' then
                    execute <= '1';
                else
                    execute <= '0';
                end if;

            when COND_MI => -- 5
                if n = '1' then
                    execute <= '1';
                else
                    execute <= '0';
                end if;

            when COND_PL => -- 6
                if n = '0' then
                    execute <= '1';
                else
                    execute <= '0';
                end if;

            when COND_VS => -- 7
                if o = '1' then
                    execute <= '1';
                else
                    execute <= '0';
                end if;

            when COND_VC => -- 8
                if o = '0' then
                    execute <= '1';
                else
                    execute <= '0';
                end if;

            when COND_HI => -- 9 
                if c = '1' and z = '0' then
                    execute <= '1';
                else
                    execute <= '0';
                end if;

            when COND_LS => -- 10
                if c = '0' or z = '1' then
                    execute <= '1';
                else
                    execute <= '0';
                end if;

            when COND_GE => -- 11
                if n = o then
                    execute <= '1';
                else
                    execute <= '0';
                end if;

            when COND_LT => -- 12
                if n /= o then
                    execute <= '1';
                else
                    execute <= '0';
                end if;

            when COND_GT => -- 13
                if z = '0' and n = o then
                    execute <= '1';
                else
                    execute <= '0';
                end if;

            when COND_LE => -- 14
                if z = '1' or n /= o then
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
