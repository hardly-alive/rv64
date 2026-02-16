module ex_mem_reg 
    import riscv_pkg::*;
(
    //====================================================
    // Global Signals
    //====================================================
    input  logic        clk,
    input  logic        rst_n,

    //====================================================
    // Pipeline Control
    //====================================================
    input  logic        flush_i,

    //====================================================
    // Inputs from EX Stage (Trace / Spike Alignment)
    //====================================================
    input  logic [63:0] pc_i,         //new:
    input  logic [31:0] instr_i,      //new:

    //====================================================
    // Inputs from EX Stage (Datapath Results)
    //====================================================
    input  logic [63:0] alu_result_i,
    input  logic [63:0] store_data_i,

    //====================================================
    // Inputs from EX Stage (Register + Control)
    //====================================================
    input  logic [4:0]  rd_addr_i,
    input  logic        reg_write_i,
    input  lsu_op_t     lsu_op_i,
    input  logic        mem_write_i,
    input  logic        mem_read_i,
    input  logic        mem_to_reg_i,

    //====================================================
    // Outputs to MEM Stage (Trace / Spike Alignment)
    //====================================================
    output logic [63:0] pc_o,         //new:
    output logic [31:0] instr_o,      //new:

    //====================================================
    // Outputs to MEM Stage (Datapath Results)
    //====================================================
    output logic [63:0] alu_result_o,
    output logic [63:0] store_data_o,

    //====================================================
    // Outputs to MEM Stage (Register + Control)
    //====================================================
    output logic [4:0]  rd_addr_o,
    output logic        reg_write_o,
    output lsu_op_t     lsu_op_o,
    output logic        mem_write_o,
    output logic        mem_read_o,
    output logic        mem_to_reg_o
);

    //====================================================
    // EX/MEM Pipeline Register
    // - Reset/Flush : inject bubble (kill memory + writeback)
    // - Normal      : pass EX stage outputs into MEM stage
    //====================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Trace
            pc_o         <= 64'b0;           
            instr_o      <= 32'h0000_0013;   //new: NOP

            // Datapath
            alu_result_o <= 64'b0;
            store_data_o <= 64'b0;

            // Control
            rd_addr_o    <= 5'b0;
            reg_write_o  <= 1'b0;
            lsu_op_o     <= LSU_NONE;
            mem_write_o  <= 1'b0;
            mem_read_o   <= 1'b0;
            mem_to_reg_o <= 1'b0;

        end else if (flush_i) begin
            // Flush kills side effects (store/load/writeback)
            pc_o         <= 64'b0;
            instr_o      <= 32'h0000_0013;   //new: NOP

            alu_result_o <= 64'b0;
            store_data_o <= 64'b0;

            rd_addr_o    <= 5'b0;
            reg_write_o  <= 1'b0;
            lsu_op_o     <= LSU_NONE;
            mem_write_o  <= 1'b0;
            mem_read_o   <= 1'b0;
            mem_to_reg_o <= 1'b0;

        end else begin
            // Trace
            pc_o         <= pc_i;            //new:
            instr_o      <= instr_i;         //new:

            // Datapath
            alu_result_o <= alu_result_i;
            store_data_o <= store_data_i;

            // Control
            rd_addr_o    <= rd_addr_i;
            reg_write_o  <= reg_write_i;
            lsu_op_o     <= lsu_op_i;
            mem_write_o  <= mem_write_i;
            mem_read_o   <= mem_read_i;
            mem_to_reg_o <= mem_to_reg_i;
        end
    end

endmodule