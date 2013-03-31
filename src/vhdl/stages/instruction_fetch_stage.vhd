library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pack.all;

entity instruction_fetch_stage is
    port (
        clock       : in std_logic;
        clock2x     : in std_logic;
        reset       : in std_logic;
        pc_load     : in std_logic;
        imem_load   : in std_logic;
        j_taken     : in std_logic;
        j_value     : in std_logic_vector(31 downto 0);
        imem_data_i : in std_logic_vector(63 downto 0);
        imem_addr   : in std_logic_vector(31 downto 0);
        to_pipe     : out IF_IEXP
    );
end instruction_fetch_stage;

architecture behavior of instruction_fetch_stage is
    signal pc     : std_logic_vector(31 downto 0);
    signal new_pc : std_logic_vector(31 downto 0);
    signal inst64 : std_logic_vector(63 downto 0);

    signal sequential_inc : std_logic_vector(31 downto 0);

    signal add2 : std_logic_vector(31 downto 0);
    signal add4 : std_logic_vector(31 downto 0);
    signal add6 : std_logic_vector(31 downto 0);
    signal add8 : std_logic_vector(31 downto 0);

    signal inst_size : std_logic_vector(1 downto 0);
    signal head_bits : std_logic_vector(2 downto 0);

begin
    add2 <= std_logic_vector(unsigned(pc) + x"00000002");
    add4 <= std_logic_vector(unsigned(pc) + x"00000004");
    add6 <= std_logic_vector(unsigned(pc) + x"00000006");
    add8 <= std_logic_vector(unsigned(pc) + x"00000008");

    head_bits <= inst64(63) & inst64(62) & inst64(46);

    to_pipe.head1 <= inst64(63 downto 48);
    to_pipe.head2 <= inst64(47 downto 32);
    to_pipe.tail1 <= inst64(31 downto 16);
    to_pipe.tail2 <= inst64(15 downto 0);

    process (clock, reset, new_pc)
    begin
        if reset = '1' then 
            pc <= (others => '0');
        elsif clock'event and clock = '1' then
            if pc_load = '1' then
                pc <= new_pc;
            end if;
        end if;
    end process;

    process (j_taken, j_value, sequential_inc)
    begin
        if j_taken = '1' then
            new_pc <= j_value;
        else
            new_pc <= sequential_inc;
        end if;
    end process;

    process (inst_size, add2, add4, add6, add8, pc)
    begin
        case inst_size is
            when "00" =>     -- 16 bits
                sequential_inc <= add2;
            when "01" =>      --32 bits or 2x16 bits
                sequential_inc <= add4;
            when "10" =>      -- 32+16 bits
                sequential_inc <= add6;
            when "11" =>      -- 2x32 bits
                sequential_inc <= add8;
            when others =>
                sequential_inc <= pc;
        end case;
    end process;

    process (head_bits)
    begin
        case head_bits is
            when "000" =>
                inst_size <= "00";
            when "001" =>
                inst_size <= "00";
            when "010" =>
                inst_size <= "01";
            when "011" =>
                inst_size <= "01";
            when "100" =>
                inst_size <= "01";
            when "101" =>
                inst_size <= "10";
            when "110" =>
                inst_size <= "10";
            when "111" =>
                inst_size <= "11";
            when others =>
                inst_size <= "00";
        end case;
    end process;

    icache_memory_u : icache_memory
    port map (
        clock   => clock2x,
        load    => imem_load,
        address => pc,
        data_i  => imem_data_i,
        data_o  => inst64
    );
end behavior;
