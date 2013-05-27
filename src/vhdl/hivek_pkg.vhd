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

    -- no operation
    constant NOP : std_logic_vector(31 downto 0) := x"00000000";

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

    constant ALU_ANDP   : alu_op_t := "101";
    constant ALU_ORP    : alu_op_t := "110";
    constant ALU_XORP   : alu_op_t := "111";

    subtype operation_type_t is std_logic_vector(2 downto 0);

    constant TYPE_I   : operation_type_t := "000";
    constant TYPE_II  : operation_type_t := "001";
    constant TYPE_III : operation_type_t := "010";
    constant TYPE_IV  : operation_type_t := "011";
    constant TYPE_V   : operation_type_t := "100";

    subtype operation_t is std_logic_vector(4 downto 0);

    -- type I
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

    subtype operation16_t is std_logic_vector(3 downto 0);

    constant OP_ADD_16   : operation16_t := "0000";
    constant OP_SUB_16   : operation16_t := "0001";
    constant OP_AND_16   : operation16_t := "0010";
    constant OP_OR_16    : operation16_t := "0011";
    constant OP_CMPEQ_16 : operation16_t := "0100";
    constant OP_CMPLT_16 : operation16_t := "0101";
    constant OP_CMPGT_16 : operation16_t := "0110";
    constant OP_ADDHI_16 : operation16_t := "0111";
    constant OP_SUBHI_16 : operation16_t := "1000";
    constant OP_ADDI_16  : operation16_t := "1001";
    constant OP_MOVI     : operation16_t := "1010";
    constant OP_LW_SP_16 : operation16_t := "1011";
    constant OP_SW_SP_16 : operation16_t := "1100";
    constant OP_LW_16    : operation16_t := "1101";
    constant OP_SW_16    : operation16_t := "1110";
    constant OP_MOV_16   : operation16_t := "1111";

    ---------------------
    -- Pipeline stages --
    ---------------------
    ----------------------------------------------------------
    -- instruction_fetch
    ----------------------------------------------------------
    type instruction_fetch_stage_path_in_t is record
        restore      : std_logic;
        jr_take      : std_logic;
        j_take       : std_logic;
        restore_addr : std_logic_vector(31 downto 0);
        jr_addr      : std_logic_vector(31 downto 0);
        j_addr       : std_logic_vector(31 downto 0);
    end record;

    type instruction_fetch_stage_in_t is record
        pc_wren     : std_logic;
        instruction : std_logic_vector(63 downto 0);
        op0         : instruction_fetch_stage_path_in_t;
        op1         : instruction_fetch_stage_path_in_t;
    end record;

    type instruction_fetch_stage_out_t is record
        instruction : std_logic_vector(63 downto 0);
        inst_size   : std_logic_vector(1 downto 0);
        icache_addr : std_logic_vector(31 downto 0);
    end record;

    component instruction_fetch_stage is
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : in instruction_fetch_stage_in_t;
        dout  : out instruction_fetch_stage_out_t
    );
    end component;

    ----------------------------------------------------------
    -- instruction_expansion
    ----------------------------------------------------------
    type instruction_expansion_stage_path_in_t is record
        pc : std_logic_vector(31 downto 0);
    end record;

    type instruction_expansion_stage_path_out_t is record
        operation : std_logic_vector(31 downto 0);
        j_take    : std_logic;
        j_addr    : std_logic_vector(31 downto 0);
    end record;

    type instruction_expansion_stage_in_t is record
        inst_size   : std_logic_vector(1 downto 0);
        instruction : std_logic_vector(63 downto 0);
        op0 : instruction_expansion_stage_path_in_t;
        op1 : instruction_expansion_stage_path_in_t;
    end record;

    type instruction_expansion_stage_out_t is record
        op0 : instruction_expansion_stage_path_out_t;
        op1 : instruction_expansion_stage_path_out_t;
    end record;

    component instruction_expansion_stage is
    port (
        din   : in instruction_expansion_stage_in_t;
        dout  : out instruction_expansion_stage_out_t
    );
    end component;

    ----------------------------------------------------------
    -- instruction_decode
    ----------------------------------------------------------
    type id_control_out_t is record
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
        operation : std_logic_vector(31 downto 0);
        reg_wren  : std_logic;
        reg_dst   : std_logic_vector(4 downto 0);
        data_dst  : std_logic_vector(31 downto 0);
    end record;

    type instruction_decode_path_out_t is record
        pr_reg  : std_logic_vector(1 downto 0);
        pr_data : std_logic;
        reg_a   : std_logic_vector(4 downto 0);
        reg_b   : std_logic_vector(4 downto 0);
        reg_c   : std_logic_vector(4 downto 0);
        data_a  : std_logic_vector(31 downto 0);
        data_b  : std_logic_vector(31 downto 0);
        immd32  : std_logic_vector(31 downto 0);
        sh_immd : std_logic_vector(4 downto 0);
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
  
    ----------------------------------------------------------
    -- instruction_decode2
    ----------------------------------------------------------
    type id2_control_out_t is record
        -- operations
        alu_op  : alu_op_t;
        sh_type : shift_type_t;

        -- write enables
        reg_wren : std_logic;
        mem_wren : std_logic;
        pr_wren  : std_logic;

        -- selectors
        alu_sh_sel     : std_logic;
        reg_immd_sel   : std_logic;
        alu_sh_mem_sel : std_logic;
        sh_amt_src_sel : std_logic;
    end record;

    type instruction_decode2_path_in_t is record
        pr_reg  : std_logic_vector(1 downto 0);
        pr_data : std_logic;
        reg_a   : std_logic_vector(4 downto 0);
        reg_b   : std_logic_vector(4 downto 0);
        reg_c   : std_logic_vector(4 downto 0);
        data_a  : std_logic_vector(31 downto 0);
        data_b  : std_logic_vector(31 downto 0);
        immd32  : std_logic_vector(31 downto 0);
        sh_immd : std_logic_vector(4 downto 0);
        control : id_control_out_t;
    end record;

    type instruction_decode2_path_out_t is record
        pr_reg  : std_logic_vector(1 downto 0);
        pr_data : std_logic;
        reg_a   : std_logic_vector(4 downto 0);
        reg_b   : std_logic_vector(4 downto 0);
        reg_dst : std_logic_vector(4 downto 0);
        data_a  : std_logic_vector(31 downto 0);
        data_b  : std_logic_vector(31 downto 0);
        immd32  : std_logic_vector(31 downto 0);
        sh_immd : std_logic_vector(4 downto 0);
        control : id2_control_out_t;
    end record;

    type instruction_decode2_stage_in_t is record
        op0 : instruction_decode2_path_in_t;
        op1 : instruction_decode2_path_in_t;
    end record;

    type instruction_decode2_stage_out_t is record
        op0 : instruction_decode2_path_out_t;
        op1 : instruction_decode2_path_out_t;
    end record;

    component instruction_decode2_stage is
    port (
        din   : in instruction_decode2_stage_in_t;
        dout  : out instruction_decode2_stage_out_t
    );
    end component;

    ----------------------------------------------------------
    -- execution_stage
    ----------------------------------------------------------
    type execution_control_out_t is record
        -- write enables
        reg_wren : std_logic;
        mem_wren : std_logic;

        -- selectors
        alu_sh_sel     : std_logic;
        alu_sh_mem_sel : std_logic;
    end record;

    type execution_stage_path_in_t is record
        pr_reg   : std_logic_vector(1 downto 0);
        pr_data  : std_logic;
        reg_a    : std_logic_vector(4 downto 0);
        reg_b    : std_logic_vector(4 downto 0);
        reg_dst  : std_logic_vector(4 downto 0);
        data_a   : std_logic_vector(31 downto 0);
        data_b   : std_logic_vector(31 downto 0);
        immd32   : std_logic_vector(31 downto 0);
        sh_immd  : std_logic_vector(4 downto 0);
        mem_data : std_logic_vector(31 downto 0);
        control  : id2_control_out_t;
    end record;

    type execution_stage_path_out_t is record
        control     : execution_control_out_t;
        alu_data    : std_logic_vector(31 downto 0);
        sh_data     : std_logic_vector(31 downto 0);
        reg_dst     : std_logic_vector(4 downto 0);
        mem_wren    : std_logic;
        mem_addr    : std_logic_vector(31 downto 0);
        mem_data_wr : std_logic_vector(31 downto 0);
        mem_data_rd : std_logic_vector(31 downto 0);
    end record;

    type execution_stage_in_t is record
        op0 : execution_stage_path_in_t;
        op1 : execution_stage_path_in_t;
    end record;

    type execution_stage_out_t is record
        op0 : execution_stage_path_out_t;
        op1 : execution_stage_path_out_t;
    end record;

    component execution_stage is
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : in execution_stage_in_t;
        dout  : out execution_stage_out_t
    );
    end component;

    ----------------------------------------------------------
    -- execution_stage2
    ----------------------------------------------------------
    type execution2_control_out_t is record
        -- write enables
        reg_wren : std_logic;

        -- selectors
        alu_sh_mem_sel : std_logic;
    end record;

    type execution2_stage_path_in_t is record
        alu_data : std_logic_vector(31 downto 0);
        sh_data  : std_logic_vector(31 downto 0);
        mem_data : std_logic_vector(31 downto 0);
        reg_dst  : std_logic_vector(4 downto 0);
        control  : execution_control_out_t;
    end record;

    type execution2_stage_path_out_t is record
        control     : execution2_control_out_t;
        alu_sh_data : std_logic_vector(31 downto 0);
        reg_dst     : std_logic_vector(4 downto 0);
        mem_data    : std_logic_vector(31 downto 0);
    end record;

    type execution2_stage_in_t is record
        op0 : execution2_stage_path_in_t;
        op1 : execution2_stage_path_in_t;
    end record;

    type execution2_stage_out_t is record
        op0 : execution2_stage_path_out_t;
        op1 : execution2_stage_path_out_t;
    end record;

    component execution2_stage is
    port (
        din   : in execution2_stage_in_t;
        dout  : out execution2_stage_out_t
    );
    end component;

    ----------------------------------------------------------
    -- writeback
    ----------------------------------------------------------
    type writeback_control_out_t is record
        -- write enables
        reg_wren : std_logic;
    end record;

    type writeback_stage_path_in_t is record
        alu_sh_data : std_logic_vector(31 downto 0);
        mem_data    : std_logic_vector(31 downto 0);
        reg_dst     : std_logic_vector(4 downto 0);
        control     : execution2_control_out_t;
    end record;

    type writeback_stage_path_out_t is record
        control  : writeback_control_out_t;
        data_dst : std_logic_vector(31 downto 0);
        reg_dst  : std_logic_vector(4 downto 0);
    end record;

    type writeback_stage_in_t is record
        op0 : writeback_stage_path_in_t;
        op1 : writeback_stage_path_in_t;
    end record;

    type writeback_stage_out_t is record
        op0 : writeback_stage_path_out_t;
        op1 : writeback_stage_path_out_t;
    end record;

    component writeback_stage is 
    port (
        din  : in writeback_stage_in_t;
        dout : out writeback_stage_out_t
    );
    end component;

    --------------
    -- pipeline --
    --------------

    type pipeline_in_t is record
        if_iexp_wren    : std_logic;
        iexp_id_wren    : std_logic;
        id_id2_wren     : std_logic;
        id2_exec_wren   : std_logic;
        exec_exec2_wren : std_logic;
        exec2_wb_wren   : std_logic;

        icache_data   : std_logic_vector(63 downto 0);
        dcache_data_0 : std_logic_vector(31 downto 0);
        dcache_data_1 : std_logic_vector(31 downto 0);

        if_o    : instruction_fetch_stage_out_t;
        iexp_o  : instruction_expansion_stage_out_t;
        id_o    : instruction_decode_stage_out_t;
        id2_o   : instruction_decode2_stage_out_t;
        exec_o  : execution_stage_out_t;
        exec2_o : execution2_stage_out_t;
        wb_o    : writeback_stage_out_t;
    end record;

    type pipeline_out_t is record
        icache_addr   : std_logic_vector(31 downto 0);

        dcache_wren_0 : std_logic;
        dcache_wren_1 : std_logic;

        dcache_addr_0 : std_logic_vector(31 downto 0);
        dcache_addr_1 : std_logic_vector(31 downto 0);

        dcache_data_0 : std_logic_vector(31 downto 0);
        dcache_data_1 : std_logic_vector(31 downto 0);

        if_i    : instruction_fetch_stage_in_t;
        iexp_i  : instruction_expansion_stage_in_t;
        id_i    : instruction_decode_stage_in_t;
        id2_i   : instruction_decode2_stage_in_t;
        exec_i  : execution_stage_in_t;
        exec2_i : execution2_stage_in_t;
        wb_i    : writeback_stage_in_t;
    end record;

    component pipeline is
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : in pipeline_in_t;
        dout  : out pipeline_out_t
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
        pr_data_a : std_logic;
        pr_data_b : std_logic;
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
        sh_type      : shift_type_t;
        carry_in     : std_logic;
        operand_a    : std_logic_vector(31 downto 0);
        operand_b    : std_logic_vector(31 downto 0);
        pr_data_a : std_logic;
        pr_data_b : std_logic;
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
    -- instruction_expander
    ----------------------------------------------------------

    type operation_expander_in_t is record
        operation : std_logic_vector(15 downto 0);
    end record;

    type operation_expander_out_t is record
        operation : std_logic_vector(31 downto 0);
    end record;

    component operation_expander is
    port (
        din  : in operation_expander_in_t;
        dout : out operation_expander_out_t
    );
    end component;

    ----------------------------------------------------------
    -- instruction_decoder
    ----------------------------------------------------------
    type operation_decoder_in_t is record
        operation : std_logic_vector(31 downto 0);
    end record;

    type operation_decoder_out_t is record
        reg_a   : std_logic_vector(4 downto 0);
        reg_b   : std_logic_vector(4 downto 0);
        reg_c   : std_logic_vector(4 downto 0);
        pr_reg  : std_logic_vector(1 downto 0);
        pr_data : std_logic;
        immd32  : std_logic_vector(31 downto 0);
        sh_immd : std_logic_vector(4 downto 0);
        control : id_control_out_t;
    end record;

    component operation_decoder is
    port (
        din  : in operation_decoder_in_t;
        dout : out operation_decoder_out_t
    );
    end component;

    ----------------------------------------------------------
    -- register_bank
    ----------------------------------------------------------
    component bank_selector is
    port (
        clock  : in std_logic;
        reset  : in std_logic;
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

    ----------------------------------------------------------
    -- predicate_bank
    ----------------------------------------------------------
    type predicate_bank_path_in_t is record
        wren   : std_logic;
        data   : std_logic;
        reg_pr : std_logic_vector(1 downto 0);
        reg_a  : std_logic_vector(1 downto 0);
        reg_b  : std_logic_vector(1 downto 0);
        reg_c  : std_logic_vector(1 downto 0);
    end record;

    type predicate_bank_path_out_t is record
        data_pr : std_logic;
        data_a  : std_logic;
        data_b  : std_logic;
    end record;

    type predicate_bank_in_t is record
        op0 : predicate_bank_path_in_t;
        op1 : predicate_bank_path_in_t;
    end record;

    type predicate_bank_out_t is record
        op0 : predicate_bank_path_out_t;
        op1 : predicate_bank_path_out_t;
    end record;

    component predicate_bank is
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : in predicate_bank_in_t;
        dout  : out predicate_bank_out_t
    );
    end component;

    ----------------
    -- hivek_core --
    ----------------
    type hivek_path_in_t is record
        dcache_data : std_logic_vector(31 downto 0);
    end record;

    type hivek_path_out_t is record
        dcache_wren : std_logic;
        dcache_addr : std_logic_vector(31 downto 0);
        dcache_data : std_logic_vector(31 downto 0);
    end record;

    type hivek_in_t is record
        icache_data : std_logic_vector(63 downto 0);
        op0 : hivek_path_in_t;
        op1 : hivek_path_in_t;
    end record;

    type hivek_out_t is record
        icache_addr : std_logic_vector(31 downto 0);
        op0 : hivek_path_out_t;
        op1 : hivek_path_out_t;
    end record;

    component hivek is
    port (
        clock : std_logic;
        reset : std_logic;
        din   : in hivek_in_t;
        dout  : out hivek_out_t
    );
    end component;
end package;
