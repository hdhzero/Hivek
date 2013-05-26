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
    begin
        iexpr_i0.operation <= din.instruction(63 downto 48);
        iexpr_i1.operation <= din.instruction(47 downto 32);

        case din.inst_size is
            when "00" =>
                dout.op0.operation <= iexpr_o0.operation;
                dout.op1.operation <= NOP;
            when "01" =>
                dout.op0.operation <= din.instruction(63 downto 32);
                dout.op0.operation <= NOP;
            when "10" =>
                dout.op0.operation <= iexpr_o0.operation;
                dout.op1.operation <= iexpr_o1.operation;
            when "11" =>
                dout.op0.operation <= din.instruction(63 downto 32);
                dout.op1.operation <= din.instruction(31 downto 0);
            when others =>
                dout.op0.operation <= NOP;
                dout.op1.operation <= NOP;
        end case;
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
