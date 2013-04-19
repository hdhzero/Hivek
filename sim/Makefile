# project directories
# update project_dir to the folder where your files are
PROJECT_DIR = /home/hdhzero/projetos/Hivek

# do not modify below unless you know what you are doing
SRC_DIR     = $(PROJECT_DIR)/src
BENCH_DIR   = $(PROJECT_DIR)/bench
SIM_DIR     = $(PROJECT_DIR)/sim
WORK_DIR    = $(SIM_DIR)/work

# simulator used: modelsim or ghdl
sim         = modelsim
SIMULATOR   = $(sim)

TESTBENCH = none
RUNTIME = 100
FILES = none

# on the two ifeq below, update the paths for your modelsim
# and/or ghdl
# for modelsim wave visualization, use vcd2vliw
ifeq ("$(SIMULATOR)", "modelsim")
    MKLIB  = vlib
    MAP    = vmap WORK
    COM    = vcom -work $(WORK_DIR) -93 -explicit 
    SIM    = vsim -c
    COM_FLAGS =
    SIM0_FLAGS = -do "vcd file $(TESTBENCH).vcd; vcd add /$(TESTBENCH)/*; run $(RUNTIME)ns; quit -sim; quit"
    SIM1_FLAGS = 
endif

ifeq ("$(SIMULATOR)", "ghdl")
    MKLIB  = mkdir 
    MAP    = echo work directory created at
    COM    = ghdl -a --workdir=$(WORK_DIR)
    SIM    = ghdl --elab-run
    COM_FLAGS =
    SIM0_FLAGS = --workdir=$(WORK_DIR)
    SIM1_FLAGS = --stop-time=$(RUNTIME)ns --vcd=$(TESTBENCH).vcd
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

barrel_shifter_tb: TESTBENCH = $(BARREL_SHIFTER_TB)
barrel_shifter_tb: RUNTIME   = 500
barrel_shifter_tb: FILES     = $(BARREL_SHIFTER_FILES)
barrel_shifter_tb:
	$(MKLIB) $(WORK_DIR)
	$(MAP) $(WORK_DIR)
	$(foreach file, $(FILES), $(COM) $(file); ${\n})
	$(SIM) $(SIM0_FLAGS) $(TESTBENCH) $(SIM1_FLAGS)


# register bank
REGISTER_BANK_FILES = $(SRC_DIR)/vhdl/hivek_pkg.vhd \
    $(SRC_DIR)/vhdl/auxiliary/bank_selector.vhd \
    $(SRC_DIR)/vhdl/auxiliary/reg_bram_altera.vhd \
    $(SRC_DIR)/vhdl/auxiliary/reg_bram.vhd \
    $(SRC_DIR)/vhdl/auxiliary/reg_block.vhd \
    $(SRC_DIR)/vhdl/auxiliary/register_bank.vhd \
    $(BENCH_DIR)/auxiliary/register_bank_tb.vhd

REGISTER_BANK_TB = register_bank_tb

register_bank_tb: TESTBENCH = $(REGISTER_BANK_TB)
register_bank_tb: RUNTIME   = 500
register_bank_tb: FILES     = $(REGISTER_BANK_FILES)
register_bank_tb:
	$(MKLIB) $(WORK_DIR)
	$(MAP) $(WORK_DIR)
	$(foreach file, $(FILES), $(COM) $(file); ${\n})
	$(SIM) $(SIM0_FLAGS) $(TESTBENCH) $(SIM1_FLAGS)

clean:
	rm -rf *.ini
	rm -rf $(WORK_DIR)
	rm -rf *.wlf
	rm -rf *.vcd
	rm -rf transcript
	rm -rf *.o
	rm -rf *.cf
	rm $(BARREL_SHIFTER_TB)
