library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pack.all;

entity instruction_fetch_stage_tb is
end instruction_fetch_stage_tb;

architecture behavior of instruction_fetch_stage_tb is
entity instruction_fetch_stage is
    port (
        clock       : in std_logic;
        clock2x     : in std_logic;
        reset       : in std_logic;
        pc_load     : in std_logic;
        imem_load   : in std_logic;
        j_taken     : in std_logic;
        j_value     : in std_logic_vector(31 downto 0);
        imem_data_i : in std_logic_vector(31 downto 0);
        imem_addr   : in std_logic_vector(31 downto 0);
        to_pipe     : out IF_IEXP
    );
end instruction_fetch_stage;

begin
end behavior;
