library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity operation_decoder is
    port (
        din  : operation_decoder_in_t;
        dout : operation_decoder_out_t
    );
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
end operation_decoder;

architecture behavior of operation_decoder is
    signal operation_type :operation_type_t;  
    signal operation : operation_t;

    constant TYPE_I   : operation_type_t := "000";
    constant TYPE_II  : operation_type_t := "001";
    constant TYPE_III : operation_type_t := "010";
    constant TYPE_IV  : operation_type_t := "011";
    constant TYPE_V   : operation_type_t := "100";

    constant OP_ADD    : operation_t := "00000";
    constant OP_SUB    : operation_t := "00001";
    constant OP_ADC    : operation_t := "00010";
    constant OP_SBC    : operation_t := "00011";

    constant OP_AND    : operation_t := "00100";
    constant OP_OR     : operation_t := "00101";
    constant OP_NOR    : operation_t := "00110";
    constant OP_XOR    : operation_t := "00111";

    constant OP_SLLV   : operation_t := "01000";
    constant OP_SLRV   : operation_t := "01001";
    constant OP_SRAV   : operation_t := "01010";

    constant OP_CMPEQ  : operation_t := "01011";
    constant OP_CMPLT  : operation_t := "01100";
    constant OP_CMPLTU : operation_t := "01101";
    constant OP_CMPGT  : operation_t := "01110";
    constant OP_CMPGTU : operation_t := "01111";

    constant OP_ANDP   : operation_t := "10000";
    constant OP_ORP    : operation_t := "10001";
    constant OP_XORP   : operation_t := "10010";
    constant OP_NORP   : operation_t := "10011";

    constant OP_JR     : operation_t := "10100";
    constant OP_JALR   : operation_t := "10101";

    constant OP_SHADD  : operation_t := "10110";

    constant OP_ADDI    : operation_t := "00000";
    constant OP_ADCI    : operation_t := "00001";
    constant OP_ANDI    : operation_t := "00010";
    constant OP_ORI     : operation_t := "00011";
    constant OP_CMPEQI  : operation_t := "00100";
    constant OP_CMPLTI  : operation_t := "00101";
    constant OP_CMPLTUI : operation_t := "00110";
    constant OP_CMPGTI  : operation_t := "00111";
    constant OP_CMPGTUI : operation_t := "01000";
    constant OP_LW      : operation_t := "01001";
    constant OP_LB      : operation_t := "01010";
    constant OP_SW      : operation_t := "01011";
    constant OP_SB      : operation_t := "01100";

begin
    reg_a   <= instruction(7 downto 3);
    reg_b   <= instruction(12 downto 8);
    reg_c   <= instruction(17 downto 13);
    pr_reg  <= instruction(1 downto 0);
    pr_data <= instruction(2);

    process (din, operation_type)
    begin
        case TYPE_I =>
            operation <= din.operation(24 downto 20);
        case TYPE_II =>
            operation <= '0' & din.operation(28 downto 25);
        case TYPE_III =>
    end process;

    process (din)
    begin
        if din.operation(29 downto 25) = "11100" then
            operation_type <= TYPE_I;
        elsif din.operation(29) = '0' then
            operation_type <= TYPE_II;
        elsif din.operation(29 downto 27) = "110" then
            operation_type <= TYPE_III;
        elsif din.operation_type(29 downto 28) = "10" then
            operation_type <= TYPE_IV;
        else
            operation_type <= TYPE_V;
        end if;
    end process;

    process (din, operation_type)
        variable 
    begin
        dout.reg_a <= din.operation(7 downto 3);
        dout.reg_b <= din.operation(12 downto 8);
        dout_reg_c <= din.operation(17 downto 13);

        dout.pr_reg  <= din.operation(1 downto 0);
        dout.pr_data <= din.operation(2);

        -- sign extension
        if din.operation(23) = '1' then
            dout.immd32 <= ONES(19 downto 0) & din.operation(23 downto 12);
        else
            dout.immd32 <= ZERO(19 downto 0) & din.operation(23 downto 12);
        end if;

        -- controls
        case operation_type is
            when TYPE_I =>
                case operation is
                    when OP_ADD =>
                        dout.control.alu_op   <= ALU_ADD;
                        dout.control.sh_type  <= SH_SLL;
                        dout.control.reg_wren <= '1';
                        dout.control.mem_wren <= '0';
                        dout.control.pr_wren  <= '0';
                        dout.control.reg_dst_sel  <= '0';
                        dout.control.alu_sh_sel   <= '0';
                        dout.control.reg_immd_sel <= '0';
                        dout.control.alu_sh_mem_sel <= '0';
                        dout.control.sh_amt_src_sel <= '0';
                end case;

            when TYPE_II =>
                case operation is

                end case;
            when TYPE_III =>
            when TYPE_IV =>
            when others =>
        end case;
    end process;

end behavior;
