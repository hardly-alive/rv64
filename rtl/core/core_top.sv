module core_top 
    import riscv_pkg::*; 
(
    input  logic        clk,
    input  logic        rst_n,

    output logic [63:0] imem_addr,
    input  logic [31:0] imem_rdata,
    
    // Data Memory Interface (Now Active!)
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
    lsu_op_t     dec_lsu_op;     // NEW
    logic        dec_reg_write;
    logic        dec_alu_src;
    logic        dec_mem_write;  // NEW
    logic        dec_mem_to_reg; // NEW

    // Regfile Outputs
    logic [63:0] reg_rs1_data;
    logic [63:0] reg_rs2_data;

    // ID/EX Pipeline Signals
    logic [63:0] ex_rs1_data;
    logic [63:0] ex_rs2_data;
    logic [63:0] ex_imm;
    logic [4:0]  ex_rd_addr;
    alu_op_t     ex_alu_op;
    lsu_op_t     ex_lsu_op;      // NEW
    logic        ex_reg_write;
    logic        ex_alu_src;
    logic        ex_mem_write;   // NEW
    logic        ex_mem_to_reg;  // NEW

    // ALU Signals
    logic [4:0]  ex_rs1_addr;
    logic [4:0]  ex_rs2_addr;
    logic [63:0] alu_result;

    // Forwarding Signals
    logic [63:0] alu_operand_a;
    logic [63:0] alu_operand_b_raw;
    logic [63:0] alu_operand_b;

    // EX/MEM Pipeline Signals
    logic [63:0] mem_alu_result;
    logic [63:0] mem_store_data; // Values to be stored
    logic [4:0]  mem_rd_addr;
    logic        mem_reg_write;
    lsu_op_t     mem_lsu_op;     // NEW
    logic        mem_mem_write;  // NEW
    logic        mem_mem_to_reg; // NEW

    // LSU Signals (Memory Stage)
    logic [63:0] lsu_rdata;      // Data from RAM
    logic [63:0] lsu_final_data; // Data formatted by LSU (Load Result)
    logic        mem_req;        // Request to RAM
    logic        mem_we;         // Write Enable to RAM
    logic [7:0]  mem_be;         // Byte Enable

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

    // Using rom_sim as Unified Memory for simplicity
    // Port A: Instruction Fetch
    // Port B: Data Access
    rom_sim u_ram (
        .clk         (clk),
        
        // Port A (Instructions)
        .addr_i      (fetch_addr),
        .data_o      (raw_instr),

        // Port B (Data)
        .mem_req_i   (mem_req),
        .mem_we_i    (mem_we),
        .mem_be_i    (mem_be),
        .mem_addr_i  (mem_alu_result), // Address comes from ALU
        .mem_wdata_i (dmem_wdata),     // Data comes from LSU
        .mem_rdata_o (lsu_rdata)       // Raw data from RAM
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
        .lsu_op_o   (dec_lsu_op),      // NEW
        .reg_write_o(dec_reg_write),
        .alu_src_o  (dec_alu_src),
        .mem_write_o(dec_mem_write),   // NEW
        .mem_to_reg_o(dec_mem_to_reg), // NEW
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
        .lsu_op_i    (dec_lsu_op),     // NEW
        .reg_write_i (dec_reg_write),
        .alu_src_i   (dec_alu_src),
        .mem_write_i (dec_mem_write),  // NEW
        .mem_to_reg_i(dec_mem_to_reg), // NEW
        
        .rs1_data_o  (ex_rs1_data),
        .rs2_data_o  (ex_rs2_data),
        .imm_o       (ex_imm),
        .rs1_addr_o  (ex_rs1_addr), 
        .rs2_addr_o  (ex_rs2_addr), 
        .rd_addr_o   (ex_rd_addr),
        .alu_op_o    (ex_alu_op),
        .lsu_op_o    (ex_lsu_op),      // NEW
        .reg_write_o (ex_reg_write),
        .alu_src_o   (ex_alu_src),
        .mem_write_o (ex_mem_write),   // NEW
        .mem_to_reg_o(ex_mem_to_reg)   // NEW
    );

    // ---------------------------------------------------------
    // FORWARDING LOGIC (Fixed for Load-Use)
    // ---------------------------------------------------------
    // Operand A
    always_comb begin
        if (mem_reg_write && (mem_rd_addr != 0) && (mem_rd_addr == ex_rs1_addr)) begin
            // HAZARD: Data in MEM stage
            if (mem_mem_to_reg) begin
                alu_operand_a = lsu_final_data; // Forward MEMORY DATA (for Loads)
            end else begin
                alu_operand_a = mem_alu_result; // Forward ALU RESULT (for Arithmetic)
            end
        end else if (wb_reg_write && (wb_rd_addr != 0) && (wb_rd_addr == ex_rs1_addr)) begin
            // HAZARD: Data in WB stage
            alu_operand_a = wb_final_data;      // Forward WB Result
        end else begin
            // No Hazard
            alu_operand_a = ex_rs1_data;
        end
    end

    // Operand B
    always_comb begin
        if (mem_reg_write && (mem_rd_addr != 0) && (mem_rd_addr == ex_rs2_addr)) begin
            if (mem_mem_to_reg) begin
                alu_operand_b_raw = lsu_final_data; // Forward MEMORY DATA
            end else begin
                alu_operand_b_raw = mem_alu_result; // Forward ALU RESULT
            end
        end else if (wb_reg_write && (wb_rd_addr != 0) && (wb_rd_addr == ex_rs2_addr)) begin
            alu_operand_b_raw = wb_final_data;
        end else begin
            alu_operand_b_raw = ex_rs2_data;
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
        .store_data_i (alu_operand_b_raw), // <--- CRITICAL: Use Forwarded RS2 for Stores
        .rd_addr_i    (ex_rd_addr),
        .reg_write_i  (ex_reg_write),
        .lsu_op_i     (ex_lsu_op),     // NEW
        .mem_write_i  (ex_mem_write),  // NEW
        .mem_to_reg_i (ex_mem_to_reg), // NEW
        
        .alu_result_o (mem_alu_result),
        .store_data_o (mem_store_data),
        .rd_addr_o    (mem_rd_addr),
        .reg_write_o  (mem_reg_write),
        .lsu_op_o     (mem_lsu_op),    // NEW
        .mem_write_o  (mem_mem_write), // NEW
        .mem_to_reg_o (mem_mem_to_reg) // NEW
    );

    // ---------------------------------------------------------
    // STAGE 4: MEMORY (LSU)
    // ---------------------------------------------------------
    lsu u_lsu (
        .lsu_op_i     (mem_lsu_op),
        .addr_i       (mem_alu_result), // Calculated Address
        .store_data_i (mem_store_data), // Data to store
        .load_data_i  (lsu_rdata),      // Raw data from RAM

        .mem_req_o    (mem_req),
        .mem_we_o     (mem_we),
        .mem_addr_o   (dmem_addr),      // To Top Level (debug)
        .mem_wdata_o  (dmem_wdata),     // To Top Level / RAM
        .mem_be_o     (mem_be),         // To RAM

        .result_o     (lsu_final_data)  // Formatted Load Data
    );

    // ---------------------------------------------------------
    // PIPELINE: MEM -> WB
    // ---------------------------------------------------------
    mem_wb_reg u_mem_wb (
        .clk          (clk),
        .rst_n        (rst_n),
        .alu_result_i (mem_alu_result), // Pass ALU result (for arithmetic ops)
        .mem_data_i   (lsu_final_data), // Pass Load result
        .rd_addr_i    (mem_rd_addr),
        .reg_write_i  (mem_reg_write),
        .mem_to_reg_i (mem_mem_to_reg),

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
        .rd_addr_i  (wb_rd_addr),
        .rd_data_i  (wb_final_data),
        .rd_wen_i   (wb_reg_write)
    );

    // ---------------------------------------------------------
    // OUTPUTS & UNUSED
    // ---------------------------------------------------------
    assign imem_addr = fetch_addr;
    assign dmem_wen  = mem_we; // Output write enable to top level

    /* verilator lint_off UNUSED */
    logic [31:0] unused_imem;
    logic [63:0] unused_dmem;
    logic [63:0] unused_pc, unused_id_pc;
    logic unused_mem_write;         // Add this
    assign unused_mem_write = mem_mem_write; // Add this
    assign unused_imem = imem_rdata;
    assign unused_dmem = dmem_rdata;
    assign unused_pc   = current_pc;
    assign unused_id_pc = id_pc;
    /* verilator lint_on UNUSED */

endmodule