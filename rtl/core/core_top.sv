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
    logic [4:0]  ex_rs1_addr;
    logic [4:0]  ex_rs2_addr;
    logic [63:0] alu_result;

    // EX/MEM Pipeline Signals
    logic [63:0] mem_alu_result;
    logic [63:0] mem_rs2_data;
    logic [4:0]  mem_rd_addr;
    logic        mem_reg_write;

    // Forwarding Signals
    logic [63:0] alu_operand_a;
    logic [63:0] alu_operand_b_raw;
    logic [63:0] alu_operand_b;

    // WB Stage Signals
    logic [63:0] wb_alu_result;
    logic [63:0] wb_mem_data;
    logic [63:0] wb_final_data;
    logic [4:0]  wb_rd_addr;
    logic        wb_reg_write;
    logic        wb_mem_to_reg;

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
        .alu_op_o   (dec_alu_op),
        .reg_write_o(dec_reg_write),
        .alu_src_o  (dec_alu_src),
        .imm_o      (dec_imm)
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
        .rs1_addr_i  (dec_rs1),   
        .rs2_addr_i  (dec_rs2),  
        .rd_addr_i   (dec_rd),
        .alu_op_i    (dec_alu_op),
        .reg_write_i (dec_reg_write),
        .alu_src_i   (dec_alu_src),
        
        .rs1_data_o  (ex_rs1_data),
        .rs2_data_o  (ex_rs2_data),
        .imm_o       (ex_imm),
        .rs1_addr_o  (ex_rs1_addr), 
        .rs2_addr_o  (ex_rs2_addr), 
        .rd_addr_o   (ex_rd_addr),
        .alu_op_o    (ex_alu_op),
        .reg_write_o (ex_reg_write),
        .alu_src_o   (ex_alu_src)
    );

    // ---------------------------------------------------------
    // FORWARDING LOGIC
    // ---------------------------------------------------------
    // Operand A
    always_comb begin
        if (mem_reg_write && (mem_rd_addr != 0) && (mem_rd_addr == ex_rs1_addr)) begin
            alu_operand_a = mem_alu_result; // Forward from MEM
        end else if (wb_reg_write && (wb_rd_addr != 0) && (wb_rd_addr == ex_rs1_addr)) begin
            alu_operand_a = wb_final_data;  // Forward from WB
        end else begin
            alu_operand_a = ex_rs1_data;    // No Hazard
        end
    end

    // Operand B
    always_comb begin
        if (mem_reg_write && (mem_rd_addr != 0) && (mem_rd_addr == ex_rs2_addr)) begin
            alu_operand_b_raw = mem_alu_result; // Forward from MEM
        end else if (wb_reg_write && (wb_rd_addr != 0) && (wb_rd_addr == ex_rs2_addr)) begin
            alu_operand_b_raw = wb_final_data;  // Forward from WB
        end else begin
            alu_operand_b_raw = ex_rs2_data;    // No Hazard
        end
    end

    // ---------------------------------------------------------
    // STAGE 3: EXECUTE
    // ---------------------------------------------------------
    assign alu_operand_b = (ex_alu_src) ? ex_imm : alu_operand_b_raw;

    alu u_alu (
        .alu_op_i (ex_alu_op),
        .op_a_i   (alu_operand_a),
        .op_b_i   (alu_operand_b),
        .result_o (alu_result)
    );

    // ---------------------------------------------------------
    // PIPELINE: EX -> MEM
    // ---------------------------------------------------------
    ex_mem_reg u_ex_mem (
        .clk          (clk),
        .rst_n        (rst_n),
        .alu_result_i (alu_result),
        .rs2_data_i   (ex_rs2_data),
        .rd_addr_i    (ex_rd_addr),
        .reg_write_i  (ex_reg_write),
        
        .alu_result_o (mem_alu_result),
        .rs2_data_o   (mem_rs2_data),
        .rd_addr_o    (mem_rd_addr),
        .reg_write_o  (mem_reg_write)
    );

    // ---------------------------------------------------------
    // PIPELINE: MEM -> WB
    // ---------------------------------------------------------
    mem_wb_reg u_mem_wb (
        .clk          (clk),
        .rst_n        (rst_n),
        .alu_result_i (mem_alu_result),
        .mem_data_i   (64'b0),
        .rd_addr_i    (mem_rd_addr),
        .reg_write_i  (mem_reg_write),
        .mem_to_reg_i (1'b0),

        .alu_result_o (wb_alu_result),
        .mem_data_o   (wb_mem_data),
        .rd_addr_o    (wb_rd_addr),
        .reg_write_o  (wb_reg_write),
        .mem_to_reg_o (wb_mem_to_reg)
    );

    // ---------------------------------------------------------
    // STAGE 5: WRITEBACK
    // ---------------------------------------------------------
    assign wb_final_data = (wb_mem_to_reg) ? wb_mem_data : wb_alu_result;

    regfile u_regfile (
        .clk        (clk),
        .rst_n      (rst_n),
        .rs1_addr_i (dec_rs1),
        .rs1_data_o (reg_rs1_data),
        .rs2_addr_i (dec_rs2),
        .rs2_data_o (reg_rs2_data),
        
        // Write Port (Stage 5)
        .rd_addr_i  (wb_rd_addr),
        .rd_data_i  (wb_final_data),
        .rd_wen_i   (wb_reg_write)
    );

    // ---------------------------------------------------------
    // OUTPUTS & UNUSED
    // ---------------------------------------------------------
    assign imem_addr = fetch_addr;
    
    assign dmem_addr  = 64'b0;
    assign dmem_wdata = 64'b0;
    assign dmem_wen   = 1'b0;

    /* verilator lint_off UNUSED */
    logic [31:0] unused_imem;
    logic [63:0] unused_dmem;
    logic [63:0] unused_pc, unused_id_pc;
    logic [63:0] unused_rs2_data;
    assign unused_imem = imem_rdata;
    assign unused_dmem = dmem_rdata;
    assign unused_pc   = current_pc;
    assign unused_id_pc = id_pc;
    assign unused_rs2_data = mem_rs2_data;
    /* verilator lint_on UNUSED */

endmodule