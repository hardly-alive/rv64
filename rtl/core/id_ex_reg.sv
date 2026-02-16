module id_ex_reg 
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
    input  logic        flush_i, // Kill instruction (branch/hazard)
    input  logic        stall_i, // Freeze stage (multi-cycle op)

    //====================================================
    // ID Stage -> EX Stage Inputs (Datapath)
    //====================================================
    input  logic [63:0] pc_i,
    input  logic [31:0] instr_i,     //new
    input  logic [63:0] rs1_data_i,
    input  logic [63:0] rs2_data_i,
    input  logic [63:0] imm_i,

    //====================================================
    // Register Address Inputs
    //====================================================
    input  logic [4:0]  rs1_addr_i,
    input  logic [4:0]  rs2_addr_i,
    input  logic [4:0]  rd_addr_i,

    //====================================================
    // EX/LSU Control Inputs
    //====================================================
    input  alu_op_t     alu_op_i,
    input  lsu_op_t     lsu_op_i,
    input  branch_op_t  branch_op_i,
    input  mul_op_t     mul_op_i,

    //====================================================
    // Writeback / Datapath Control Inputs
    //====================================================
    input  logic        reg_write_i,
    input  logic        alu_src_i,
    input  logic        mem_write_i,
    input  logic        mem_read_i,
    input  logic        mem_to_reg_i,

    //====================================================
    // Special Instruction Decode Inputs
    //====================================================
    input  logic        is_jump_i,
    input  logic        is_jalr_i,
    input  logic        is_lui_i,
    input  logic        is_auipc_i,

    //====================================================
    // Outputs to Execute Stage (Datapath)
    //====================================================
    output logic [63:0] pc_o,
    output logic [31:0] instr_o,      //new
    output logic [63:0] rs1_data_o,
    output logic [63:0] rs2_data_o,
    output logic [63:0] imm_o,

    //====================================================
    // Register Address Outputs
    //====================================================
    output logic [4:0]  rs1_addr_o,
    output logic [4:0]  rs2_addr_o,
    output logic [4:0]  rd_addr_o,

    //====================================================
    // EX/LSU Control Outputs
    //====================================================
    output alu_op_t     alu_op_o,
    output lsu_op_t     lsu_op_o,
    output branch_op_t  branch_op_o,
    output mul_op_t     mul_op_o,

    //====================================================
    // Writeback / Datapath Control Outputs
    //====================================================
    output logic        reg_write_o,
    output logic        alu_src_o,
    output logic        mem_write_o,
    output logic        mem_read_o,
    output logic        mem_to_reg_o,

    //====================================================
    // Special Instruction Decode Outputs
    //====================================================
    output logic        is_jump_o,
    output logic        is_jalr_o,
    output logic        is_lui_o,
    output logic        is_auipc_o
);

    //====================================================
    // ID/EX Pipeline Register
    // - Reset/Flush : inject bubble (NOP-like behavior)
    // - Stall       : hold current state
    // - Normal      : pass decoded fields forward
    //====================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n || flush_i) begin
            // Datapath
            pc_o         <= 64'b0;
            instr_o      <= 32'h0000_0013; //new: NOP for Spike alignment
            rs1_data_o   <= 64'b0;
            rs2_data_o   <= 64'b0;
            imm_o        <= 64'b0;

            // Register Addresses
            rs1_addr_o   <= 5'b0;
            rs2_addr_o   <= 5'b0;
            rd_addr_o    <= 5'b0;

            // Control (safe defaults)
            alu_op_o     <= ALU_ADD;
            lsu_op_o     <= LSU_NONE;
            branch_op_o  <= BRANCH_NONE;
            mul_op_o     <= M_NONE;

            reg_write_o  <= 1'b0;
            alu_src_o    <= 1'b0;
            mem_write_o  <= 1'b0;
            mem_read_o   <= 1'b0;
            mem_to_reg_o <= 1'b0;

            // Special instruction flags
            is_jump_o    <= 1'b0;
            is_jalr_o    <= 1'b0;
            is_lui_o     <= 1'b0;
            is_auipc_o   <= 1'b0;

        end else if (stall_i) begin
            // Stall: Hold previous values (no updates)

        end else begin
            // Datapath
            pc_o         <= pc_i;
            instr_o      <= instr_i;       //new: pass instruction forward
            rs1_data_o   <= rs1_data_i;
            rs2_data_o   <= rs2_data_i;
            imm_o        <= imm_i;

            // Register Addresses
            rs1_addr_o   <= rs1_addr_i;
            rs2_addr_o   <= rs2_addr_i;
            rd_addr_o    <= rd_addr_i;

            // Control
            alu_op_o     <= alu_op_i;
            lsu_op_o     <= lsu_op_i;
            branch_op_o  <= branch_op_i;
            mul_op_o     <= mul_op_i;

            reg_write_o  <= reg_write_i;
            alu_src_o    <= alu_src_i;
            mem_write_o  <= mem_write_i;
            mem_read_o   <= mem_read_i;
            mem_to_reg_o <= mem_to_reg_i;

            // Special instruction flags
            is_jump_o    <= is_jump_i;
            is_jalr_o    <= is_jalr_i;
            is_lui_o     <= is_lui_i;
            is_auipc_o   <= is_auipc_i;
        end
    end

endmodule