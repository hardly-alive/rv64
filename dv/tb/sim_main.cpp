#include "Vcore_top.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

#define TEST_EXIT_ADDR 0xF0000000

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

        // Evaluate Model
        top->eval();

        // We look at the 'dmem' signals coming out of the core.
        // If Write Enable (dmem_wen) is High AND Address matches...
        if (top->dmem_wen && top->dmem_addr == TEST_EXIT_ADDR) {
            
            // Check the data being written
            if (top->dmem_wdata == 1) {
                printf("[SIM] TEST PASSED! (Wrote 1 to 0xF0000000)\n");
                test_passed = true;
            } else {
                printf("[SIM] TEST FAILED! (Wrote %ld to 0xF0000000)\n", top->dmem_wdata);
                test_passed = false;
            }

            fflush(stdout);

            test_finished = true; // Stop the simulation immediately
        }
        // -------------------------------------------------------

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