module mem_wb_reg (
    input  logic        clk,
    input  logic        rst_n,

    // Inputs from MEM Stage
    input  logic [63:0] alu_result_i,
    input  logic [63:0] mem_data_i,
    input  logic [4:0]  rd_addr_i,
    input  logic        reg_write_i,
    input  logic        mem_to_reg_i,

    // Outputs to WB Stage (THESE MUST BE OUTPUTS)
    output logic [63:0] alu_result_o,
    output logic [63:0] mem_data_o,
    output logic [4:0]  rd_addr_o,
    output logic        reg_write_o,
    output logic        mem_to_reg_o
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            alu_result_o <= 64'b0;
            mem_data_o   <= 64'b0;
            rd_addr_o    <= 5'b0;
            reg_write_o  <= 1'b0;
            mem_to_reg_o <= 1'b0;
        end else begin
            alu_result_o <= alu_result_i;
            mem_data_o   <= mem_data_i;
            rd_addr_o    <= rd_addr_i;
            reg_write_o  <= reg_write_i;
            mem_to_reg_o <= mem_to_reg_i;
        end
    end

endmodule