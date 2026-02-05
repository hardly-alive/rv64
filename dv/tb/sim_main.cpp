#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vcore_top.h"

int main(int argc, char **argv)
{
    Verilated::commandArgs(argc, argv);

    Vcore_top *top = new Vcore_top;

    Verilated::traceEverOn(true);
    VerilatedVcdC *tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("dump.vcd");

    vluint64_t sim_time = 0;

    top->clk = 0;
    top->rst_n = 0;

    while (sim_time < 200)
    {
        if (sim_time < 20)
            top->rst_n = 0;
        else
            top->rst_n = 1;

        top->clk = !top->clk;

        top->eval();

        tfp->dump(sim_time);

        sim_time++;
    }

    top->final();
    tfp->close();

    delete tfp;
    delete top;

    return 0;
}
