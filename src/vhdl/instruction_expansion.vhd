library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pack.all;

entity instruction_expansion is
    port (
        from_pipe : in IF_IEXP;
        to_pipe   : out IEXP_ID
    );
end instruction_expansion;

architecture behavior of instruction_expansion is
begin

end behavior;

