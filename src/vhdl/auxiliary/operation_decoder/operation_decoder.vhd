library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity operation_decoder is
    port (
        din  : in operation_decoder_in_t;
        dout : out operation_decoder_out_t
    );
end operation_decoder;

architecture behavior of operation_decoder is
    signal op_type : operation_type_t;  
    signal op : operation_t;
begin

    process (din, op_type)
    begin
        case op_type is
            when TYPE_I =>
                if din.operation(24 downto 23) /= "00" then
                    op <= OP_SHADD;
                else
                    op <= din.operation(22 downto 18);
                end if;
            when TYPE_II =>
                op <= '0' & din.operation(28 downto 25);
            when others =>
                op <= (others => '0');
        end case;
    end process;

    process (din)
    begin
        if din.operation(29 downto 25) = "11100" then
            op_type <= TYPE_I;
        elsif din.operation(29) = '0' then
            op_type <= TYPE_II;
        elsif din.operation(29 downto 27) = "110" then
            op_type <= TYPE_III;
        elsif din.operation(29 downto 28) = "10" then
            op_type <= TYPE_IV;
        else
            op_type <= TYPE_V;
        end if;
    end process;

    process (din, op_type, op)
    begin
        if op_type = TYPE_IV then
            dout.reg_a <= "00000";
            dout.reg_b <= "11111";
            dout.reg_c <= "00000";
        else
            dout.reg_a <= din.operation(7 downto 3);
            dout.reg_b <= din.operation(12 downto 8);
            dout.reg_c <= din.operation(17 downto 13);
        end if;

        if op_type = TYPE_IV then
            dout.pr_reg  <= "00";
            dout.pr_data <= '1';
        else
            dout.pr_reg  <= din.operation(1 downto 0);
            dout.pr_data <= din.operation(2);
        end if;

        dout.sh_immd <= din.operation(22 downto 18);

        -- sign extension
        if din.operation(24) = '1' then
            dout.immd32 <= ONES(19 downto 0) & din.operation(24 downto 13);
        else
            dout.immd32 <= ZERO(19 downto 0) & din.operation(24 downto 13);
        end if;

        --------------
        -- controls --
        --------------

        -- immd_pc_sel
        if op_type = TYPE_I and (op = OP_JR or op = OP_JALR) then
            dout.control.immd_pc_sel <= '1';
        else
            dout.control.immd_pc_sel <= '0';
        end if;

        -- reg_wren
        case op_type is
            when TYPE_I =>
                case op is
                    when OP_CMPEQ | OP_CMPLT | OP_CMPLTU =>
                        dout.control.reg_wren <= '0';
                    when OP_CMPGT | OP_CMPGTU =>
                        dout.control.reg_wren <= '0';
                    when OP_ANDP | OP_ORP | OP_XORP | OP_NORP =>
                        dout.control.reg_wren <= '0';
                    when OP_JR =>
                        dout.control.reg_wren <= '0';
                    when others =>
                        dout.control.reg_wren <= '1';
                end case;

            when TYPE_II =>
                case op is
                    when OP_CMPEQI | OP_CMPLTI | OP_CMPLTUI =>
                        dout.control.reg_wren <= '0';
                    when OP_CMPGTU | OP_CMPGTUI =>
                        dout.control.reg_wren <= '0';
                    when OP_SW | OP_SB =>
                        dout.control.reg_wren <= '0';
                    when others =>
                        dout.control.reg_wren <= '1';
                end case;

            when TYPE_IV =>
                dout.control.reg_wren <= din.operation(27);

            when others =>
                dout.control.reg_wren <= '0';
        end case;

        -- mem wren
        if op_type = TYPE_II and (op = OP_SW or op = OP_SB) then
            dout.control.mem_wren <= '1';
        else
            dout.control.mem_wren <= '0';
        end if;

        -- pr_wren
        if op_type = TYPE_I then
            case op is
                when OP_ANDP | OP_ORP | OP_NORP | OP_XORP =>
                    dout.control.pr_wren <= '1';
                when OP_CMPEQ | OP_CMPLT | OP_CMPLTU =>
                    dout.control.pr_wren <= '1';
                when OP_CMPGT | OP_CMPGTU =>
                    dout.control.pr_wren <= '1';
                when others =>
                    dout.control.pr_wren <= '0';
            end case;
        elsif op_type = TYPE_II then
            case op is
                when OP_CMPEQI | OP_CMPLTI | OP_CMPLTUI =>
                    dout.control.pr_wren <= '1';
                when OP_CMPGTI | OP_CMPGTUI =>
                    dout.control.pr_wren <= '1';
                when others =>
                    dout.control.pr_wren <= '0';
            end case;
        else
            dout.control.pr_wren <= '0';
        end if;

        -- j_take
        if op_type = TYPE_III or op_type = TYPE_IV then
            dout.control.j_take <= '1';
        else
            dout.control.j_take <= '0';
        end if;

        -- jr_take
        if op_type = TYPE_I and (op = OP_JR or op = OP_JALR) then
            dout.control.jr_take <= '1';
        else
            dout.control.jr_take <= '0';
        end if;
           
        ---------------
        -- selectors --
        ---------------

        if op_type = TYPE_I then
            dout.control.reg_dst_sel <= '0';
        else
            dout.control.reg_dst_sel <= '1';
        end if;

        if op_type = TYPE_I then 
            case op is
                when OP_SHADD | OP_SLLV | OP_SRAV | OP_SLRV =>
                    dout.control.alu_sh_sel <= '1';
                when others =>
                    dout.control.alu_sh_sel <= '0';
            end case;
        else
            dout.control.alu_sh_sel <= '0';
        end if;

        if op_type = TYPE_I then
            dout.control.reg_immd_sel <= '0';
        else
            dout.control.reg_immd_sel <= '1';
        end if;

        if op_type = TYPE_I and op = OP_JALR then
            dout.control.immd_pc_sel <= '1';
        elsif op_type = TYPE_IV then
            dout.control.immd_pc_sel <= '1';
        else
            dout.control.immd_pc_sel <= '0';
        end if;


        if op_type = TYPE_II and (op = OP_LW or op = OP_LB) then
            dout.control.alu_sh_mem_sel <= '1';
        else
            dout.control.alu_sh_mem_sel <= '0';
        end if;

        if op_type = TYPE_I and op = OP_SHADD then
            dout.control.sh_amt_src_sel <= '1';
        else
            dout.control.sh_amt_src_sel <= '0';
        end if;

        -- sh_type and bshift_sel
        if op_type = TYPE_I then
            case op is
                when OP_SHADD =>
                    dout.control.sh_type <= din.operation(24 downto 23);
                    dout.control.bshift_sel <= '1';
                when OP_SLLV =>
                    dout.control.sh_type <= SH_SLL;
                    dout.control.bshift_sel <= '0';
                when OP_SLRV =>
                    dout.control.sh_type <= SH_SRL;
                    dout.control.bshift_sel <= '0';
                when OP_SRAV =>
                    dout.control.sh_type <= SH_SRA;
                    dout.control.bshift_sel <= '0';
                when others =>
                    dout.control.sh_type <= SH_SLL;
                    dout.control.bshift_sel <= '0';
            end case;
        else
            dout.control.sh_type <= SH_SLL;
            dout.control.bshift_sel <= '0';
        end if;

        -- alu_op
        case op_type is
            when TYPE_I =>
                case op is
                    when OP_ADD =>
                        dout.control.alu_op <= ALU_ADD;
                    when OP_SUB =>  
                        dout.control.alu_op <= ALU_SUB ;
                    when OP_ADC =>
                        dout.control.alu_op <= ALU_ADC;
                    when OP_SBC =>   
                        dout.control.alu_op <= ALU_SBC;


                    when OP_AND =>
                        dout.control.alu_op <= ALU_AND;
                    when OP_OR  =>
                        dout.control.alu_op <= ALU_OR;
                    when OP_NOR =>
                        dout.control.alu_op <= ALU_NOR;
                    when OP_XOR =>   
                        dout.control.alu_op <= ALU_XOR;

                    when OP_CMPEQ => 
                        dout.control.alu_op <= ALU_CMPEQ;
                    when OP_CMPLT => 
                        dout.control.alu_op <= ALU_CMPLT;
                    when OP_CMPLTU => 
                        dout.control.alu_op <= ALU_CMPLTU;
                    when OP_CMPGT => 
                        dout.control.alu_op <= ALU_CMPGT;
                    when OP_CMPGTU => 
                        dout.control.alu_op <= ALU_CMPGTU;

                    when OP_ANDP  => 
                        dout.control.alu_op <= ALU_ANDP;
                    when OP_ORP   => 
                        dout.control.alu_op <= ALU_ORP;
                    when OP_XORP  => 
                        dout.control.alu_op <= ALU_XORP;
                    when OP_NORP  => 
                        dout.control.alu_op <= ALU_XORP;

                    when OP_SLLV | OP_SLRV | OP_SRAV =>   
                        dout.control.alu_op <= ALU_ADD;
                    when OP_JR | OP_JALR | OP_SHADD => 
                        dout.control.alu_op <= ALU_ADD;
                    when others =>
                        dout.control.alu_op <= ALU_ADD;

                end case;

            when TYPE_II =>
                case op is
                    when OP_ADDI =>
                        dout.control.alu_op <= ALU_ADD;
                    when OP_ADCI =>  
                        dout.control.alu_op <= ALU_ADC;
                    when OP_ANDI =>
                        dout.control.alu_op <= ALU_AND;
                    when OP_ORI  =>
                        dout.control.alu_op <= ALU_OR;

                    when OP_CMPEQI => 
                        dout.control.alu_op <= ALU_CMPEQ;
                    when OP_CMPLTI => 
                        dout.control.alu_op <= ALU_CMPLT;
                    when OP_CMPLTUI => 
                        dout.control.alu_op <= ALU_CMPLTU;
                    when OP_CMPGTI => 
                        dout.control.alu_op <= ALU_CMPGT;
                    when OP_CMPGTUI => 
                        dout.control.alu_op <= ALU_CMPGTU;

                    when others =>
                        dout.control.alu_op <= ALU_ADD;
                end case;
            when others =>
                dout.control.alu_op <= ALU_ADD;
        end case;
    end process;

end behavior;
