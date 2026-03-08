#include "Vsoc_top.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>

double sc_time_stamp() { return 0; }

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    
    Vsoc_top* top = new Vsoc_top;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("trace.vcd");

    top->clk = 0;
    top->rst_n = 0;
    
    vluint64_t main_time = 0;
    bool test_passed = false;

    while (!Verilated::gotFinish() && main_time < 500000) {
        if (main_time % 10 == 0) top->clk = !top->clk;
        if (main_time > 50) top->rst_n = 1;

        top->eval();

        // Check Hardware Snoop Pins
        if (top->sim_exit_o) {
            // RISC-V tohost standard: 
            // Least significant bit = 1 means exit.
            // (Status >> 1) is the actual exit code.
            if (top->sim_pass_o) {
                printf("[SIM] EXIT DETECTED at %ld ns\n", main_time);
                printf("[SIM] TEST PASSED!\n");
                test_passed = true;
            } else {
                printf("[SIM] EXIT DETECTED at %ld ns\n", main_time);
                printf("[SIM] TEST FAILED (Exit Code != 1)\n");
                test_passed = false;
            }
            break; 
        }

        tfp->dump(main_time);
        main_time++;
    }

    if (main_time >= 500000) {
        printf("[SIM] ERROR: TEST TIMEOUT!\n");
    }

    top->final();
    tfp->close();
    delete top;
    
    return test_passed ? 0 : 1;
}