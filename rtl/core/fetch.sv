module fetch (
    input  logic        clk,
    input  logic        rst_n,
    
    // -----------------------------------------
    // Control Signals
    // -----------------------------------------
    input  logic [63:0] branch_target_i,
    input  logic        branch_taken_i,
    input  logic        stall_i,        // Hazard Stall Input
    
    // NEW: Trap Interface (Highest Priority)
    input  logic [63:0] trap_target_i,  // Address to jump to (mtvec or mepc)
    input  logic        trap_taken_i,   // Should we take the trap?

    // -----------------------------------------
    // Outputs
    // -----------------------------------------
    output logic [63:0] imem_addr_o,
    output logic [63:0] pc_out_o
);

    logic [63:0] pc_q;
    logic [63:0] pc_next;

    // -----------------------------------------
    // Next PC Logic (Priority Encoder)
    // -----------------------------------------
    always_comb begin
        if (trap_taken_i) begin
            pc_next = trap_target_i;   // Priority 1: Trap or MRET overrides everything
        end else if (branch_taken_i) begin
            pc_next = branch_target_i; // Priority 2: Standard Jump/Branch
        end else if (stall_i) begin
            pc_next = pc_q;            // Priority 3: STALL keeps current PC
        end else begin
            pc_next = pc_q + 64'd4;    // Priority 4: Normal sequential fetch
        end
    end

    // -----------------------------------------
    // PC Register
    // -----------------------------------------
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc_q <= 64'h8000_0000;     // Boot from DRAM start
        end else begin
            pc_q <= pc_next;
        end
    end

    assign imem_addr_o = pc_q;
    assign pc_out_o    = pc_q;

endmodule