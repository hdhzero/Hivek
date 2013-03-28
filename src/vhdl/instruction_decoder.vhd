library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pack.all;

entity instruction_decoder is
    port (

    );
end instruction_decoder;

architecture behavior of instruction_decoder is
begin
    process ()
    begin
        if opcode(5) = '0' then
            op2_src      <= opcode(4);
            update_flags <= opcode(3);
            alu_op       <= opcode(2 downto 0);
        elsif opcode(5 downto 4) = "10" then
            op2_src
    end process; 
end behavior;
