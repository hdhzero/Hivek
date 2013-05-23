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
    signal operation_type :operation_type_t;  
    signal operation : operation_t;
begin

    process (din, operation_type)
    begin
        case operation_type is
            when TYPE_I =>
                operation <= din.operation(24 downto 20);
            when TYPE_II =>
                operation <= '0' & din.operation(28 downto 25);
            when others =>
                operation <= (others => '0');
        end case;
    end process;

    process (din)
    begin
        if din.operation(29 downto 25) = "11100" then
            operation_type <= TYPE_I;
        elsif din.operation(29) = '0' then
            operation_type <= TYPE_II;
        elsif din.operation(29 downto 27) = "110" then
            operation_type <= TYPE_III;
        elsif din.operation(29 downto 28) = "10" then
            operation_type <= TYPE_IV;
        else
            operation_type <= TYPE_V;
        end if;
    end process;

    process (din, operation_type)
    begin
        dout.reg_a <= din.operation(7 downto 3);
        dout.reg_b <= din.operation(12 downto 8);
        dout.reg_c <= din.operation(17 downto 13);

        dout.pr_reg  <= din.operation(1 downto 0);
        dout.pr_data <= din.operation(2);

        dout.sh_immd <= din.operation(22 downto 18);

        -- sign extension
        if din.operation(23) = '1' then
            dout.immd32 <= ONES(19 downto 0) & din.operation(23 downto 12);
        else
            dout.immd32 <= ZERO(19 downto 0) & din.operation(23 downto 12);
        end if;

        --------------
        -- controls --
        --------------

        if operation_type = TYPE_II and (operation = OP_SW or operation = OP_SB) then
            dout.control.mem_wren <= '1';
        else
            dout.control.mem_wren <= '0';
        end if;

        -- pr_wren
        if operation_type = TYPE_I then
            case operation is
                when OP_ANDP | OP_ORP | OP_NORP | OP_XORP =>
                    dout.control.pr_wren <= '1';
                when OP_CMPEQ | OP_CMPLT | OP_CMPLTU =>
                    dout.control.pr_wren <= '1';
                when OP_CMPGT | OP_CMPGTU =>
                    dout.control.pr_wren <= '1';
                when others =>
                    dout.control.pr_wren <= '0';
            end case;
        elsif operation_type = TYPE_II then
            case operation is
                when OP_CMPEQI | OP_CMPLTI | OP_CMPLTUI =>
                    dout.control.pr_wren <= '1';
                when OP_CMPGTI | OP_CMPGTUI =>
                    dout.control.pr_wren <= '1';
                when others =>
                    dout.control.pr_wren <= '0';
            end case;
        end if;

                    --when OP_ADD =>
                        --dout.control.alu_op   <= ALU_ADD;
                        --dout.control.sh_type  <= SH_SLL;
                        --dout.control.reg_wren <= '1';
                        --dout.control.mem_wren <= '0';
                        --dout.control.pr_wren  <= '0';
                        --dout.control.reg_dst_sel  <= '0';
                        --dout.control.alu_sh_sel   <= '0';
                        --dout.control.reg_immd_sel <= '0';
                        --dout.control.alu_sh_mem_sel <= '0';
                        --dout.control.sh_amt_src_sel <= '0';

    end process;

end behavior;
