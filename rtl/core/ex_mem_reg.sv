module ex_mem_reg 
    import riscv_pkg::*;
(
    input  logic        clk,
    input  logic        rst_n,
    input  logic        flush_i,      // NEW: Bubble injection

    input  logic [63:0] alu_result_i,
    input  logic [63:0] store_data_i,
    input  logic [4:0]  rd_addr_i,
    input  logic        reg_write_i,
    input  lsu_op_t     lsu_op_i,
    input  logic        mem_write_i,
    input  logic        mem_to_reg_i,

    output logic [63:0] alu_result_o,
    output logic [63:0] store_data_o,
    output logic [4:0]  rd_addr_o,
    output logic        reg_write_o,
    output lsu_op_t     lsu_op_o,
    output logic        mem_write_o,
    output logic        mem_to_reg_o
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n || flush_i) begin // Reset or Flush -> NOP
            alu_result_o <= 64'b0;
            store_data_o <= 64'b0;
            rd_addr_o    <= 5'b0;
            reg_write_o  <= 1'b0;
            lsu_op_o     <= LSU_NONE;
            mem_write_o  <= 1'b0;
            mem_to_reg_o <= 1'b0;
        end else begin
            alu_result_o <= alu_result_i;
            store_data_o <= store_data_i;
            rd_addr_o    <= rd_addr_i;
            reg_write_o  <= reg_write_i;
            lsu_op_o     <= lsu_op_i;
            mem_write_o  <= mem_write_i;
            mem_to_reg_o <= mem_to_reg_i;
        end
    end

endmodule