library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pack.all;

entity alu is
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
end alu;

architecture alu_arch of alu is
    signal add01  : std_logic_vector(31 downto 0);
    signal sel01  : std_logic;
    signal pn     : std_logic;
    signal sbits  : std_logic_vector(2 downto 0);

    signal res_s  : std_logic_vector(31 downto 0);
    signal v1, v2 : std_logic_vector(31 downto 0);
    signal v3, v4 : std_logic_vector(31 downto 0);
    signal v5, v6 : std_logic_vector(31 downto 0);
    signal v7, v8 : std_logic_vector(31 downto 0);
    signal t1, t2 : std_logic_vector(31 downto 0);

    signal s1, s2, sum : unsigned(32 downto 0);
begin
    res <= res_s;

    z_flag <= '1' when res_s = ZERO(31 downto 0) else '0';
    n_flag <= res_s(31);
    c_flag <= sum(32);
    o_flag <= '1' when sbits = "001" or sbits = "110" else '0';

    sbits <= s1(31) & s2(31) & sum(31);
    add01 <= ONE(31 downto 0) when sel01 = '1' else ZERO(31 downto 0);
    t1    <= op_a;
    t2    <= op_b when pn = '0' else not op_b;
    
    s1  <= unsigned('0' & t1);
    s2  <= unsigned('0' & t2) + unsigned('0' & add01);
    sum <= s1 + s2;

    process (alu_op, cin)
    begin
        case alu_op is
            when ALU_ADD_OP =>
                sel01 <= '0';
                pn    <= '0';
            when ALU_SUB_OP =>
                sel01 <= '1';
                pn    <= '1';
            when ALU_ADC_OP =>
                sel01 <= cin;
                pn    <= '0';
            when ALU_SBC_OP =>
                sel01 <= cin;
                pn    <= '1';
            when others =>
                sel01 <= '0';
                pn    <= '0';
        end case;
    end process;

    -- arithmetic operations
    v1 <= std_logic_vector(sum(31 downto 0));
    v2 <= std_logic_vector(sum(31 downto 0));
    v3 <= std_logic_vector(sum(31 downto 0));
    v4 <= std_logic_vector(sum(31 downto 0));

    -- logical operations
    v5 <= op_a and op_b;
    v6 <= op_a or  op_b;
    v7 <= op_a nor op_b;
    v8 <= op_a xor op_b;

    process (alu_op, v1, v2, v3, v4, v5, v6, v7, v8)
    begin
        case alu_op is
            -- arith
            when ALU_ADD_OP =>
                res_s <= v1;
            when ALU_SUB_OP =>
                res_s <= v2;
            when ALU_ADC_OP =>
                res_s <= v3;
            when ALU_SBC_OP =>
                res_s <= v4;

            -- logical
            when ALU_AND_OP =>
                res_s <= v5;
            when ALU_OR_OP  =>
                res_s <= v6;
            when ALU_NOR_OP =>
                res_s <= v7;
            when ALU_XOR_OP =>
                res_s <= v8;
            when others =>
                res_s <= ZERO(31 downto 0);
        end case;
    end process;
end alu_arch;
