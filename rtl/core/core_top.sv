module core_top 
    import riscv_pkg::*; 
(
    input  logic        clk,
    input  logic        rst_n,

    output logic [63:0] imem_addr,
    input  logic [31:0] imem_rdata,
    
    output logic [63:0] dmem_addr,
    output logic [63:0] dmem_wdata,
    output logic        dmem_wen,
    input  logic [63:0] dmem_rdata
);

    // ---------------------------------------------------------
    // Wires
    // ---------------------------------------------------------
    logic [63:0] current_pc;
    logic [63:0] fetch_addr;
    logic [31:0] raw_instr;

    // IF/ID signals
    logic [63:0] id_pc;
    logic [31:0] id_instr;

    // Decode Signals
    logic [4:0]  dec_rs1;
    logic [4:0]  dec_rs2;
    logic [4:0]  dec_rd;
    logic [63:0] dec_imm;
    alu_op_t     dec_alu_op;
    logic        dec_reg_write;
    logic        dec_alu_src;

    // Regfile Outputs
    logic [63:0] reg_rs1_data;
    logic [63:0] reg_rs2_data;

    // ID/EX Pipeline Signals
    logic [63:0] ex_rs1_data;
    logic [63:0] ex_rs2_data;
    logic [63:0] ex_imm;
    logic [4:0]  ex_rd_addr;
    alu_op_t     ex_alu_op;
    logic        ex_reg_write;
    logic        ex_alu_src;

    // ALU Signals
    logic [63:0] alu_operand_b;
    logic [63:0] alu_result;

    // ---------------------------------------------------------
    // STAGE 1: FETCH
    // ---------------------------------------------------------
    fetch u_fetch (
        .clk             (clk),
        .rst_n           (rst_n),
        .branch_target_i (64'b0),
        .branch_taken_i  (1'b0),
        .imem_addr_o     (fetch_addr),
        .pc_out_o        (current_pc)
    );

    rom_sim u_rom (
        .addr_i (fetch_addr),
        .data_o (raw_instr)
    );

    // ---------------------------------------------------------
    // PIPELINE: IF -> ID
    // ---------------------------------------------------------
    if_id_reg u_if_id (
        .clk      (clk),
        .rst_n    (rst_n),
        .stall_i  (1'b0),
        .flush_i  (1'b0),
        .pc_i     (current_pc),
        .instr_i  (raw_instr),
        .pc_o     (id_pc),
        .instr_o  (id_instr)
    );

    // ---------------------------------------------------------
    // STAGE 2: DECODE
    // ---------------------------------------------------------
    decode u_decode (
        .instr_i    (id_instr),
        
        .rs1_addr_o (dec_rs1),
        .rs2_addr_o (dec_rs2),
        .rd_addr_o  (dec_rd),
        
        // Control Signals
        .alu_op_o   (dec_alu_op),
        .reg_write_o(dec_reg_write),
        .alu_src_o  (dec_alu_src),
        .imm_o      (dec_imm)
    );

    // ---------------------------------------------------------
    // REGISTER FILE (Read)
    // ---------------------------------------------------------
    regfile u_regfile (
        .clk        (clk),
        .rst_n      (rst_n),
        .rs1_addr_i (dec_rs1),
        .rs1_data_o (reg_rs1_data),
        .rs2_addr_i (dec_rs2),
        .rs2_data_o (reg_rs2_data),
        
        // Write Port (Temporary: Loopback for testing)
        // In real 5-stage, this comes from WB stage! 
        // For M1, we wire ALU result directly back (SHORTCUT for testing)
        .rd_addr_i  (ex_rd_addr),
        .rd_data_i  (alu_result),
        .rd_wen_i   (ex_reg_write)
    );

    // ---------------------------------------------------------
    // PIPELINE: ID -> EX
    // ---------------------------------------------------------
    id_ex_reg u_id_ex (
        .clk         (clk),
        .rst_n       (rst_n),
        
        .rs1_data_i  (reg_rs1_data),
        .rs2_data_i  (reg_rs2_data),
        .imm_i       (dec_imm),
        .rd_addr_i   (dec_rd),
        .alu_op_i    (dec_alu_op),
        .reg_write_i (dec_reg_write),
        .alu_src_i   (dec_alu_src),
        
        .rs1_data_o  (ex_rs1_data),
        .rs2_data_o  (ex_rs2_data),
        .imm_o       (ex_imm),
        .rd_addr_o   (ex_rd_addr),
        .alu_op_o    (ex_alu_op),
        .reg_write_o (ex_reg_write),
        .alu_src_o   (ex_alu_src)
    );

    // ---------------------------------------------------------
    // STAGE 3: EXECUTE
    // ---------------------------------------------------------
    
    // MUX: Select Register 2 or Immediate
    assign alu_operand_b = (ex_alu_src) ? ex_imm : ex_rs2_data;

    alu u_alu (
        .alu_op_i (ex_alu_op),
        .op_a_i   (ex_rs1_data),
        .op_b_i   (alu_operand_b),
        .result_o (alu_result)
    );

    // ---------------------------------------------------------
    // OUTPUTS & UNUSED
    // ---------------------------------------------------------
    assign imem_addr = fetch_addr;
    
    // Clean up unused signals
    assign dmem_addr  = 64'b0;
    assign dmem_wdata = 64'b0;
    assign dmem_wen   = 1'b0;

    /* verilator lint_off UNUSED */
    logic [31:0] unused_imem;
    logic [63:0] unused_dmem;
    logic [63:0] unused_pc, unused_id_pc;
    assign unused_imem = imem_rdata;
    assign unused_dmem = dmem_rdata;
    assign unused_pc   = current_pc;
    assign unused_id_pc = id_pc;
    /* verilator lint_on UNUSED */

endmodule