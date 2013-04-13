library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pack.all;

entity barrel_shifter is   -- barrel shifter
    port (
        left    : in  std_logic; -- '1' for left, '0' for right
        logical : in  std_logic; -- '1' for logical, '0' for arithmetic
        shift   : in  std_logic_vector(4 downto 0);  -- shift count
        input   : in  std_logic_vector (31 downto 0);
        output  : out std_logic_vector (31 downto 0) 
    );
end barrel_shifter;

architecture behavior of barrel_shifter is
    signal LR   : std_logic_vector(31 downto 0);
    signal L1s  : std_logic_vector(31 downto 0);
    signal L2s  : std_logic_vector(31 downto 0);
    signal L4s  : std_logic_vector(31 downto 0);
    signal L8s  : std_logic_vector(31 downto 0);
    signal L16s : std_logic_vector(31 downto 0);
    signal L1   : std_logic_vector(31 downto 0);
    signal L2   : std_logic_vector(31 downto 0);
    signal L4   : std_logic_vector(31 downto 0);
    signal L8   : std_logic_vector(31 downto 0);
    signal L16  : std_logic_vector(31 downto 0);
    signal R1s  : std_logic_vector(31 downto 0);
    signal R2s  : std_logic_vector(31 downto 0);
    signal R4s  : std_logic_vector(31 downto 0);
    signal R8s  : std_logic_vector(31 downto 0);
    signal R16s : std_logic_vector(31 downto 0);
    signal R1   : std_logic_vector(31 downto 0);
    signal R2   : std_logic_vector(31 downto 0);
    signal R4   : std_logic_vector(31 downto 0);
    signal R8   : std_logic_vector(31 downto 0);
    signal R16  : std_logic_vector(31 downto 0);
    signal A1s  : std_logic_vector(31 downto 0);
    signal A2s  : std_logic_vector(31 downto 0);
    signal A4s  : std_logic_vector(31 downto 0);
    signal A8s  : std_logic_vector(31 downto 0);
    signal A16s : std_logic_vector(31 downto 0);
    signal A1   : std_logic_vector(31 downto 0);
    signal A2   : std_logic_vector(31 downto 0);
    signal A4   : std_logic_vector(31 downto 0);
    signal A8   : std_logic_vector(31 downto 0);
    signal A16  : std_logic_vector(31 downto 0);
    signal input2s : std_logic_vector(1 downto 0);
    signal input4s : std_logic_vector(3 downto 0);
    signal input8s : std_logic_vector(7 downto 0);
    signal input16s : std_logic_vector(15 downto 0);

begin  -- circuits
    L1s <= input(30 downto 0) & '0'; -- just wiring
    L1  <= input when shift(0) = '0' else L1s;

    L2s <= L1(29 downto 0) & "00"; -- just wiring
    L2  <= L1 when shift(1) = '0' else L2s;

    L4s <= L2(27 downto 0) & "0000"; -- just wiring
    L4  <= L2 when shift(2) = '0' else L4s;

    L8s <= L4(23 downto 0) & "00000000"; -- just wiring
    L8  <= L4 when shift(3) = '0' else L8s;

    L16s <= L8(15 downto 0) & "0000000000000000"; -- just wiring
    L16  <= L8 when shift(4) = '0' else L16s;

    R1s <= '0' & input(31 downto 1); -- just wiring
    R1  <= input when shift(0) = '0' else R1s;

    R2s <= "00" & R1(31 downto 2); -- just wiring
    R2  <= R1 when shift(1) = '0' else R2s;

    R4s <= "0000" & R2(31 downto 4); -- just wiring
    R4  <= R2 when shift(2) = '0' else R4s;

    R8s <= "00000000" & R4(31 downto 8); -- just wiring
    R8  <= R4 when shift(3) = '0' else R8s;

    R16s <= "0000000000000000" & R8(31 downto 16); -- just wiring
    R16  <= R8 when shift(4) = '0' else R16s;

    A1s <= input(31) & input(31 downto 1); -- just wiring
    A1  <= input when shift(0) = '0' else A1s;

    A2s <= input2s & A1(31 downto 2);    -- just wiring
    A2  <= A1 when shift(1) = '0' else A2s;

    A4s <= input4s & A2(31 downto 4);    -- just wiring
    A4  <= A2 when shift(2) = '0' else A4s;

    A8s <= input8s & A4(31 downto 8);    -- just wiring
    A8  <= A4 when shift(3) = '0' else A8s;

    A16s <= input16s & A8(31 downto 16); -- just wiring
    A16  <= A8 when shift(4) = '0' else A16s;

    input2s <= input(31) & input(31);  -- just wiring
    input4s <= input2s & input2s;      -- just wiring
    input8s <= input4s & input4s;      -- just wiring
    input16s <= input8s & input8s;     -- just wiring

    LR <= R16 when left = '0' else L16;

    output <= A16 when logical = '0' else LR;
end architecture behavior;  -- of bshift




