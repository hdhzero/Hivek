library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pack.all;

entity execution_stage is
    port (
        clock     : in std_logic;
        reset     : in std_logic;
        from_pipe : in SH_EX;
        to_pipe   : out EX_MEM
    );
end execution_stage;

architecture behavior of execution_stage is
    signal op_bv0 : std_logic_vector(31 downto 0);
    signal op_bv1 : std_logic_vector(31 downto 0);

    signal res0 : std_logic_vector(31 downto 0);
    signal res1 : std_logic_vector(31 downto 0);

    signal reg_bv0 : std_logic_vector(31 downto 0);
    signal reg_bv1 : std_logic_vector(31 downto 0);

    signal z, n, c, o     : std_logic;
    signal z0, n0, c0, o0 : std_logic;
    signal z1, n1, c1, o1 : std_logic;
    signal rz, rn, rc, ro : std_logic;

    signal exe0 : std_logic;
    signal exe1 : std_logic;

    signal update_flags : std_logic;
    signal flag_bits    : std_logic_vector(1 downto 0);
begin
    -- write enable back in register bank
    to_pipe.wren_back0 <= from_pipe.wren_back0 and exe0;
    to_pipe.wren_back1 <= from_pipe.wren_back1 and exe1;

    -- write enable in data memory
    to_pipe.mem_load_0 <= from_pipe.mem_load_0 and exe0;
    to_pipe.mem_load_1 <= from_pipe.mem_load_1 and exe1;

    -- destination registers
    to_pipe.wren_addr0 <= from_pipe.wren_addr0;
    to_pipe.wren_addr1 <= from_pipe.wren_addr1;

    -- alu results
    to_pipe.alu_res0 <= res0;
    to_pipe.alu_res1 <= res1;

    to_pipe.dmem_i0 <= from_pipe.reg_bv0;
    to_pipe.dmem_i1 <= from_pipe.reg_bv1;


    reg_bv0 <= from_pipe.reg_bv0;
    reg_bv1 <= from_pipe.reg_bv1;

    op_bv0 <= reg_bv0 when from_pipe.op2_src0 = '0' else
              from_pipe.immd32_0;

    op_bv1 <= reg_bv1 when from_pipe.op2_src1 = '0' else
              from_pipe.immd32_1;
  
    process (clock, reset)
    begin
        if reset = '1' then
            rz <= '0';
            rn <= '0';
            rc <= '0';
            ro <= '0';
        elsif clock'event and clock = '1' then
            if update_flags = '1' then
                rz <= z;
                rn <= n;
                rc <= c;
                ro <= o;
            end if;
        end if;
    end process;

    flag_bits(0) <= exe0 and from_pipe.update_flags0;
    flag_bits(1) <= exe1 and from_pipe.update_flags1;

    process (flag_bits, z0, n0, c0, o0, z1, n1, c1, o1)
    begin
        case flag_bits is
            when "00" =>
                update_flags <= '0';
                z <= z0;
                n <= n0;
                c <= c0;
                o <= o0;

            when "01" =>
                update_flags <= '1';
                z <= z0;
                n <= n0;
                c <= c0;
                o <= o0;

            when "10" =>
                update_flags <= '1';
                z <= z1;
                n <= n1;
                c <= c1;
                o <= o1;

            when "11" =>
                update_flags <= '1';
                z <= z0;
                n <= n0;
                c <= c0;
                o <= o0;

            when others =>
                update_flags <= '0';
                z <= z0;
                n <= n0;
                c <= c0;
                o <= o0;
        end case;
    end process;

    verify_flags_u0 : verify_flags
    port map (
        condition => from_pipe.cond0,
        z => rz,
        n => rn,
        c => rc,
        o => ro,
        execute   => exe0
    );

    verify_flags_u1 : verify_flags
    port map (
        condition => from_pipe.cond1,
        z => rz,
        n => rn,
        c => rc,
        o => ro,
        execute   => exe1
    );

    alu_u0 : alu
    port map (
        alu_op => from_pipe.alu_op_0, 
        cin    => rc,
        op_a   => from_pipe.reg_av0,
        op_b   => op_bv0,
        res    => res0,
        z_flag => z0,
        c_flag => c0,
        n_flag => n0,
        o_flag => o0
    );

    alu_u1 : alu
    port map (
        alu_op => from_pipe.alu_op_1, 
        cin    => rc,
        op_a   => from_pipe.reg_av1,
        op_b   => op_bv1,
        res    => res1,
        z_flag => z1,
        c_flag => c1,
        n_flag => n1,
        o_flag => o1
    );
end behavior;
