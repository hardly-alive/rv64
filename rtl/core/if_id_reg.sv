module if_id_reg (
    input  logic        clk,
    input  logic        rst_n,

    input  logic        stall_i, // Freezes the pipeline (keep current data)
    input  logic        flush_i, // Clears the pipeline (insert NOP)

    // Inputs from Fetch Stage
    input  logic [63:0] pc_i,
    input  logic [31:0] instr_i,

    // Outputs to Decode Stage
    output logic [63:0] pc_o,
    output logic [31:0] instr_o
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc_o    <= 64'b0;
            instr_o <= 32'h0000_0013; 
        end else if (flush_i) begin
            pc_o    <= 64'b0; 
            instr_o <= 32'h0000_0013;
        end else if (!stall_i) begin
            // Normal Operation: Pass data through
            pc_o    <= pc_i;
            instr_o <= instr_i;
        end
        // If stall_i is 1, we do nothing (keep old values)
    end

endmodule