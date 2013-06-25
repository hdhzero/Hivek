library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity operation_expander is
    port (
        din  : in operation_expander_in_t;
        dout : out operation_expander_out_t
    );
end operation_expander;

architecture behavior of operation_expander is
begin
    process (din)
        variable predict : std_logic;
        variable itype   : std_logic;
        variable opcode  : std_logic_vector(3 downto 0);
        variable immd9   : std_logic_vector(8 downto 0);
        variable immd5   : std_logic_vector(4 downto 0);
        variable cond    : std_logic_vector(2 downto 0);

        variable reg_a3  : std_logic_vector(4 downto 0);
        variable reg_b3  : std_logic_vector(4 downto 0);
        variable reg_c3  : std_logic_vector(4 downto 0);

        variable reg_a3b : std_logic_vector(4 downto 0);
        variable reg_b3b : std_logic_vector(4 downto 0);
        variable reg_c3b : std_logic_vector(4 downto 0);

        variable reg_a3c : std_logic_vector(4 downto 0);
        variable reg_b3c : std_logic_vector(4 downto 0);

        variable reg_b3i : std_logic_vector(4 downto 0);

        variable immd12  : std_logic_vector(11 downto 0);
        variable immd22  : std_logic_vector(21 downto 0);

        variable op : std_logic_vector(26 downto 0);
    begin
        -- spliting the instructions in parts
        itype   := din.operation(13);
        predict := din.operation(12);
        opcode  := din.operation(12 downto 9);
        immd9   := din.operation(8 downto 0);
        immd5   := din.operation(4 downto 0);
        cond    := din.operation(11 downto 9);

        reg_a3 := "00" & din.operation(2 downto 0);
        reg_b3 := "00" & din.operation(5 downto 3);
        reg_c3 := "00" & din.operation(8 downto 6);

        reg_a3b := std_logic_vector(unsigned("00" & din.operation(2 downto 0)) + "01000");
        reg_b3b := std_logic_vector(unsigned("00" & din.operation(5 downto 3)) + "01000");
        reg_c3b := std_logic_vector(unsigned("00" & din.operation(8 downto 6)) + "01000");

        reg_b3i := '0' & din.operation(8 downto 5);

        reg_a3c := '0' & din.operation(3 downto 0);
        reg_b3c := din.operation(8 downto 4);

        -- sign extension
        if immd5(4) = '0' then
            immd12 := ZERO(11 downto 5) & immd5;
        else
            immd12 := ONES(11 downto 5) & immd5;
        end if;

        if immd9(8) = '0' then
            immd22 := ZERO(21 downto 9) & immd9;
        else
            immd22 := ONES(21 downto 9) & immd9;
        end if;
 
        if itype = '1' then
            dout.operation <= "001100" & predict & immd22 & cond;
        else
            case opcode is
                when OP_ADD_16 =>
                    op := "1110000" & OP_ADD & reg_c3 & reg_b3 & reg_a3;
                when OP_SUB_16 =>
                    op := "1110000" & OP_SUB & reg_c3 & reg_b3 & reg_a3;
                when OP_AND_16 =>
                    op := "1110000" & OP_AND & reg_c3 & reg_b3 & reg_a3;
                when OP_OR_16 =>
                    op := "1110000" & OP_OR & reg_c3 & reg_b3 & reg_a3;
                when OP_CMPEQ_16 =>
                    op := "1110000" & OP_CMPEQ & reg_c3 & reg_b3 & reg_a3;
                when OP_CMPLT_16 =>
                    op := "1110000" & OP_CMPLT & reg_c3 & reg_b3 & reg_a3;
                when OP_CMPGT_16 =>
                    op := "1110000" & OP_CMPGT & reg_c3 & reg_b3 & reg_a3;

                when OP_ADDHI_16 =>
                    op := "1110000" & OP_ADD & reg_c3b & reg_b3b & reg_a3b;
                when OP_SUBHI_16 =>
                    op := "1110000" & OP_SUB & reg_c3b & reg_b3b & reg_a3b;

                when OP_ADDI_16 =>
                    op := OP_ADDI & immd12 & reg_b3i & reg_b3i;

                when OP_MOVI =>
                    op := OP_ADDI & immd12 & reg_b3i & "00000";

                when OP_LW_SP_16 =>
                    op := OP_LW & immd12 & reg_b3i & "11101";
                when OP_SW_SP_16 =>
                    op := OP_SW & immd12 & reg_b3i & "11101";

                when OP_LW_16 =>
                    op := OP_LW & x"000" & reg_b3c & reg_a3c;
                when OP_SW_16 =>
                    op := OP_SW & x"000" & reg_b3c & reg_a3c;
                when OP_MOV_16 =>
                    op := "1110000" & OP_ADD & reg_b3c & "00000" & reg_a3c;
                when others =>
                    op := (others => '0');
            end case;

            dout.operation <= "00" & op & "100";
        end if; 
    end process;
end behavior;
