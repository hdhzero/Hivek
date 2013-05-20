library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity writeback_stage is
    port (
        din  : writeback_stage_in_t;
        dout : writeback_stage_out_t
    );
end writeback_stage;

architecture writeback_stage of writeback_stage is
begin
    reg_data0 <= alu_data0 when data_sel0 = '0' else mem_data0;
    reg_data1 <= alu_data1 when data_sel1 = '0' else mem_data1;

    reg_wren_o
end writeback_stage;

type bank_writeback_t is record
    reg_wren : std_logic;
    reg_dst  : std_logic_vector(4 downto 0);
    data_sel : std_logic;
    alu_data : std_logic_vector(31 downto 0);
    mem_data : std_logic_vector(31 downto 0);
end record;

type writeback_stage_in_t is record
    bank0 : bank_writeback_t;
    bank1 : bank_writeback_t;
end record;
