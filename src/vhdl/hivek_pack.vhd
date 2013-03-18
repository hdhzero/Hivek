library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package hivek_pack is
    ------------------------
    -- constants definitions
    ------------------------

    constant ZERO : std_logic_vector(63 downto 0) := x"0000000000000000";
    constant ONES : std_logic_vector(63 downto 0) := x"FFFFFFFFFFFFFFFF";
    constant ONE  : std_logic_vector(63 downto 0) := x"0000000000000001";

    -------------------------
    -- components definitions
    -------------------------

    -- used in the register bank
    component load_decoder is
    port (
        address : in std_logic_vector(3 downto 0);
        loads   : out std_logic_vector(15 downto 0)
    );
    end component;

    -- used in the register bank
    component single_register is
    port (
        clock : in std_logic;
        reset : in std_logic;
        load1 : in std_logic;
        load2 : in std_logic;
        din1  : in std_logic_vector(31 downto 0);
        din2  : in std_logic_vector(31 downto 0);
        dout  : out std_logic_vector(31 downto 0)
    );
    end component;

    -- the register bank
    component register_bank is
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
        reg_c2  : in std_logic_vector(3 downto 0);
        din_c1  : in std_logic_vector(31 downto 0);
        din_c2  : in std_logic_vector(31 downto 0);
        dout_a1 : out std_logic_vector(31 downto 0);
        dout_b1 : out std_logic_vector(31 downto 0);
        dout_a2 : out std_logic_vector(31 downto 0);
        dout_b2 : out std_logic_vector(31 downto 0)
    );
    end component;

    component icache_memory is
    port (
        clock   : in std_logic;
        load    : in std_logic;
        address : in std_logic_vector(31 downto 0);
        data_i  : in std_logic_vector(63 downto 0);
        data_o  : out std_logic_vector(63 downto 0)
    );
    end component;

end package;
