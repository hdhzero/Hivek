library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pack.all;

entity instruction_fetch is
    port (
        clock : in std_logic;
        reset : in std_logic;
    );
end instruction_fetch;

architecture instruction_fetch_arch of instruction_fetch is
    signal pc      : std_logic_vector(31 downto 0);
    signal next_pc : std_logic_vector(31 downto 0);
begin
    process (clock, reset, next_pc)
    begin
        if reset = '1' then
            pc <= (others => '0');
        elsif clock'event and clock = '1' then
            if pc_load = '1' then
                pc <= next_pc;
            end if;
        end if;
    end process;

    process 
    begin
        case inst_size is
            when "00" =>
                pc_inc <= x"00000002";
            when "01" =>
                pc_inc <= x"00000004";
            when "10" =>
                pc_inc <= x"00000006";
            when "11" =>
                pc_inc <= x"00000008";
            when others =>
                pc_inc <= x"00000000";
        end case;
    end process;

    process
    begin
        if branch = '1' then
            if jr_branch = '1' then
                next_pc <= branch_value;
            else
                next_pc <= std_logic_vector(unsigned(pc) + unsigned(branch_value));
            end if;
        else
            next_pc <= std_logic_vector(unsigned(pc) + unsigned(pc_inc));
        end if;
    end process;
end instruction_fetch_arch;
