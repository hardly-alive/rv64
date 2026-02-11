module ex_mem_reg (
    input  logic        clk,
    input  logic        rst_n,

    input  logic [63:0] alu_result_i,
    input  logic [63:0] rs2_data_i, 
    input  logic [4:0]  rd_addr_i,
    input  logic        reg_write_i,

    output logic [63:0] alu_result_o,
    output logic [63:0] rs2_data_o,
    output logic [4:0]  rd_addr_o,
    output logic        reg_write_o
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            alu_result_o <= 64'b0;
            rs2_data_o   <= 64'b0;
            rd_addr_o    <= 5'b0;
            reg_write_o  <= 1'b0;
        end else begin
            alu_result_o <= alu_result_i;
            rs2_data_o   <= rs2_data_i;
            rd_addr_o    <= rd_addr_i;
            reg_write_o  <= reg_write_i;
        end
    end

endmodule