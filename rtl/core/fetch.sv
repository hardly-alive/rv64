module fetch (
    input  logic        clk,
    input  logic        rst_n,
    
    // Control Signals
    input  logic [63:0] branch_target_i,
    input  logic        branch_taken_i,
    input  logic        stall_i,        // NEW: Hazard Stall Input

    // Outputs
    output logic [63:0] imem_addr_o,
    output logic [63:0] pc_out_o
);

    logic [63:0] pc_q;
    logic [63:0] pc_next;

    // Next PC Logic
    always_comb begin
        if (branch_taken_i) begin
            pc_next = branch_target_i; // Jump/Branch
        end else if (stall_i) begin
            pc_next = pc_q;            // STALL: Keep current PC
        end else begin
            pc_next = pc_q + 64'd4;    // Normal: PC + 4
        end
    end

    // PC Register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc_q <= 64'b0;
        end else begin
            pc_q <= pc_next;
        end
    end

    assign imem_addr_o = pc_q;
    assign pc_out_o    = pc_q;

endmodule