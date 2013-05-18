library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pack.all;

entity instruction_decode_stage is
    port (
        clock   : in std_logic;
        wren0   : in std_logic;
        wren1   : in std_logic;
        reg_a0  : in std_logic_vector(4 downto 0);
        reg_a1  : in std_logic_vector(4 downto 0);
        reg_b0  : in std_logic_vector(4 downto 0);
        reg_b1  : in std_logic_vector(4 downto 0);
        reg_c0  : in std_logic_vector(4 downto 0);
        reg_c1  : in std_logic_vector(4 downto 0);
        din_c0  : in std_logic_vector(31 downto 0);
        din_c1  : in std_logic_vector(31 downto 0);
        dout_a0 : out std_logic_vector(31 downto 0);
        dout_a1 : out std_logic_vector(31 downto 0);
        dout_b0 : out std_logic_vector(31 downto 0);
        dout_b1 : out std_logic_vector(31 downto 0);
    );
end instruction_decode_stage;

architecture behavior of instruction_decode_stage is
    signal immd27_0 : std_logic_vector(26 downto 0);
    signal immd12_0 : std_logic_vector(11 downto 0);
begin
end behavior;
