library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity instruction_decoder is
    port (
        instruction : in std_logic_vector(31 downto 0);

        -- control signals
        alu_op        : out alu_op_t;
        shift_type    : out shift_type_t;
        shift_amt_src : out std_logic;
        mem_wren      : out std_logic;
        reg_wren      : out std_logic;
        pr_wren       : out std_logic;
        reg_dst       : out std_logic;
        alu_src       : out std_logic;

        -- data signals
        reg_a : out std_logic_vector(4 downto 0);
        reg_b : out std_logic_vector(4 downto 0);
        reg_c : out std_logic_vector(4 downto 0);

        pr_reg  : out std_logic_vector(1 downto 0);
        pr_data : out std_logic;

        immd32 : out std_logic_vector(31 downto 0)
    );
end instruction_decoder;

architecture instruction_decoder of instruction_decoder is
begin
    reg_a   <= instruction(7 downto 3);
    reg_b   <= instruction(12 downto 8);
    reg_c   <= instruction(17 downto 13);
    pr_reg  <= instruction(1 downto 0);
    pr_data <= instruction(2);

    -- sign extension
    process (instruction)
    begin
        if instruction(23) = '1' then
            immd32 <= ONES(19 downto 0) & instruction(23 downto 12);
        else
            immd32 <= ZERO(19 downto 0) & instruction(23 downto 12);
        end if;
    end process;

    process (instruction1)
    begin
        if instruction1(29) ='0' then
            case instruction(28 downto 25) is
                when OP_ADDI =>
                    alu_op        <= ALU_ADD;
                    shift_type    <= SH_SLL;
                    shift_amt_src <= '0';
                    mem_wren      <= '0';
                    reg_wren      <= '1';
                    pr_wren       <= '0';
                    reg_dst       <= '1';
                    alu_src       <= '0';

                when OP_ADCI =>
                    alu_op        <= ALU_ADC;
                    shift_type    <= SH_SLL;
                    shift_amt_src <= '0';
                    mem_wren      <= '0';
                    reg_wren      <= '1';
                    pr_wren       <= '0';
                    reg_dst       <= '1';
                    alu_src       <= '0';

                when OP_ANDI =>
                    alu_op        <= ALU_AND;
                    shift_type    <= SH_SLL;
                    shift_amt_src <= '0';
                    mem_wren      <= '0';
                    reg_wren      <= '1';
                    pr_wren       <= '0';
                    reg_dst       <= '1';
                    alu_src       <= '0';

                when OP_ORI =>
                    alu_op        <= ALU_OR;
                    shift_type    <= SH_SLL;
                    shift_amt_src <= '0';
                    mem_wren      <= '0';
                    reg_wren      <= '1';
                    pr_wren       <= '0';
                    reg_dst       <= '1';
                    alu_src       <= '0';

                when OP_CMPEQI =>
                    alu_op        <= ALU_CMPEQ;
                    shift_type    <= SH_SLL;
                    shift_amt_src <= '0';
                    mem_wren      <= '0';
                    reg_wren      <= '0';
                    pr_wren       <= '1';
                    reg_dst       <= '1';
                    alu_src       <= '0';

                when OP_CMPLTI =>
                    alu_op        <= ALU_CMPLT;
                    shift_type    <= SH_SLL;
                    shift_amt_src <= '0';
                    mem_wren      <= '0';
                    reg_wren      <= '0';
                    pr_wren       <= '1';
                    reg_dst       <= '1';
                    alu_src       <= '0';

                when OP_CMPGTI =>
                    alu_op        <= ALU_CMPGT;
                    shift_type    <= SH_SLL;
                    shift_amt_src <= '0';
                    mem_wren      <= '0';
                    reg_wren      <= '0';
                    pr_wren       <= '1';
                    reg_dst       <= '1';
                    alu_src       <= '0';

                when OP_CMPLTUI =>
                    alu_op        <= ALU_CMPLTU;
                    shift_type    <= SH_SLL;
                    shift_amt_src <= '0';
                    mem_wren      <= '0';
                    reg_wren      <= '0';
                    pr_wren       <= '1';
                    reg_dst       <= '1';
                    alu_src       <= '0';

                when OP_CMPGTUI =>
                    alu_op        <= ALU_CMPGTU;
                    shift_type    <= SH_SLL;
                    shift_amt_src <= '0';
                    mem_wren      <= '0';
                    reg_wren      <= '0';
                    pr_wren       <= '1';
                    reg_dst       <= '1';
                    alu_src       <= '0';

                when OP_LW =>
                    alu_op        <= ALU_ADD;
                    shift_type    <= SH_SLL;
                    shift_amt_src <= '0';
                    mem_wren      <= '0';
                    reg_wren      <= '1';
                    pr_wren       <= '0';
                    reg_dst       <= '1';
                    alu_src       <= '0';

                when OP_LB =>
                    alu_op        <= ALU_ADD;
                    shift_type    <= SH_SLL;
                    shift_amt_src <= '0';
                    mem_wren      <= '0';
                    reg_wren      <= '1';
                    pr_wren       <= '0';
                    reg_dst       <= '1';
                    alu_src       <= '0';

                when OP_SW =>
                    alu_op        <= ALU_ADD;
                    shift_type    <= SH_SLL;
                    shift_amt_src <= '0';
                    mem_wren      <= '1';
                    reg_wren      <= '0';
                    pr_wren       <= '0';
                    reg_dst       <= '1';
                    alu_src       <= '0';

                when OP_SB =>
                    alu_op        <= ALU_ADD;
                    shift_type    <= SH_SLL;
                    shift_amt_src <= '0';
                    mem_wren      <= '1';
                    reg_wren      <= '0';
                    pr_wren       <= '0';
                    reg_dst       <= '1';
                    alu_src       <= '0';

                when others =>
                    alu_op        <= ALU_ADD;
                    shift_type    <= SH_SLL;
                    shift_amt_src <= '0';
                    mem_wren      <= '0';
                    reg_wren      <= '0';
                    pr_wren       <= '0';
                    reg_dst       <= '1';
                    alu_src       <= '0';

            end case;
        elsif instruction() = "110" then
        elsif instruction() = "10" then
        elsif instruction(29 downto 25) = "11100" then
            if instruction() = "00" then
                case instruction is
                    when OP_ADD =>
                        alu_op        <= ALU_ADD;
                        shift_type    <= SH_SLL;
                        shift_amt_src <= '0';
                        mem_wren      <= '0';
                        reg_wren      <= '1';
                        pr_wren       <= '0';
                        reg_dst       <= '0';
                        alu_src       <= '0';

                    when OP_SUB =>
                        alu_op        <= ALU_SUB;
                        shift_type    <= SH_SLL;
                        shift_amt_src <= '0';
                        mem_wren      <= '0';
                        reg_wren      <= '1';
                        pr_wren       <= '0';
                        reg_dst       <= '0';
                        alu_src       <= '0';

                    when OP_ADC =>
                        alu_op        <= ALU_ADC;
                        shift_type    <= SH_SLL;
                        shift_amt_src <= '0';
                        mem_wren      <= '0';
                        reg_wren      <= '1';
                        pr_wren       <= '0';
                        reg_dst       <= '0';
                        alu_src       <= '0';

                    when OP_SBC =>
                        alu_op        <= ALU_SBC;
                        shift_type    <= SH_SLL;
                        shift_amt_src <= '0';
                        mem_wren      <= '0';
                        reg_wren      <= '1';
                        pr_wren       <= '0';
                        reg_dst       <= '0';
                        alu_src       <= '0';

                    when OP_AND =>
                        alu_op        <= ALU_AND;
                        shift_type    <= SH_SLL;
                        shift_amt_src <= '0';
                        mem_wren      <= '0';
                        reg_wren      <= '1';
                        pr_wren       <= '0';
                        reg_dst       <= '0';
                        alu_src       <= '0';

                    when OP_OR =>
                        alu_op        <= ALU_OR ;
                        shift_type    <= SH_SLL;
                        shift_amt_src <= '0';
                        mem_wren      <= '0';
                        reg_wren      <= '1';
                        pr_wren       <= '0';
                        reg_dst       <= '0';
                        alu_src       <= '0';

                    when OP_NOR =>
                        alu_op        <= ALU_NOR;
                        shift_type    <= SH_SLL;
                        shift_amt_src <= '0';
                        mem_wren      <= '0';
                        reg_wren      <= '1';
                        pr_wren       <= '0';
                        reg_dst       <= '0';
                        alu_src       <= '0';

                    when OP_XOR =>
                        alu_op        <= ALU_XOR;
                        shift_type    <= SH_SLL;
                        shift_amt_src <= '0';
                        mem_wren      <= '0';
                        reg_wren      <= '1';
                        pr_wren       <= '0';
                        reg_dst       <= '0';
                        alu_src       <= '0';

                    when OP_SLLV =>
                        alu_op        <= ALU_ADD;
                        shift_type    <= SH_SLL;
                        shift_amt_src <= '1';
                        mem_wren      <= '0';
                        reg_wren      <= '1';
                        pr_wren       <= '0';
                        reg_dst       <= '0';
                        alu_src       <= '1';

                    when OP_SRLV =>
                        alu_op        <= ALU_ADD;
                        shift_type    <= SH_SRL;
                        shift_amt_src <= '1';
                        mem_wren      <= '0';
                        reg_wren      <= '1';
                        pr_wren       <= '0';
                        reg_dst       <= '0';
                        alu_src       <= '1';

                    when OP_SRAV =>
                        alu_op        <= ALU_ADD;
                        shift_type    <= SH_SRA;
                        shift_amt_src <= '1';
                        mem_wren      <= '0';
                        reg_wren      <= '1';
                        pr_wren       <= '0';
                        reg_dst       <= '0';
                        alu_src       <= '1';

                    when OP_CMPEQ =>
                        alu_op        <= ALU_CMPEQ;
                        shift_type    <= SH_SLL;
                        shift_amt_src <= '0';
                        mem_wren      <= '0';
                        reg_wren      <= '0';
                        pr_wren       <= '1';
                        reg_dst       <= '0';
                        alu_src       <= '0';

                    when OP_CMPLT =>
                    when OP_CMPGT =>
                    when OP_CMPLTU =>
                    when OP_CMPGTU =>
                    when OP_ANDP =>
                    when OP_ORP =>
                    when OP_XORP =>
                    when OP_NORP =>
                    when OP_JR =>
                    when OP_JALR =>
                    when others =>

                end case;
            elsif instruction() = "01" then
            elsif instruction() = "10" then
            else then
            end if;
        end if;
    end process;
end instruction_decoder;
