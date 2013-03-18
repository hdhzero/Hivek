sources = ../../src/vhdl
benchs  = ../../bench

icache_memory_tb:
	ghdl -i $(benchs)/icache_memory_tb.vhd
	ghdl -i $(sources)/icache_memory.vhd
	ghdl -i $(sources)/hivek_pack.vhd 
	ghdl -m icache_memory_tb
	ghdl -r icache_memory_tb --stop-time=1us --wave=icache_memory_tb.ghw
