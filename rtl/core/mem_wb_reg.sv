module mem_wb_reg (
    //====================================================
    // Global Signals
    //====================================================
    input  logic        clk,
    input  logic        rst_n,

    //====================================================
    // Inputs from MEM Stage (Trace / Spike Alignment)
    //====================================================
    input  logic [63:0] pc_i,        //new:
    input  logic [31:0] instr_i,     //new:

    //====================================================
    // Inputs from MEM Stage (Datapath Results)
    //====================================================
    input  logic [63:0] alu_result_i,
    input  logic [63:0] mem_data_i,

    //====================================================
    // Inputs from MEM Stage (Writeback Control)
    //====================================================
    input  logic [4:0]  rd_addr_i,
    input  logic        reg_write_i,
    input  logic        mem_to_reg_i,

    //====================================================
    // Outputs to WB Stage (Trace / Spike Alignment)
    //====================================================
    output logic [63:0] pc_o,        //new:
    output logic [31:0] instr_o,     //new:

    //====================================================
    // Outputs to WB Stage (Datapath Results)
    //====================================================
    output logic [63:0] alu_result_o,
    output logic [63:0] mem_data_o,

    //====================================================
    // Outputs to WB Stage (Writeback Control)
    //====================================================
    output logic [4:0]  rd_addr_o,
    output logic        reg_write_o,
    output logic        mem_to_reg_o
);

    //====================================================
    // MEM/WB Pipeline Register
    // - Reset  : clears WB stage state
    // - Normal : passes MEM stage results into WB stage
    //====================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Trace
            pc_o         <= 64'b0;           
            instr_o      <= 32'h0000_0013;   //new: NOP

            // Datapath
            alu_result_o <= 64'b0;
            mem_data_o   <= 64'b0;

            // Writeback control
            rd_addr_o    <= 5'b0;
            reg_write_o  <= 1'b0;
            mem_to_reg_o <= 1'b0;

        end else begin
            // Trace
            pc_o         <= pc_i;            //new:
            instr_o      <= instr_i;         //new:

            // Datapath
            alu_result_o <= alu_result_i;
            mem_data_o   <= mem_data_i;

            // Writeback control
            rd_addr_o    <= rd_addr_i;
            reg_write_o  <= reg_write_i;
            mem_to_reg_o <= mem_to_reg_i;
        end
    end

endmodule
