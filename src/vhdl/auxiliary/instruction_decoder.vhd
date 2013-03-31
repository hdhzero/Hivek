library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pack.all;

entity instruction_decoder is
    port (
        instruction : in std_logic_vector(31 downto 0);
        alu_op      : out alu_op_t;
        uflags      : out std_logic;
        mem_load    : out std_logic;
        wren_back   : out std_logic;
        shamt       : out std_logic_vector(4 downto 0);
        sh_type     : out shamt_type_t;
    );
end instruction_decoder;

architecture behavior of instruction_decoder is
begin
    process (opcode)
    begin
        if opcode(5) = '0' then
            op2_src      <= opcode(4);
            update_flags <= opcode(3);
            alu_op       <= opcode(2 downto 0);
            mem_load     <= '0';
            wren_back    <= '1';
        elsif opcode(5 downto 4) = "10" then
            op2_src <= '1';
            update_flags <= '0';
            alu_op <= ALU_ADD_OP;
            mem_load <= '0';
            wren_back <= '0';
        else
            op2_src <= '0';
            update_flags <= '0';
            alu_op <= ALU_ADD_OP;
            mem_load <= '0';
            wren_back <= '0';
--        elsif opcode(5 downto 3) = "110" then
--            op2_src <= '1';
--            update_flags <= '0';
--            alu_op <= ALU_ADD_OP;

--            case opcode(2 downto 0) is
--                when "000" =>
--                  mem_load <= '0';
--                    wren_back <= '1';
--            end case;
        end if;
    end process; 
end behavior;
