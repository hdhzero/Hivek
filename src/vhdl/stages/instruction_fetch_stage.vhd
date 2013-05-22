library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity instruction_fetch_stage is
    port (
        clock       : in std_logic;
        reset       : in std_logic;
        din   : in instruction_fetch_stage_in_t;
        dout  : out instruction_fetch_stage_out_t

    );
end instruction_fetch_stage;

architecture behavior of instruction_fetch_stage is
    --signal pc     : std_logic_vector(31 downto 0);
    --signal new_pc : std_logic_vector(31 downto 0);
    --signal inst64 : std_logic_vector(63 downto 0);

    --signal sequential_inc : std_logic_vector(31 downto 0);

    --signal add2 : std_logic_vector(31 downto 0);
    --signal add4 : std_logic_vector(31 downto 0);
    --signal add8 : std_logic_vector(31 downto 0);

    --signal inst_size    : std_logic_vector(1 downto 0);
    --signal new_inst_size : std_logic_vector(1 downto 0);

begin
    --add2 <= std_logic_vector(unsigned(pc) + x"00000002"); -- 16 bits
    --add4 <= std_logic_vector(unsigned(pc) + x"00000004"); -- 2x16 or 32
    --add8 <= std_logic_vector(unsigned(pc) + x"00000008"); -- 2x32

    --new_pc <= j_value when j_taken = '1' else sequential_inc;

    --new_inst_size <= "11" when j_taken = '1' else inst64(63 downto 62);
    --instruction   <= inst64;

    --process (clock, reset, new_pc)
    --begin
        --if clock'event and clock = '1' then
            --if reset = '1' then
                --pc <= (others => '0');
                --inst_size <= "11";
            --elsif pc_load = '1' then
                --pc <= new_pc;
                --inst_size <= new_inst_size;
            --end if;
        --end if;
    --end process;

    --process (inst_size, add2, add4, add8, pc)
    --begin
        --case inst_size is
            --when "00" =>     -- 16 bits
                --sequential_inc <= add2;
            --when "01" =>      --32 bits 
                --sequential_inc <= add4;
            --when "10" =>      -- 2x16 bits 
                --sequential_inc <= add4;
            --when "11" =>      -- 2x32 bits
                --sequential_inc <= add8;
            --when others =>
                --sequential_inc <= pc;
        --end case;
    --end process;
end behavior;
