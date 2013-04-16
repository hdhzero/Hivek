# project directories
# update project_dir to the folder where your files are
PROJECT_DIR = /home/hdhzero/projetos/Hivek

# do not modify below unless you know what you are doing
SRC_DIR     = $(PROJECT_DIR)/src
BENCH_DIR   = $(PROJECT_DIR)/bench
SIM_DIR     = $(PROJECT_DIR)/sim
WORK_DIR    = $(SIM_DIR)/work

# simulator used: modelsim or ghdl
SIMULATOR   = modelsim

# on the two ifeq below, update the paths for your modelsim
# and/or ghdl
ifeq ("$(SIMULATOR)", "modelsim")
    MKLIB  = vlib
    MAP    = vmap WORK
    COM    = vcom -work $(WORK_DIR) -93 -explicit 
    SIM    = vsim -c
    COM_FLAGS =
    SIM0_FLAGS =
    SIM1_FLAGS =
endif

ifeq ("$(SIMULATOR)", "ghdl")
    MKLIB  = mkdir 
    MAP    = echo work directory created at
    COM    = ghdl -a --workdir=$(WORK_DIR)
    SIM    = ghdl --elab-run
    COM_FLAGS =
    SIM0_FLAGS =
    SIM1_FLAGS =
endif

define \n


endef

###############################
## File related stuff
## - files to be compiled
## - waves to be added
###############################

# barrel shifter related stuff
BARREL_SHIFTER_FILES = $(SRC_DIR)/vhdl/hivek_pkg.vhd \
    $(SRC_DIR)/vhdl/auxiliary/barrel_shifter.vhd \
    $(BENCH_DIR)/auxiliary/barrel_shifter_tb.vhd

BARREL_SHIFTER_TB = barrel_shifter_tb

ifeq ("$(SIMULATOR)", "modelsim")
    SIM0_FLAGS = -do "vcd file teste.vcd; vcd add /barrel_shifter_tb/*; run 100ns; quit -sim; quit"
    SIM1_FLAGS = 
endif

ifeq ("$(SIMULATOR)", "ghdl")
    SIM0_FLAGS = --workdir=$(WORK_DIR)
    SIM1_FLAGS = --stop-time=100ns --vcd=barrel_shifter_tb.vcd
endif

barrel_shifter_tb:
	$(MKLIB) $(WORK_DIR)
	$(MAP) $(WORK_DIR)
	$(foreach file, $(BARREL_SHIFTER_FILES), $(COM) $(file); ${\n})
	$(SIM) $(SIM0_FLAGS) $(BARREL_SHIFTER_TB) $(SIM1_FLAGS)

# instruction_fetch_stage
INSTRUCTION_FETCH_STAGE_FILES = $(SRC_DIR)/vhdl/hivek_pkg.vhd \
    $(SRC_DIR)/vhdl/auxiliary/icache_memory.vhd \
    $(SRC_DIR)/vhdl/stages/instruction_fetch_stage.vhd \
    $(BENCH_DIR)/stages/instruction_fetch_stage_tb.vhd

INSTRUCTION_FETCH_STAGE_TB = instruction_fetch_stage_tb
clean:
	rm -rf *.ini
	rm -rf $(WORK_DIR)
	rm -rf *.wlf
	rm -rf *.vcd
	rm -rf transcript
	rm -rf *.o
	rm -rf *.cf
	rm $(BARREL_SHIFTER_TB)
