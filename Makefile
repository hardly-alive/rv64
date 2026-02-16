# ------------------------------------------------------------------------------
# VARIABLES
# ------------------------------------------------------------------------------
TOP     = core_top
OBJ_DIR = obj_dir
RTL_DIR = rtl
TB_DIR  = dv/tb
INC_DIR = rtl/include

SRCS = $(RTL_DIR)/include/riscv_pkg.sv $(wildcard $(RTL_DIR)/core/*.sv)
CPP_TB = $(TB_DIR)/sim_main.cpp

VERILATOR_FLAGS = -Wall --cc --exe --trace \
                  --top-module $(TOP) \
                  -I$(INC_DIR)

# ------------------------------------------------------------------------------
# TARGETS
# ------------------------------------------------------------------------------

all: sim

# 1. COMPILE HARDWARE ONLY (Verilog -> C++ -> Exe)
# Does NOT touch the software folder
hw:
	verilator $(VERILATOR_FLAGS) $(SRCS) $(CPP_TB)
	$(MAKE) -C $(OBJ_DIR) -f V$(TOP).mk

# 2. COMPILE DEFAULT SOFTWARE (main.c -> program.hex)
sw:
	$(MAKE) -C sw

# 3. RUN DEFAULT SIMULATION
sim: sw hw
	./$(OBJ_DIR)/V$(TOP)

# 4. RUN SANITY CHECK
sanity:
	riscv64-unknown-elf-gcc -march=rv64im -mabi=lp64 -nostdlib -T sw/link.ld -o dv/tests/bin/sanity.elf sw/crt0.s dv/tests/src/sanity_check.c
	riscv64-unknown-elf-objcopy -O binary dv/tests/bin/sanity.elf dv/tests/bin/sanity.bin
	hexdump -v -e '1/1 "%02x\n"' dv/tests/bin/sanity.bin > sw/program.hex
	$(MAKE) hw
	./$(OBJ_DIR)/V$(TOP)

# Cleanup
clean:
	# 1. Remove Hardware Simulation Objects
	rm -rf $(OBJ_DIR)
	
	# 2. Remove Waveforms
	rm -f *.vcd
	
	# 3. Clean Standard Software (sw/)
	$(MAKE) -C sw clean
	
	# 4. Clean Regression Artifacts (dv/tests/bin/)
	rm -rf dv/tests/bin/*.elf dv/tests/bin/*.bin dv/tests/bin/*.hex
	
	# 5. Remove the root program.hex if it exists
	rm -f sw/program.hex

	

# Run all tests
regression:
	python3 dv/tests/scripts/run_regression.py

.PHONY: all hw sw sim sanity regression clean
