TOP      = core_top
OBJ_DIR  = obj_dir

RTL_DIR  = rtl
TB_DIR   = dv/tb
INC_DIR  = rtl/include

SRCS = $(RTL_DIR)/include/riscv_pkg.sv $(wildcard $(RTL_DIR)/core/*.sv)
CPP_TB   = $(TB_DIR)/sim_main.cpp

VERILATOR_FLAGS = -Wall --cc --exe --trace \
                  --top-module $(TOP) \
                  -I$(INC_DIR)

all: build

build:
	verilator $(VERILATOR_FLAGS) $(SRCS) $(CPP_TB)
	make -C $(OBJ_DIR) -f V$(TOP).mk

sim: build
	./$(OBJ_DIR)/V$(TOP)

clean:
	rm -rf $(OBJ_DIR) *.vcd

.PHONY: all build sim clean
