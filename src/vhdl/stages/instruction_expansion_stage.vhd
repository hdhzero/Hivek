library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity instruction_expansion_stage is
    port (
        din  : in instruction_expansion_stage_in_t;
        dout : out instruction_expansion_stage_out_t
    );
end instruction_expansion_stage;

architecture behavior of instruction_expansion_stage is
    signal iexpr_i0 : operation_expander_in_t;
    signal iexpr_o0 : operation_expander_out_t;

    signal iexpr_i1 : operation_expander_in_t;
    signal iexpr_o1 : operation_expander_out_t;

begin
    process (din, iexpr_o0, iexpr_o1)
        variable current_pc : unsigned(31 downto 0);
        variable operation0 : std_logic_vector(31 downto 0);
        variable operation1 : std_logic_vector(31 downto 0);
        variable jc_addr_0  : std_logic_vector(21 downto 0);
        variable jc_addr_1  : std_logic_vector(21 downto 0);
        variable ju_addr_0  : std_logic_vector(26 downto 0);
        variable ju_addr_1  : std_logic_vector(26 downto 0);
        variable addr_0     : unsigned(31 downto 0);
        variable addr_1     : unsigned(31 downto 0);
    begin
        iexpr_i0.operation <= din.instruction(63 downto 48);
        iexpr_i1.operation <= din.instruction(47 downto 32);

        case din.inst_size is
            when "00" =>
                operation0 := iexpr_o0.operation;
                operation1 := NOP;
            when "01" =>
                operation0 := din.instruction(63 downto 32);
                operation1 := NOP;
            when "10" =>
                operation0 := iexpr_o0.operation;
                operation1 := iexpr_o1.operation;
            when "11" =>
                operation0 := din.instruction(63 downto 32);
                operation1 := din.instruction(31 downto 0);
            when others =>
                operation0 := NOP;
                operation1 := NOP;
        end case;
        
        current_pc := unsigned(din.current_pc);

        jc_addr_0 := operation0(24 downto 3);
        jc_addr_1 := operation1(24 downto 3);
        ju_addr_0 := operation0(26 downto 0);
        ju_addr_1 := operation1(26 downto 0);

        dout.op0.operation <= operation0;
        dout.op1.operation <= operation1;

        -- sign extension
        if operation0(29 downto 28) = "10" then
            if ju_addr_0(26) = '1' then
                addr_0 := unsigned(ONES(31 downto 27) & ju_addr_0);
            else
                addr_0 := unsigned(ZERO(31 downto 27) & ju_addr_0);
            end if;
        else
            if jc_addr_0(21) = '1' then
                addr_0 := unsigned(ONES(31 downto 22) & jc_addr_0);
            else
                addr_0 := unsigned(ZERO(31 downto 22) & jc_addr_0);
            end if;
        end if;

        if operation1(29 downto 28) = "10" then
            if ju_addr_1(26) = '1' then
                addr_1 := unsigned(ONES(31 downto 27) & ju_addr_1);
            else
                addr_1 := unsigned(ZERO(31 downto 27) & ju_addr_1);
            end if;
        else
            if jc_addr_1(21) = '1' then
                addr_1 := unsigned(ONES(31 downto 22) & jc_addr_1);
            else
                addr_1 := unsigned(ZERO(31 downto 22) & jc_addr_1);
            end if;
        end if;

        -- j take
        if operation0(29 downto 27) = "110" then
            if operation0(25) = '1' then
                dout.op0.j_take       <= '1';
                dout.op0.restore_sz   <= din.restore_sz;
                dout.op0.restore_addr <= din.next_pc;
            else
                dout.op0.j_take       <= '0';
                dout.op0.restore_sz   <= "11";
                dout.op0.restore_addr <= std_logic_vector(current_pc + addr_0);
            end if;
        elsif operation0(29 downto 28) = "10" then
            dout.op0.j_take       <= '1';
            dout.op0.restore_sz   <= "11";
            dout.op0.restore_addr <= std_logic_vector(current_pc + addr_0);
        else
            dout.op0.j_take       <= '0';
            dout.op0.restore_sz   <= "11";
            dout.op0.restore_addr <= std_logic_vector(current_pc + addr_0);
        end if;

        if operation1(29 downto 27) = "110" then 
            if operation1(25) = '1' then
                dout.op1.j_take       <= '1';
                dout.op1.restore_sz   <= din.restore_sz;
                dout.op1.restore_addr <= din.next_pc;
            else
                dout.op1.j_take       <= '0';
                dout.op1.restore_sz   <= "11";
                dout.op1.restore_addr <= std_logic_vector(current_pc + addr_1);
            end if;
        elsif operation1(29 downto 28) = "10" then
            dout.op1.j_take       <= '1';
            dout.op1.restore_sz   <= "11";
            dout.op1.restore_addr <= std_logic_vector(current_pc + addr_1);
        else
            dout.op1.j_take       <= '0';
            dout.op1.restore_sz   <= "11";
            dout.op1.restore_addr <= std_logic_vector(current_pc + addr_1);
        end if;

        dout.op0.j_addr <= std_logic_vector(current_pc + addr_0);
        dout.op1.j_addr <= std_logic_vector(current_pc + addr_1);
    end process;

    operation_expander_u0 : operation_expander
    port map (
        din  => iexpr_i0,
        dout => iexpr_o0
    );

    operation_expander_u1 : operation_expander
    port map (
        din  => iexpr_i1,
        dout => iexpr_o1
    );

end behavior;
