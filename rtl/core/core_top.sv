module core_top 
    import riscv_pkg::*; 
(
    input  logic        clk,
    input  logic        rst_n,

    output logic [63:0] imem_addr,
    input  logic [31:0] imem_rdata,
    
    output logic [63:0] dmem_addr,
    output logic [63:0] dmem_wdata,
    output logic        dmem_wen,
    input  logic [63:0] dmem_rdata
);

    // Internal Wires
    logic [63:0] current_pc;
    
    // ---------------------------------------------------------
    // IF Stage: Instruction Fetch
    // ---------------------------------------------------------
    fetch u_fetch (
        .clk             (clk),
        .rst_n           (rst_n),
        
        // For now, we never branch. Tie these to 0.
        .branch_target_i (64'b0),
        .branch_taken_i  (1'b0),

        .imem_addr_o     (imem_addr),
        .pc_out_o        (current_pc)
    );

    // ---------------------------------------------------------
    // TEMP: Keep the unused signal fixes
    // ---------------------------------------------------------
    assign dmem_addr  = 64'b0;
    assign dmem_wdata = 64'b0;
    assign dmem_wen   = 1'b0;

    /* verilator lint_off UNUSED */
    logic [31:0] unused_imem;
    logic [63:0] unused_dmem;
    logic [63:0] unused_pc;      // PC goes nowhere for now
    assign unused_imem = imem_rdata;
    assign unused_dmem = dmem_rdata;
    assign unused_pc   = current_pc;
    /* verilator lint_on UNUSED */

endmodule