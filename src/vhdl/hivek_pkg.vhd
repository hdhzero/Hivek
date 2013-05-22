library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package hivek_pkg is
    ------------------------
    -- constants definitions
    ------------------------
    constant ZERO : std_logic_vector(63 downto 0) := x"0000000000000000";
    constant ONES : std_logic_vector(63 downto 0) := x"FFFFFFFFFFFFFFFF";
    constant ONE  : std_logic_vector(63 downto 0) := x"0000000000000001";

    ----------------------
    -- type definitions --
    ----------------------
    subtype shift_type_t is std_logic_vector(1 downto 0);

    constant SH_SLL : shift_type_t := "01";
    constant SH_SRL : shift_type_t := "10";
    constant SH_SRA : shift_type_t := "11";

    subtype alu_op_t is std_logic_vector(2 downto 0);

    constant ALU_ADD    : alu_op_t := "000";
    constant ALU_SUB    : alu_op_t := "001";
    constant ALU_ADC    : alu_op_t := "010";
    constant ALU_SBC    : alu_op_t := "011";
    constant ALU_AND    : alu_op_t := "100";
    constant ALU_OR     : alu_op_t := "101";
    constant ALU_NOR    : alu_op_t := "110";
    constant ALU_XOR    : alu_op_t := "111";
    constant ALU_CMPEQ  : alu_op_t := "000";
    constant ALU_CMPLT  : alu_op_t := "001";
    constant ALU_CMPLTU : alu_op_t := "010";
    constant ALU_CMPGT  : alu_op_t := "011";
    constant ALU_CMPGTU : alu_op_t := "100";

    -- opcodes type I
    subtype opcodes_i_t is std_logic_vector(4 downto 0);

    -- arith
    constant OP_ADD : opcodes_i_t := "00000";
    constant OP_SUB : opcodes_i_t := "00001";
    constant OP_ADC : opcodes_i_t := "00010";
    constant OP_SBC : opcodes_i_t := "00011";

    -- logical
    constant OP_AND : opcodes_i_t := "00100";
    constant OP_OR  : opcodes_i_t  := "00101";
    constant OP_NOR : opcodes_i_t := "00110";
    constant OP_XOR : opcodes_i_t := "00111";

    -- shift
    constant OP_SLLV : opcodes_i_t := "01000";
    constant OP_SRLV : opcodes_i_t := "01001";
    constant OP_SRAV : opcodes_i_t := "01010";

    -- comparison
    constant OP_CMPEQ  : opcodes_i_t := "01011";
    constant OP_CMPLT  : opcodes_i_t := "01100";
    constant OP_CMPGT  : opcodes_i_t := "01101";
    constant OP_CMPLTU : opcodes_i_t := "01110";
    constant OP_CMPGTU : opcodes_i_t := "01111";

    -- branch
    constant OP_JR   : opcodes_i_t := "10000";
    constant OP_JALR : opcodes_i_t := "10001";

    -- opcodes type II
    subtype opcodes_ii_t is std_logic_vector(3 downto 0);

    -- arith
    constant OP_ADDI : opcodes_ii_t := "0000";
    constant OP_ADCI : opcodes_ii_t := "0001";

    -- logical
    constant OP_ANDI : opcodes_ii_t := "0010";
    constant OP_ORI  : opcodes_ii_t := "0011";

    -- comparison
    constant OP_CMPEQI  : opcodes_ii_t := "0100";
    constant OP_CMPLTI  : opcodes_ii_t := "0101";
    constant OP_CMPGTI  : opcodes_ii_t := "0110";
    constant OP_CMPLTUI : opcodes_ii_t := "0111";
    constant OP_CMPGTUI : opcodes_ii_t := "1000";

    -- memory
    constant OP_LW : opcodes_ii_t := "1001";
    constant OP_LB : opcodes_ii_t := "1010";
    constant OP_SW : opcodes_ii_t := "1011";
    constant OP_SB : opcodes_ii_t := "1100";


    ---------------------
    -- Pipeline stages --
    ---------------------
    type id_control_out_t is record
        -- predicate
        pr_reg  : std_logic_vector(1 downto 0);
        pr_data : std_logic;
        
        -- operations
        alu_op  : alu_op_t;
        sh_type : shift_type_t;

        -- write enables
        reg_wren : std_logic;
        mem_wren : std_logic;
        pr_wren  : std_logic;

        -- selectors
        reg_dst_sel    : std_logic;
        alu_sh_sel     : std_logic;
        reg_immd_sel   : std_logic;
        alu_sh_mem_sel : std_logic;
        sh_amt_src_sel : std_logic;
    end record;

    type instruction_decode_path_in_t is record
        operation0 : std_logic_vector(31 downto 0);
        operation1 : std_logic_vector(31 downto 0);
    end record;

    type instruction_decode_path_out_t is record
        data_ra : std_logic_vector(31 downto 0);
        data_rb : std_logic_vector(31 downto 0);
        immd32  : std_logic_vector(31 downto 0);
        control : id_control_out_t;
    end record;

    type instruction_decode_stage_in_t is record
        op0 : instruction_decode_path_in_t;
        op1 : instruction_decode_path_in_t;
    end record;

    type instruction_decode_stage_out_t is record
        op0 : instruction_decode_path_out_t;
        op1 : instruction_decode_path_out_t;
    end record;

    component instruction_decode_stage is
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : in instruction_decode_stage_in_t;
        dout  : out instruction_decode_stage_out_t
    );
    end component;
   
    -------------------------
    -- components definitions
    -------------------------

    ----------------------------------------------------------
    -- barrel shifter
    ----------------------------------------------------------
    type barrel_shifter_in_t is record
        left    : std_logic; -- '1' for left, '0' for right
        logical : std_logic; -- '1' for logical, '0' for arithmetic
        shift   : std_logic_vector(4 downto 0);  -- shift count
        input   : std_logic_vector (31 downto 0);
    end record;

    type barrel_shifter_out_t is record
        output : std_logic_vector(31 downto 0);
    end record;

    component barrel_shifter is   -- barrel shifter
    port (
        din  : in barrel_shifter_in_t;
        dout : out barrel_shifter_out_t
    );
    end component;

    ----------------------------------------------------------
    -- alu 
    ----------------------------------------------------------
    type alu_in_t is record
        operation : alu_op_t;
        carry_in  : std_logic;
        operand_a : std_logic_vector(31 downto 0);
        operand_b : std_logic_vector(31 downto 0);
    end record;

    type alu_out_t is record
        result    : std_logic_vector(31 downto 0);
        carry_out : std_logic;
        cmp_flag  : std_logic;
    end record;

    component alu is
    port (
        din  : in alu_in_t;
        dout : out alu_out_t
    );
    end component;

    ----------------------------------------------------------
    -- alu_shifter
    ----------------------------------------------------------
    type alu_shifter_in_t is record
        alu_op       : alu_op_t;
        shift_type   : shift_type_t;
        carry_in     : std_logic;
        operand_a    : std_logic_vector(31 downto 0);
        operand_b    : std_logic_vector(31 downto 0);
        shift_amt    : std_logic_vector(4 downto 0);
    end record;

    type alu_shifter_out_t is record
        alu_result   : std_logic_vector(31 downto 0);
        shift_result : std_logic_vector(31 downto 0);
        carry_out    : std_logic;
        cmp_flag     : std_logic;
    end record;

    component alu_shifter is
    port (
        din  : in alu_shifter_in_t;
        dout : out alu_shifter_out_t
    );
    end component;

    ----------------------------------------------------------
    -- instruction_decoder
    ----------------------------------------------------------
    type instruction_decoder_in_t is record
        a : std_logic;
    end record;

    type instruction_decoder_out_t is record
        immd32  : std_logic_vector(31 downto 0);
        control : id_control_out_t;
    end record;

    component instruction_decoder is
    port (
        din  : in instruction_decoder_in_t;
        dout : out instruction_decoder_out_t
    );
    end component;

    ----------------------------------------------------------
    -- register_bank
    ----------------------------------------------------------
    component bank_selector is
    port (
        clock  : in std_logic;
        load0  : in std_logic;
        load1  : in std_logic;
        addrc0 : in std_logic_vector(4 downto 0);
        addrc1 : in std_logic_vector(4 downto 0);
        addra0 : in std_logic_vector(4 downto 0);
        addra1 : in std_logic_vector(4 downto 0);
        addrb0 : in std_logic_vector(4 downto 0);
        addrb1 : in std_logic_vector(4 downto 0);
        sel_a0 : out std_logic;
        sel_a1 : out std_logic;
        sel_b0 : out std_logic;
        sel_b1 : out std_logic

    );
    end component;

    component reg_bram is
    generic (
        vendor : string := "GENERIC"
    );
    port (
        clock  : in std_logic;
        wren   : in std_logic;
        wraddr : in std_logic_vector(4 downto 0);
        rdaddr : in std_logic_vector(4 downto 0);
        din    : in std_logic_vector(31 downto 0);
        dout   : out std_logic_vector(31 downto 0)
    );
    end component;

    component reg_block is
    generic (
        vendor : string := "GENERIC"
    );
    port (
        clock  : in std_logic;
        sel    : in std_logic;
        load0  : in std_logic;
        load1  : in std_logic;
        addr0  : in std_logic_vector(4 downto 0);
        addr1  : in std_logic_vector(4 downto 0);
        rdaddr : in std_logic_vector(4 downto 0);
        din0   : in std_logic_vector(31 downto 0);
        din1   : in std_logic_vector(31 downto 0);
        dout   : out std_logic_vector(31 downto 0)
    );
    end component;

    type register_bank_path_in_t is record
        wren   : std_logic;
        reg_a  : std_logic_vector(4 downto 0);
        reg_b  : std_logic_vector(4 downto 0);
        reg_c  : std_logic_vector(4 downto 0);
        data_c : std_logic_vector(31 downto 0);
    end record;

    type register_bank_path_out_t is record
        data_a : std_logic_vector(31 downto 0);
        data_b : std_logic_vector(31 downto 0);
    end record;

    type register_bank_in_t is record
        op0 : register_bank_path_in_t;
        op1 : register_bank_path_in_t;
    end record;

    type register_bank_out_t is record
        op0 : register_bank_path_out_t;
        op1 : register_bank_path_out_t;
    end record;

    component register_bank is
    generic (
        vendor : string := "GENERIC"
    );
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : in register_bank_in_t;
        dout  : out register_bank_out_t
    );
    end component;

end package;
