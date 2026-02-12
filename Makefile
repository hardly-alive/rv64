# ------------------------------------------------------------------------------
# VARIABLES
# ------------------------------------------------------------------------------
TOP     = core_top
OBJ_DIR = obj_dir

RTL_DIR  = rtl
TB_DIR   = dv/tb
INC_DIR  = rtl/include

# Source Files: Package first, then core files
SRCS = $(RTL_DIR)/include/riscv_pkg.sv $(wildcard $(RTL_DIR)/core/*.sv)
CPP_TB   = $(TB_DIR)/sim_main.cpp

# Verilator Flags
VERILATOR_FLAGS = -Wall --cc --exe --trace \
                  --top-module $(TOP) \
                  -I$(INC_DIR)

# ------------------------------------------------------------------------------
# TARGETS
# ------------------------------------------------------------------------------

# Default target (runs everything)
all: sim

# 1. SOFTWARE BUILD (Generates program.hex)
# Calls the Makefile inside the 'sw' directory
hex:
	$(MAKE) -C sw

# 2. HARDWARE BUILD (Generates Vcore_top executable)
# Runs Verilator to convert SV to C++, then compiles C++
build: hex
	verilator $(VERILATOR_FLAGS) $(SRCS) $(CPP_TB)
	$(MAKE) -C $(OBJ_DIR) -f V$(TOP).mk

# 3. SIMULATION (Runs SW build, HW build, then executes)
sim: build
	./$(OBJ_DIR)/V$(TOP)

# 4. CLEANUP (Removes HW objects, Waveforms, and SW binaries)
clean:
	rm -rf $(OBJ_DIR) *.vcd
	$(MAKE) -C sw clean

# Mark targets as 'phony' so Make doesn't confuse them with file names
.PHONY: all hex build sim clean