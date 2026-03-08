# ------------------------------------------------------------------------------
# VARIABLES
# ------------------------------------------------------------------------------
TOP     = soc_top
OBJ_DIR = obj_dir
RTL_DIR = rtl
TB_DIR  = dv/tb
INC_DIR = rtl/include
VSRCS = $(wildcard $(RTL_DIR)/core/*.sv) \
        $(wildcard $(RTL_DIR)/core/pipeline/*.sv) \
        $(wildcard $(RTL_DIR)/core/exec/*.sv) \
        $(wildcard $(RTL_DIR)/core/sys/*.sv) \
        $(wildcard $(RTL_DIR)/core/sim/*.sv) \
        $(wildcard $(RTL_DIR)/soc_testing/*.sv)

SRCS = $(RTL_DIR)/include/riscv_pkg.sv $(VSRCS)
CPP_TB = $(TB_DIR)/sim_main.cpp

VERILATOR_FLAGS = -Wall --cc --exe --trace \
                  --top-module $(TOP) \
                  -I$(INC_DIR)

# Default test for Spike Co-Simulation
TEST ?= alu_test

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
	riscv64-unknown-elf-gcc -mcmodel=medany -march=rv64im -mabi=lp64 -nostdlib -T sw/link.ld -o dv/tests/bin/sanity.elf sw/crt0.s dv/tests/src/sanity_check.c
	riscv64-unknown-elf-objcopy -O binary dv/tests/bin/sanity.elf dv/tests/bin/sanity.bin
	hexdump -v -e '1/4 "%08x\n"' dv/tests/bin/sanity.bin > sw/program.hex
	$(MAKE) hw
	./$(OBJ_DIR)/V$(TOP)

# 5. SPIKE CO-SIMULATION
spike:
	@echo "🔍 Running Spike Co-Simulation for: $(TEST)"
	hexdump -v -e '1/4 "%08x\n"' dv/tests/bin/$(TEST).bin > sw/program.hex
	$(MAKE) hw
	@echo "🚀 Running RTL Simulation..."
	./$(OBJ_DIR)/V$(TOP) > rtl.log
	@COMMITS=$$(grep -c "core.*:" rtl.log); \
	echo "📊 RTL executed $$COMMITS instructions. Running Spike..."; \
	# We run Spike for COMMITS + 100 to account for the bootloader \
	SPIKE_LIMIT=$$(($$COMMITS + 100)); \
	(spike --isa=rv64im -m0x80000000:0x100000,0xf0000000:0x1000 -l --log-commits dv/tests/bin/$(TEST).elf 2>&1 > /dev/null) | head -n $$SPIKE_LIMIT > spike.log || true
	@echo "⚖️  Comparing Traces..."
	python3 dv/tests/scripts/spike_cmp.py rtl.log spike.log

# Cleanup
clean:
	# 1. Remove Hardware Simulation Objects
	rm -rf $(OBJ_DIR)
	
	# 2. Remove Waveforms and Logs
	rm -f *.vcd rtl.log spike.log spike_cmd.txt
	
	# 3. Clean Standard Software (sw/)
	$(MAKE) -C sw clean
	
	# 4. Clean Regression Artifacts (dv/tests/bin/)
	rm -rf dv/tests/bin/*.elf dv/tests/bin/*.bin dv/tests/bin/*.hex
	
	# 5. Remove the root program.hex if it exists
	rm -f sw/program.hex

# Run all tests
regression:
	python3 dv/tests/scripts/run_regression.py

.PHONY: all hw sw sim sanity spike regression clean