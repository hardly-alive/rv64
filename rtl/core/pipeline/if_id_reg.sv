module if_id_reg (
    //====================================================
    // Global Signals
    //====================================================
    input  logic        clk,
    input  logic        rst_n,

    //====================================================
    // Pipeline Control
    //====================================================
    input  logic        stall_i, // Freezes pipeline (hold current state)
    input  logic        flush_i, // Flush pipeline (insert NOP)

    //====================================================
    // IF Stage -> ID Stage Inputs
    //====================================================
    input  logic [63:0] pc_i,
    input  logic [31:0] instr_i,

    //====================================================
    // Outputs to Decode Stage (ID Stage)
    //====================================================
    output logic [63:0] pc_o,
    output logic [31:0] instr_o
);

    //====================================================
    // IF/ID Pipeline Register
    // - Reset: clears state + inserts NOP
    // - Flush: clears state + inserts NOP
    // - Stall: holds previous state
    // - Normal: passes PC + instruction forward
    //====================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc_o    <= 64'b0;
            instr_o <= 32'h0000_0013; // NOP (ADDI x0, x0, 0)

        end else if (flush_i) begin
            pc_o    <= 64'b0;
            instr_o <= 32'h0000_0013; // NOP injected

        end else if (!stall_i) begin
            pc_o    <= pc_i;
            instr_o <= instr_i;

        end
        // stall_i == 1 --> hold current values
    end

endmodule
