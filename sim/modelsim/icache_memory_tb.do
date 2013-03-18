vlib work
vmap work

vcom -work work -93 -explicit ../../src/vhdl/hivek_pack.vhd
vcom -work work -93 -explicit ../../src/vhdl/icache_memory.vhd
vcom -work work -93 -explicit ../../bench/icache_memory_tb.vhd

vsim -t 1ns -lib work icache_memory_tb

add wave -noupdate -format Logic -radix binary /icache_memory_tb/clock
add wave -noupdate -format Logic -radix binary /icache_memory_tb/load
add wave -noupdate -format Literal -radix hexadecimal /icache_memory_tb/address
add wave -noupdate -format Literal -radix hexadecimal /icache_memory_tb/data_i
add wave -noupdate -format Literal -radix hexadecimal /icache_memory_tb/data_o

view wave
run 500ns
