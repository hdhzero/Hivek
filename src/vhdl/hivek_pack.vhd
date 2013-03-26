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
    type alu_op_t is std_logic_vector(2 downto 0);

    constant ALU_ADD_OP : alu_op_t := "000";
    constant ALU_SUB_OP : alu_op_t := "001";
    constant ALU_ADC_OP : alu_op_t := "010";
    constant ALU_SBC_OP : alu_op_t := "011";
    constant ALU_AND_OP : alu_op_t := "100";
    constant ALU_OR_OP  : alu_op_t := "101";
    constant ALU_NOR_OP : alu_op_t := "110";
    constant ALU_XOR_OP : alu_op_t := "111";

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
        reg_av0  : std_logic_vector(31 downto 0);
        reg_bv0  : std_logic_vector(31 downto 0);
        reg_av1  : std_logic_vector(31 downto 0);
        reg_bv1  : std_logic_vector(31 downto 0);
    end record;

    type SH_EX is record
        alu_op_0 : alu_op_t;
        alu_op_1 : alu_op_t;
        reg_av0  : std_logic_vector(31 downto 0);
        reg_bv0  : std_logic_vector(31 downto 0);
        reg_av1  : std_logic_vector(31 downto 0);
        reg_bv1  : std_logic_vector(31 downto 0);
    end record;

    type EX_MEM is record
        mem_load_0 : std_logic;
        mem_load_1 : std_logic;
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

end package;
