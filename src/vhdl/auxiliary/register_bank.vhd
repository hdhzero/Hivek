library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use ieee.hivek_pack.all;

entity register_bank is
    port (
        clock   : in std_logic;
        reset   : in std_logic;
        load1   : in std_logic;
        load2   : in std_logic;
        reg_a1  : in std_logic_vector(3 downto 0);
        reg_b1  : in std_logic_vector(3 downto 0);
        reg_a2  : in std_logic_vector(3 downto 0);
        reg_b2  : in std_logic_vector(3 downto 0);
        reg_c1  : in std_logic_vector(3 downto 0);
        reg_c1  : in std_logic_vector(3 downto 0);
        din_c1  : in std_logic_vector(31 downto 0);
        din_c2  : in std_logic_vector(31 downto 0);
        dout_a1 : out std_logic_vector(31 downto 0);
        dout_b1 : out std_logic_vector(31 downto 0);
        dout_a2 : out std_logic_vector(31 downto 0);
        dout_b2 : out std_logic_vector(31 downto 0)
    );
end register_bank;

architecture register_bank_arch1 of register_bank is
    type reg_array is array (0 to 15) of std_logic_vector(31 downto 0);

    signal reg_out : reg_array;
    signal loads1  : std_logic_vector(15 downto 0);
    signal loads2  : std_logic_vector(15 downto 0);
    
begin
    dout_a1 <= reg_out(to_integer(unsigned(reg_a1)));
    dout_a2 <= reg_out(to_integer(unsigned(reg_a2)));
    dout_b1 <= reg_out(to_integer(unsigned(reg_b1)));
    dout_b2 <= reg_out(to_integer(unsigned(reg_b2)));

    load_decoder_u1 : load_decoder
    port map (
        address => reg_c1,
        loads   => loads1
    );

    load_decoder_u2 : load_decoder
    port map (
        address => reg_c2,
        loads   => loads2,
    );

    registers : for i in 0 to 15 generate
        single_register_u : single_register
        port map (
            clock => clock,
            reset => reset,
            load1 => loads1(i),
            load2 => loads2(i),
            din1  => din_c1,
            din2  => din_c2,
            dout  => reg_out(i)
        );
    end generate;
end register_bank_arch1;
