library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dcache_selector is
    generic (
        VENDOR     : string  := "GENERIC";
        ADDR_WIDTH : integer := 8 -- 2 ^ ADDR_WIDTH addresses
    );
    port (
        clock    : in std_logic;
        sel      : in std_logic_vector(1 downto 0);

        a_wren_0   : in std_logic;
        a_addr_0   : in std_logic_vector(31 downto 0);
        a_data_i_0 : in std_logic_vector(31 downto 0);
        a_data_o_0 : out std_logic_vector(31 downto 0);

        b_wren_0   : in std_logic;
        b_addr_0   : in std_logic_vector(31 downto 0);
        b_data_i_0 : in std_logic_vector(31 downto 0);
        b_data_o_0 : out std_logic_vector(31 downto 0);

        a_wren_1   : in std_logic;
        a_addr_1   : in std_logic_vector(31 downto 0);
        a_data_i_1 : in std_logic_vector(31 downto 0);
        a_data_o_1 : out std_logic_vector(31 downto 0);

        b_wren_1   : in std_logic;
        b_addr_1   : in std_logic_vector(31 downto 0);
        b_data_i_1 : in std_logic_vector(31 downto 0);
        b_data_o_1 : out std_logic_vector(31 downto 0);

        a_wren_2   : in std_logic;
        a_addr_2   : in std_logic_vector(31 downto 0);
        a_data_i_2 : in std_logic_vector(31 downto 0);
        a_data_o_2 : out std_logic_vector(31 downto 0);

        b_wren_2   : in std_logic;
        b_addr_2   : in std_logic_vector(31 downto 0);
        b_data_i_2 : in std_logic_vector(31 downto 0);
        b_data_o_2 : out std_logic_vector(31 downto 0);

        a_wren_3   : in std_logic;
        a_addr_3   : in std_logic_vector(31 downto 0);
        a_data_i_3 : in std_logic_vector(31 downto 0);
        a_data_o_3 : out std_logic_vector(31 downto 0);

        b_wren_3   : in std_logic;
        b_addr_3   : in std_logic_vector(31 downto 0);
        b_data_i_3 : in std_logic_vector(31 downto 0);
        b_data_o_3 : out std_logic_vector(31 downto 0)
    );
end dcache_selector;

architecture behavior of dcache_selector is
    component dcache_memory is
    generic (
        VENDOR     : string  := "GENERIC";
        ADDR_WIDTH : integer := 8 -- 2 ^ ADDR_WIDTH addresses
    );
    port (
        clock    : in std_logic;

        a_wren   : in std_logic;
        a_addr   : in std_logic_vector(31 downto 0);
        a_data_i : in std_logic_vector(31 downto 0);
        a_data_o : out std_logic_vector(31 downto 0);

        b_wren   : in std_logic;
        b_addr   : in std_logic_vector(31 downto 0);
        b_data_i : in std_logic_vector(31 downto 0);
        b_data_o : out std_logic_vector(31 downto 0)
    );
    end component;

    signal a_wren   : std_logic;
    signal a_addr   : std_logic_vector(31 downto 0);
    signal a_data_i : std_logic_vector(31 downto 0);
    signal a_data_o : std_logic_vector(31 downto 0);

    signal b_wren   : std_logic;
    signal b_addr   : std_logic_vector(31 downto 0);
    signal b_data_i : std_logic_vector(31 downto 0);
    signal b_data_o : std_logic_vector(31 downto 0);

begin
    a_wren <= a_wren_0 when sel = "00" else
              a_wren_1 when sel = "01" else
              a_wren_2 when sel = "10" else
              a_wren_3;

    a_addr <= a_addr_0 when sel = "00" else
              a_addr_1 when sel = "01" else
              a_addr_2 when sel = "10" else
              a_addr_3;

    a_data_i <= a_data_i_0 when sel = "00" else
                a_data_i_1 when sel = "01" else
                a_data_i_2 when sel = "10" else
                a_data_i_3;

    a_data_o_0 <= a_data_o;
    a_data_o_1 <= a_data_o;
    a_data_o_2 <= a_data_o;
    a_data_o_3 <= a_data_o;

    b_wren <= b_wren_0 when sel = "00" else
              b_wren_1 when sel = "01" else
              b_wren_2 when sel = "10" else
              b_wren_3;

    b_addr <= b_addr_0 when sel = "00" else
              b_addr_1 when sel = "01" else
              b_addr_2 when sel = "10" else
              b_addr_3;

    b_data_i <= b_data_i_0 when sel = "00" else
                b_data_i_1 when sel = "01" else
                b_data_i_2 when sel = "10" else
                b_data_i_3;

    b_data_o_0 <= b_data_o;
    b_data_o_1 <= b_data_o;
    b_data_o_2 <= b_data_o;
    b_data_o_3 <= b_data_o;

    dcache_memory_u : dcache_memory
    generic map (
        VENDOR => VENDOR,
        ADDR_WIDTH => ADDR_WIDTH
    )
    port map (
        clock    => clock,
        a_wren   => a_wren,
        a_addr   => a_addr,
        a_data_i => a_data_i,
        a_data_o => a_data_o,
        b_wren   => b_wren,
        b_addr   => b_addr,
        b_data_i => b_data_i,
        b_data_o => b_data_o
    ); 

end behavior;
