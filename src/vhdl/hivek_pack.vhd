library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package hivek_pack is
    ------------------------
    -- constants definitions
    ------------------------

    constant ZERO : std_logic_vector(63 downto 0) := x"0000000000000000";
    constant ONES : std_logic_vector(63 downto 0) := x"FFFFFFFFFFFFFFFF";
    constant ONE  : std_logic_vector(63 downto 0) := x"0000000000000001";

    ----------------------
    -- type definitions --
    ----------------------
    subtype alu_op_t is std_logic_vector(2 downto 0);

    constant ALU_ADD_OP : alu_op_t := "000";
    constant ALU_SUB_OP : alu_op_t := "001";
    constant ALU_ADC_OP : alu_op_t := "010";
    constant ALU_SBC_OP : alu_op_t := "011";
    constant ALU_AND_OP : alu_op_t := "100";
    constant ALU_OR_OP  : alu_op_t := "101";
    constant ALU_NOR_OP : alu_op_t := "110";
    constant ALU_XOR_OP : alu_op_t := "111";

    subtype cond_flags_t is std_logic_vector(3 downto 0);

    constant COND_EQ : cond_flags_t := "0000";
    constant COND_NE : cond_flags_t := "0001";
    constant COND_CS : cond_flags_t := "0010";
    constant COND_CC : cond_flags_t := "0011";
    constant COND_MI : cond_flags_t := "0100";
    constant COND_PL : cond_flags_t := "0101";
    constant COND_VS : cond_flags_t := "0110";
    constant COND_VC : cond_flags_t := "0111";
    constant COND_HI : cond_flags_t := "1000";
    constant COND_LS : cond_flags_t := "1001";
    constant COND_GE : cond_flags_t := "1010";
    constant COND_LT : cond_flags_t := "1011";
    constant COND_GT : cond_flags_t := "1100";
    constant COND_LE : cond_flags_t := "1101";
    constant COND_AL : cond_flags_t := "1110";

    -- these types are used in the pipeline register stages
    type IF_IEXP is record
        head1 : std_logic_vector(15 downto 0);
        head2 : std_logic_vector(15 downto 0);
        tail1 : std_logic_vector(15 downto 0);
        tail2 : std_logic_vector(15 downto 0);
    end record;

    type IEXP_ID is record
        instruction_0 : std_logic_vector(31 downto 0);
        instruction_1 : std_logic_vector(31 downto 0);       
    end record;

    type ID_SH is record
        alu_op_0 : alu_op_t;
        alu_op_1 : alu_op_t;
        cond0    : std_logic_vector(3 downto 0);
        cond1    : std_logic_vector(3 downto 0);
        op2_src0 : std_logic;
        op2_src1 : std_logic;
        reg_av0  : std_logic_vector(31 downto 0);
        reg_bv0  : std_logic_vector(31 downto 0);
        reg_av1  : std_logic_vector(31 downto 0);
        reg_bv1  : std_logic_vector(31 downto 0);
        immd32_0 : std_logic_vector(31 downto 0);
        imdd32_1 : std_logic_vector(31 downto 0);
    end record;

    type SH_EX is record
        wren_back0 : std_logic;
        wren_back1 : std_logic;
        mem_load_0 : std_logic;
        mem_load_1 : std_logic;
        wren_addr0 : std_logic_vector(3 downto 0);
        wren_addr1 : std_logic_vector(3 downto 0);

        update_flags0 : std_logic;
        update_flags1 : std_logic;

        alu_op_0 : alu_op_t;
        alu_op_1 : alu_op_t;
        cond0    : std_logic_vector(3 downto 0);
        cond1    : std_logic_vector(3 downto 0);
        op2_src0 : std_logic;
        op2_src1 : std_logic;
        reg_av0  : std_logic_vector(31 downto 0);
        reg_bv0  : std_logic_vector(31 downto 0);
        reg_av1  : std_logic_vector(31 downto 0);
        reg_bv1  : std_logic_vector(31 downto 0);
        immd32_0 : std_logic_vector(31 downto 0);
        immd32_1 : std_logic_vector(31 downto 0);
    end record;

    type EX_MEM is record
        wren_back0 : std_logic;
        wren_back1 : std_logic;
        mem_load_0 : std_logic;
        mem_load_1 : std_logic;
        wren_addr0 : std_logic_vector(3 downto 0);
        wren_addr1 : std_logic_vector(3 downto 0);

        alu_res0   : std_logic_vector(31 downto 0);
        alu_res1   : std_logic_vector(31 downto 0);
        dmem_i0    : std_logic_vector(31 downto 0);
        dmem_i1    : std_logic_vector(31 downto 0);
    end record;

    type MEM_WB is record
        reg_c0 : std_logic_vector(3 downto 0);
        reg_c1 : std_logic_vector(3 downto 0);
        load_0 : std_logic;
        load_1 : std_logic;
    end record;

    -------------------------
    -- components definitions
    -------------------------

    -- used in the register bank
    component load_decoder is
    port (
        address : in std_logic_vector(3 downto 0);
        loads   : out std_logic_vector(15 downto 0)
    );
    end component;

    -- used in the register bank
    component single_register is
    port (
        clock : in std_logic;
        reset : in std_logic;
        load1 : in std_logic;
        load2 : in std_logic;
        din1  : in std_logic_vector(31 downto 0);
        din2  : in std_logic_vector(31 downto 0);
        dout  : out std_logic_vector(31 downto 0)
    );
    end component;

    component reg_bram is
    generic (
        vendor : string := "ALTERA"
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

    -- the register bank
    component register_bank is
    port (
        clock   : in std_logic;
        reset   : in std_logic;
        load1   : in std_logic;
        load2   : in std_logic;
        reg_a1  : in std_logic_vector(3 downto 0);
        reg_b1  : in std_logic_vector(3 downto 0);
        reg_a2  : in std_logic_vector(3 downto 0);
        reg_b2  : in std_logic_vector(3 downto 0);
        reg_c1  : in std_logic_vector(3 downto 0);
        reg_c2  : in std_logic_vector(3 downto 0);
        din_c1  : in std_logic_vector(31 downto 0);
        din_c2  : in std_logic_vector(31 downto 0);
        dout_a1 : out std_logic_vector(31 downto 0);
        dout_b1 : out std_logic_vector(31 downto 0);
        dout_a2 : out std_logic_vector(31 downto 0);
        dout_b2 : out std_logic_vector(31 downto 0)
    );
    end component;

    component icache_memory is
    port (
        clock   : in std_logic;
        load    : in std_logic;
        address : in std_logic_vector(31 downto 0);
        data_i  : in std_logic_vector(63 downto 0);
        data_o  : out std_logic_vector(63 downto 0)
    );
    end component;

    component verify_flags is
    port (
        condition : cond_flags_t;
        z, n      : std_logic;
        c, o      : std_logic;
        execute   : out std_logic
    );
    end component;


    component alu is
    port (
        alu_op : in alu_op_t;
        cin    : in std_logic;
        op_a   : in std_logic_vector(31 downto 0);
        op_b   : in std_logic_vector(31 downto 0);
        res    : out std_logic_vector(31 downto 0);
        z_flag : out std_logic;
        c_flag : out std_logic;
        n_flag : out std_logic;
        o_flag : out std_logic
    );
    end component;

    ---------------------
    -- Pipeline stages --
    ---------------------

    component execution_stage is
    port (
        clock     : in std_logic;
        reset     : in std_logic;
        from_pipe : in SH_EX;
        to_pipe   : out EX_MEM
    );
    end component;

    ------------------------
    -- Vendor componentes --
    ------------------------
    component reg_bram_altera IS
	PORT
	(
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		rdaddress		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		wraddress		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		wren		: IN STD_LOGIC  := '0';
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
    end component;


end package;
