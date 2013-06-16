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
    signal inst_size_reg : std_logic_vector(1 downto 0);
    signal restore_sz_reg_0 : std_logic_vector(1 downto 0);
    signal restore_sz_reg_1 : std_logic_vector(1 downto 0);
begin

    process (clock, reset, din, pc, inst_size_reg, restore_sz_reg_0, restore_sz_reg_1)
        variable restore        : std_logic;
        variable jr_take        : std_logic;
        variable j_take         : std_logic;
        variable new_pc_sel     : std_logic;
        variable add2           : std_logic_vector(31 downto 0);
        variable add4           : std_logic_vector(31 downto 0);
        variable add8           : std_logic_vector(31 downto 0);
        variable inst_size      : std_logic_vector(1 downto 0);
        variable sequential_inc : std_logic_vector(31 downto 0);
        variable new_pc         : std_logic_vector(31 downto 0);
    begin
        add2 := std_logic_vector(unsigned(pc) + x"00000002"); -- 16 bits
        add4 := std_logic_vector(unsigned(pc) + x"00000004"); -- 2x16 or 32
        add8 := std_logic_vector(unsigned(pc) + x"00000008"); -- 2x32

        restore := din.op0.restore or din.op1.restore;
        jr_take := din.op0.jr_take or din.op1.jr_take;
        j_take  := din.op0.j_take or din.op1.j_take;

        new_pc_sel := restore or jr_take or j_take;

        if din.inst_sz_sel = '1' then
            inst_size := "11";
        else
            if din.restore_sz_sel = '0' then
                inst_size := din.instruction(63 downto 62);
            else
                if din.op0.restore = '1' then
                    inst_size := restore_sz_reg_0; --din.op0.restore_sz;
                else
                    inst_size := restore_sz_reg_1;--din.op1.restore_sz;
                end if;
            end if;
        end if;

        case inst_size is
            when "00" =>     -- 16 bits
                sequential_inc := add2;
            when "01" =>      --32 bits 
                sequential_inc := add4;
            when "10" =>      -- 2x16 bits 
                sequential_inc := add4;
            when "11" =>      -- 2x32 bits
                sequential_inc := add8;
            when others =>
                sequential_inc := pc;
        end case;

        if new_pc_sel = '0' then
            new_pc := sequential_inc;
        else
            if restore = '1' then
                if din.op0.restore = '1' then
                    new_pc := din.op0.restore_addr;
                else
                    new_pc := din.op1.restore_addr;
                end if;
            else
                if jr_take = '1' then
                    if din.op0.jr_take = '1' then
                        new_pc := din.op0.jr_addr;
                    else
                        new_pc := din.op1.jr_addr;
                    end if;
                else
                    if din.op0.j_take = '1' then
                        new_pc := din.op0.j_addr;
                    else
                        new_pc := din.op1.j_addr;
                    end if;
                end if;
            end if;
        end if;

        if reset = '1' then
            pc <= (others => '0');
        elsif clock'event and clock = '1' then
            if din.pc_wren = '1' then
                pc     <= new_pc;
                inst_size_reg <= inst_size;
                restore_sz_reg_0 <= din.op0.restore_sz;
                restore_sz_reg_1 <= din.op1.restore_sz;
            end if;
        end if;

        dout.icache_addr <= pc;
        dout.instruction <= din.instruction;
        dout.inst_size   <= inst_size_reg;
        dout.next_pc     <= pc;
        dout.restore_sz  <= inst_size;

    end process;

end behavior;
