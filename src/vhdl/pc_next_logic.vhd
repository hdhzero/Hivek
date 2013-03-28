library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pack.all;

-- this file implements the next pc logic

entity pc_next_logic is
    port (
        inst_size   : in std_logic_vector(1 downto 0);
        pc_value    : in std_logic_vector(31 downto 0);
        jmp_taken   : in std_logic;
        jmp_offset  : in std_logic_vector(31 downto 0);
        new_pc      : out std_logic_vector(31 downto 0)
    );
end pc_next_logic;

architecture pc_next_logic_arch of pc_next_logic is
    signal sequential_inc : unsigned(31 downto 0);
    signal jmp_inc        : unsigned(31 downto 0);

    signal add2 : unsigned(31 downto 0);
    signal add4 : unsigned(31 downto 0);
    signal add6 : unsigned(31 downto 0);
    signal add8 : unsigned(31 downto 0);
begin
    jmp_inc <= unsigned(pc_value) + unsigned(jmp_address);

    add2 <= unsigned(pc_value) + unsigned(x"00000002");
    add4 <= unsigned(pc_value) + unsigned(x"00000004");
    add6 <= unsigned(pc_value) + unsigned(x"00000006");
    add8 <= unsigned(pc_value) + unsigned(x"00000008");

    process (pc_value, jmp_taken, jmp_address)
    begin
        if jmp_taken = '1' then
            new_pc <= std_logic_vector(jmp_inc);
        else
            new_pc <= std_logic_vector(sequential_inc);
        end if;
    end process;

    process (inst_size, add2, add4, add6, add8, pc_value)
    begin
        case inst_size is
            when "00" =>     -- 16 bits
                sequential_inc <= add2;
            when "01" =>      --32 bits or 2x16 bits
                sequential_inc <= add4;
            when "10" =>      -- 32+16 bits
                sequential_inc <= add6;
            when "11" =>      -- 2x32 bits
                sequential_inc <= add8;
            when others =>
                sequential_inc <= pc_value;
        end case;
    end process;

    process
    begin
        case head_bits is
            when "000" =>
                inst_size <= "00";
            when "001" =>
                inst_size <= "00";
            when "010" =>
                inst_size <= "01";
            when "011" =>
                inst_size <= "01";
            when "100" =>
                inst_size <= "01";
            when "101" =>
                inst_size <= "10";
            when "110" =>
                inst_size <= "10";
            when "111" =>
                inst_size <= "11";
            when others =>
                inst_size <= "00";
        end case;
    end process;
end pc_next_logic_arch;
