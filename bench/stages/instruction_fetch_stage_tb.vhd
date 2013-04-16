library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity instruction_fetch_stage_tb is
end instruction_fetch_stage_tb;

architecture behavior of instruction_fetch_stage_tb is
    signal clock       : std_logic;
    signal reset       : std_logic;
    signal pc_load     : std_logic;
    signal imem_load   : std_logic;
    signal j_taken     : std_logic;
    signal j_value     : std_logic_vector(31 downto 0);
    signal imem_data_i : std_logic_vector(63 downto 0);
    signal imem_addr   : std_logic_vector(31 downto 0);
    signal instruction : std_logic_vector(63 downto 0);

begin
    process
    begin
        clock <= '0';
        wait for 5 ns;
        clock <= '1';
        wait for 5 ns;
    end process;

    process
    begin
        reset       <= '1';
        pc_load     <= '0';
        imem_load   <= '0';
        j_taken     <= '0';
        j_value     <= x"00000000";
        imem_data_i <= x"0000000000000000";
        imem_addr   <= x"00000000";
        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';

        reset       <= '0';
        pc_load     <= '1';
        imem_load   <= '0';
        j_taken     <= '0';
        j_value     <= x"00000000";
        imem_data_i <= x"0000000000000000";
        imem_addr   <= x"00000000";
        wait until clock'event and clock = '1';

        reset       <= '0';
        pc_load     <= '1';
        imem_load   <= '0';
        j_taken     <= '0';
        j_value     <= x"00000000";
        imem_data_i <= x"0000000000000000";
        imem_addr   <= x"00000000";
        wait until clock'event and clock = '1';

        reset       <= '0';
        pc_load     <= '1';
        imem_load   <= '0';
        j_taken     <= '0';
        j_value     <= x"00000000";
        imem_data_i <= x"0000000000000000";
        imem_addr   <= x"00000000";
        wait until clock'event and clock = '1';

        reset       <= '0';
        pc_load     <= '1';
        imem_load   <= '0';
        j_taken     <= '0';
        j_value     <= x"00000000";
        imem_data_i <= x"0000000000000000";
        imem_addr   <= x"00000000";
        wait until clock'event and clock = '1';

        reset       <= '0';
        pc_load     <= '1';
        imem_load   <= '0';
        j_taken     <= '0';
        j_value     <= x"00000000";
        imem_data_i <= x"0000000000000000";
        imem_addr   <= x"00000000";
        wait until clock'event and clock = '1';

        wait;
    end process;

    instruction_fetch_stage_u : instruction_fetch_stage
    port map (
        clock       => clock,
        reset       => reset,
        pc_load     => pc_load,
        imem_load   => imem_load,
        j_taken     => j_taken,
        j_value     => j_value,
        imem_data_i => imem_data_i,
        imem_addr   => imem_addr,
        instruction => instruction
    );
end behavior;

