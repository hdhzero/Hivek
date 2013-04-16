vlib work
vmap work

vcom ../src/vhdl/hivek_pkg.vhd
vcom ../src/vhdl/auxiliary/icache_memory.vhd
vcom ../src/vhdl/stages/instruction_fetch_stage.vhd
vcom ../bench/stages/instruction_fetch_stage_tb.vhd

vsim -t 1ns instruction_fetch_stage_tb

add wave /instruction_fetch_stage_tb/clock
add wave /instruction_fetch_stage_tb/reset
add wave /instruction_fetch_stage_tb/pc_load
add wave /instruction_fetch_stage_tb/imem_load
add wave /instruction_fetch_stage_tb/instruction_fetch_stage_u/new_inst_size
add wave -radix hexadecimal /instruction_fetch_stage_tb/j_taken
add wave -radix hexadecimal /instruction_fetch_stage_tb/j_value
add wave -radix hexadecimal /instruction_fetch_stage_tb/imem_data_i
add wave -radix hexadecimal /instruction_fetch_stage_tb/imem_addr
add wave -radix hexadecimal /instruction_fetch_stage_tb/instruction_fetch_stage_u/pc
add wave -radix hexadecimal /instruction_fetch_stage_tb/instruction_fetch_stage_u/inst64
add wave -radix hexadecimal /instruction_fetch_stage_tb/instruction_fetch_stage_u/icache_memory_u/mem0
add wave -radix hexadecimal /instruction_fetch_stage_tb/instruction_fetch_stage_u/icache_memory_u/mem1
add wave -radix hexadecimal /instruction_fetch_stage_tb/instruction_fetch_stage_u/icache_memory_u/mem2
add wave -radix hexadecimal /instruction_fetch_stage_tb/instruction_fetch_stage_u/icache_memory_u/mem3
add wave -radix hexadecimal /instruction_fetch_stage_tb/instruction_fetch_stage_u/icache_memory_u/data_o

view wave
run 500ns
