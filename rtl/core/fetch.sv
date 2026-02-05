module fetch 
    import riscv_pkg::*;    
(
    input  logic        clk,
    input  logic        rst_n,
    
    //Branching instructions from decode stage
    input logic [63:0] branch_target_i,
    input logic        branch_taken_i,

    output logic [63:0] imem_addr_o,
    output logic [63:0] pc_out_o
);

logic [63:0] pc_next;
logic [63:0] pc_curr;

assign pc_next = (branch_taken_i) ? branch_target_i : (pc_curr + 64'd4);

always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc_curr <= 64'h0;
        end else begin
            pc_curr <= pc_next;
        end
end

assign imem_addr_o = pc_curr; // Tell memory which address we want
assign pc_out_o    = pc_curr; // Send current PC down the pipeline

endmodule