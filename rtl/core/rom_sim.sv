module rom_sim (
    input  logic [63:0] addr_i,
    output logic [31:0] data_o
);
    /* verilator lint_off UNUSED */
    logic [63:0] unused_addr;
    assign unused_addr = addr_i;
    /* verilator lint_on UNUSED */

    logic [31:0] mem [0:1023]; 


    initial begin
        // Reset everything to NOPs
        for (int i=0; i<1024; i++) mem[i] = 32'h0000_0013;

        // 1. ADDI x1, x0, 5
        mem[0] = 32'h00500093; 
        // 2. ADDI x2, x0, 10
        mem[1] = 32'h00a00113;
        // 3. ADD x3, x1, x2  (Should now see 5 + 10)
        mem[2] = 32'h002081b3;
    end

    // 3. Read Logic (Word Aligned)
    // We ignore the bottom 2 bits of address (addr_i[1:0]) because instructions are 4 bytes wide.
    assign data_o = mem[addr_i[11:2]];

endmodule