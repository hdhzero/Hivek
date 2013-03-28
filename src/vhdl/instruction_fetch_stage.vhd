library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pack.all;

entity instruction_fetch_stage is
    port (
        clock : in std_logic;
        reset : in std_logic;
    );
end instruction_fetch_stage;

architecture instruction_fetch_stage_arch of instruction_fetch_stage is
begin

end instruction_fetch_stage_arch;
