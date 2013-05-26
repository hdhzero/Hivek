library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity instruction_fetch_stage is
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : in instruction_fetch_stage_in_t;
        dout  : out instruction_fetch_stage_out_t
    );
end instruction_fetch_stage;

architecture behavior of instruction_fetch_stage is
    signal pc     : std_logic_vector(31 downto 0);
    signal new_pc : std_logic_vector(31 downto 0);

    signal sequential_inc : std_logic_vector(31 downto 0);

    signal add2 : std_logic_vector(31 downto 0);
    signal add4 : std_logic_vector(31 downto 0);
    signal add8 : std_logic_vector(31 downto 0);

    signal inst_size     : std_logic_vector(1 downto 0);
    signal inst_size_reg : std_logic_vector(1 downto 0);
    signal inst_sz_sel   : std_logic;
begin
    dout.icache_addr <= pc;
    dout.instruction <= din.instruction;
    dout.inst_size   <= inst_size_reg;

    add2 <= std_logic_vector(unsigned(pc) + x"00000002"); -- 16 bits
    add4 <= std_logic_vector(unsigned(pc) + x"00000004"); -- 2x16 or 32
    add8 <= std_logic_vector(unsigned(pc) + x"00000008"); -- 2x32

    new_pc <= sequential_inc;

    process (clock, reset)
    begin
        if reset = '1' then
            pc <= (others => '0');
            inst_sz_sel <= '1';
        elsif clock'event and clock = '1' then
            if din.pc_wren = '1' then
                pc <= new_pc;
                inst_sz_sel <= '0';
                inst_size_reg <= inst_size;
            end if;
        end if;
    end process;

    inst_size <= "11" when inst_sz_sel = '1' else 
                 din.instruction(63 downto 62);

    process (inst_size, add2, add4, add8, pc)
    begin
        case inst_size is
            when "00" =>     -- 16 bits
                sequential_inc <= add2;
            when "01" =>      --32 bits 
                sequential_inc <= add4;
            when "10" =>      -- 2x16 bits 
                sequential_inc <= add4;
            when "11" =>      -- 2x32 bits
                sequential_inc <= add8;
            when others =>
                sequential_inc <= pc;
        end case;
    end process;
end behavior;
