# Aether-RV64IM

**A High-Performance 5-Stage Pipelined RISC-V Core**

Aether-RV64IM is a synthesizable 64-bit RISC-V processor core written in SystemVerilog. It features a classic 5-stage in-order pipeline, full data forwarding for hazard resolution, and a dual-port AXI4-Lite interface for SoC integration. The core is rigorously verified using a **Synchronous Co-Simulation** strategy against the Berkeley Spike Golden Model.

---

## 🏗 Microarchitecture

* **Pipeline:** 5-Stage (IF, ID, EX, MEM, WB).
* **ISA Support:** RV64I (Base Integer) + M (Hardware Multiply/Divide).
* **Hazard Unit:** * **Forwarding:** `MEM -> EX` and `WB -> EX` stages to minimize stalls.
* **Stalls:** Automatic hardware interlocking for Load-Use hazards.


* **Bus Interface:** Independent Instruction and Data AXI4-Lite Managers.
* **Reset Vector:** `0x80000000`.

---

## 📂 Project Structure

```text
├── rtl/               # Synthesizable RTL
│   ├── core/          # CPU Core Logic (Fetch, Decode, Exec, etc.)
│   ├── include/       # Global Packages & Parameter Definitions
│   └── soc_testing/   # AXI RAM & SoC Wrappers for simulation
├── dv/                # Design Verification
│   ├── tb/            # Verilator C++ Testbench (sim_main.cpp)
│   ├── tests/         # Unit tests and Spike comparison scripts
│   └── riscv-tests-repo/ # Integrated official RISC-V ISA tests
├── sw/                # Linker scripts and boot code
└── Dockerfile         # Portable toolchain environment

```

---

## ⚖️ Verification Strategy

This core uses a dual-layered verification approach to ensure 100% architectural compliance:

### 1. Regression Suite

A suite of 74 tests (including official `riscv-tests`) is executed via Verilator. The testbench monitors the `tohost` CSR or a memory-mapped exit address to determine pass/fail status.

### 2. Spike Co-Simulation

For deep architectural validation, the core is compared line-by-line against **Spike**.

* **Tracer:** A hardware monitor (`tracer.sv`) captures every retired instruction.
* **Golden Model:** Spike generates an execution trace of the same `.elf`.
* **Comparison:** A Python script synchronizes the two traces, filtering pipeline artifacts (stalls/redundant commits) to verify that Program Counters and Register file updates match perfectly.

---

## 🚀 Quick Start (Docker)

Ensure Docker is installed, then run the full verification suite with a single command:

```bash
# Build the environment
docker build -t riscv-lab .

# Run the 74-test regression
docker run --rm -v $(pwd):/work riscv-lab make regression

# Run a specific Spike Co-Simulation
docker run --rm -v $(pwd):/work riscv-lab make spike TEST=alu_test

```

---

## 🛠 Prerequisites (Local Install)

If running without Docker, you will need:

* **Verilator:** 5.002+
* **RISC-V Toolchain:** `riscv64-unknown-elf-gcc`
* **Spike:** ISA Simulator
* **Python:** 3.8+

---

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

---