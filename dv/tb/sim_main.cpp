#include "Vcore_top.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>

#define TEST_EXIT_ADDR 0xF0000000

double sc_time_stamp() {
    return 0;
}

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    
    // Instantiate the core
    Vcore_top* top = new Vcore_top;

    // Enable Waveforms
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("trace.vcd");

    // Initialize Signals
    top->clk = 0;
    top->rst_n = 0;
    
    // Simulation Time
    vluint64_t main_time = 0;
    bool test_passed = false;
    bool test_finished = false;

    // Simulation Loop
    while (!Verilated::gotFinish() && main_time < 100000 && !test_finished) {
        
        // Toggle Clock
        if (main_time % 10 == 0) top->clk = !top->clk;
        
        // Release Reset after a few cycles
        if (main_time > 50) top->rst_n = 1;

        // ----------------------------------------------------
        // 1. Dummy Bus Responses (Prevent Stalls & X-States)
        // ----------------------------------------------------
        // Since we deleted the RAM, we must tie off the memory inputs.
        // If we don't, the CPU's new stall logic will freeze it forever!
        // For now, we instantly grant requests and feed it NOPs.
        top->ibus_gnt_i    = 1;
        top->ibus_rvalid_i = 1;
        top->ibus_rdata_i  = 0x00000013; // RISC-V NOP (addi x0, x0, 0)

        top->dbus_gnt_i    = 1;
        top->dbus_rvalid_i = 1;
        top->dbus_rdata_i  = 0;

        // Evaluate Model
        top->eval();

        // ----------------------------------------------------
        // 2. Check for Test Exit (Using Generic Bus Pins)
        // ----------------------------------------------------
        // We look at the 'dbus' signals coming out of the core.
        // If Request is High AND Write Enable is High AND Address matches...
        if (top->dbus_req_o && top->dbus_we_o && top->dbus_addr_o == TEST_EXIT_ADDR) {
            
            // Check the data being written
            if (top->dbus_wdata_o == 1) {
                printf("[SIM] TEST PASSED! (Wrote 1 to 0xF0000000)\n");
                test_passed = true;
            } else {
                printf("[SIM] TEST FAILED! (Wrote %ld to 0xF0000000)\n", top->dbus_wdata_o);
                test_passed = false;
            }

            fflush(stdout);
            test_finished = true; // Stop the simulation immediately
        }

        // Dump Waveform
        tfp->dump(main_time);
        main_time++;
    }

    // Cleanup
    top->final();
    tfp->close();
    delete top;
    
    // Return exit code to the Operating System (for Python script)
    // 0 = Success (Pass), 1 = Failure (Fail)
    return test_passed ? 0 : 1;
}