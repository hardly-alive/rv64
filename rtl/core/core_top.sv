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
    // Stall/Flush Signals
    logic stall_hazard; // From Hazard Unit
    logic stall_mul;    // From Multiplier
    logic stall_global; // OR of all stalls
    logic flush_ex;     // From Hazard Unit
    logic flush_mem;    // From Multiplier (to insert bubble in MEM)
    logic stall_id;

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
    lsu_op_t     dec_lsu_op;
    branch_op_t  dec_branch_op;
    mul_op_t     dec_mul_op;     // NEW
    logic        dec_reg_write;
    logic        dec_alu_src;
    logic        dec_mem_write;
    logic        dec_mem_read;   
    logic        dec_mem_to_reg;
    logic        dec_is_jump;
    logic        dec_is_jalr;
    logic        dec_is_lui;     
    logic        dec_is_auipc;   

    // Regfile Outputs
    logic [63:0] reg_rs1_data;
    logic [63:0] reg_rs2_data;

    // ID/EX Pipeline Signals
    logic [63:0] ex_pc;
    logic [31:0] ex_instr;
    logic [63:0] ex_rs1_data;
    logic [63:0] ex_rs2_data;
    logic [63:0] ex_imm;
    logic [4:0]  ex_rd_addr;
    alu_op_t     ex_alu_op;
    lsu_op_t     ex_lsu_op;
    branch_op_t  ex_branch_op;
    mul_op_t     ex_mul_op;      // NEW
    logic        ex_reg_write;
    logic        ex_alu_src;
    logic        ex_mem_write;
    logic        ex_mem_read;    
    logic        ex_mem_to_reg;
    logic        ex_is_jump;
    logic        ex_is_jalr;
    logic        ex_is_lui;      
    logic        ex_is_auipc;    

    // ALU/Branch/Mul Signals
    logic [4:0]  ex_rs1_addr;
    logic [4:0]  ex_rs2_addr;
    logic [63:0] alu_result;
    logic [63:0] mul_result;     // NEW
    logic [63:0] final_ex_result;// NEW (Mux between ALU and MUL)
    logic [63:0] branch_target;
    logic        branch_taken;
    logic        pc_redirect;

    // Forwarding Signals
    logic [63:0] alu_operand_a;
    logic [63:0] alu_operand_b_raw;

    // EX/MEM Signals
    logic [63:0] mem_pc;    
    logic [31:0] mem_instr; 
    logic [63:0] mem_alu_result;
    logic [63:0] mem_store_data;
    logic [4:0]  mem_rd_addr;
    logic        mem_reg_write;
    lsu_op_t     mem_lsu_op;
    logic        mem_mem_write;
    logic        mem_mem_read;
    logic        mem_mem_to_reg;
    
    // LSU/WB Signals
    logic [63:0] lsu_rdata;
    logic [63:0] lsu_final_data;
    logic        mem_req;
    logic        mem_we;
    logic [7:0]  mem_be;
    logic [63:0] wb_pc;
    logic [31:0] wb_instr;     
    logic [63:0] wb_alu_result;
    logic [63:0] wb_mem_data;
    logic [63:0] wb_final_data;
    logic [4:0]  wb_rd_addr;
    logic        wb_reg_write;
    logic        wb_mem_to_reg;

    // ---------------------------------------------------------
    // STALL LOGIC
    // ---------------------------------------------------------
    assign stall_global = stall_hazard | stall_mul; 
    assign flush_mem    = stall_mul; // If multiplying, insert bubbles into MEM

    // ---------------------------------------------------------
    // STAGE 1: FETCH
    // ---------------------------------------------------------
    fetch u_fetch (
        .clk             (clk),
        .rst_n           (rst_n),
        .branch_target_i (branch_target),
        .branch_taken_i  (pc_redirect),
        .stall_i         (stall_global), // Freeze PC
        .imem_addr_o     (fetch_addr),
        .pc_out_o        (current_pc)
    );

    rom_sim u_ram (
        .clk         (clk),
        .addr_i      (fetch_addr),
        .data_o      (raw_instr),
        .mem_req_i   (mem_req),
        .mem_we_i    (mem_we),
        .mem_be_i    (mem_be),
        .mem_addr_i  (mem_alu_result),
        .mem_wdata_i (dmem_wdata),
        .mem_rdata_o (lsu_rdata)
    );

    // ---------------------------------------------------------
    // PIPELINE: IF -> ID
    // ---------------------------------------------------------
    if_id_reg u_if_id (
        .clk      (clk),
        .rst_n    (rst_n),
        .stall_i  (stall_global),  // Freeze Instruction
        .flush_i  (pc_redirect),   
        .pc_i     (current_pc),
        .instr_i  (raw_instr),
        .pc_o     (id_pc),
        .instr_o  (id_instr)
    );

    // ---------------------------------------------------------
    // STAGE 2: DECODE
    // ---------------------------------------------------------
    decode u_decode (
        .instr_i      (id_instr),
        .rs1_addr_o   (dec_rs1),
        .rs2_addr_o   (dec_rs2),
        .rd_addr_o    (dec_rd),
        .alu_op_o     (dec_alu_op),
        .lsu_op_o     (dec_lsu_op),
        .branch_op_o  (dec_branch_op),
        .mul_op_o     (dec_mul_op),    // NEW
        .reg_write_o  (dec_reg_write),
        .alu_src_o    (dec_alu_src),
        .mem_write_o  (dec_mem_write),
        .mem_read_o   (dec_mem_read),   
        .mem_to_reg_o (dec_mem_to_reg),
        .is_jump_o    (dec_is_jump),
        .is_jalr_o    (dec_is_jalr),
        .is_lui_o     (dec_is_lui),     
        .is_auipc_o   (dec_is_auipc),   
        .imm_o        (dec_imm)
    );

    // Hazard Unit
    hazard_unit u_hazard (
        .id_rs1_addr_i (dec_rs1),
        .id_rs2_addr_i (dec_rs2),
        .ex_rd_addr_i  (ex_rd_addr),
        .ex_mem_read_i (ex_mem_read),
        .stall_if_o    (stall_hazard), // Separate wire
        .stall_id_o    (stall_id),     // unused, we use stall_global
        .flush_ex_o    (flush_ex)
    );

    // ---------------------------------------------------------
    // PIPELINE: ID -> EX
    // ---------------------------------------------------------
    id_ex_reg u_id_ex (
        .clk          (clk),
        .rst_n        (rst_n),
        .flush_i      (pc_redirect || flush_ex),
        .stall_i      (stall_global),

        .pc_i         (id_pc),
        .instr_i      (id_instr),      //new:
        .rs1_data_i   (reg_rs1_data),
        .rs2_data_i   (reg_rs2_data),
        .imm_i        (dec_imm),
        .rs1_addr_i   (dec_rs1),
        .rs2_addr_i   (dec_rs2),
        .rd_addr_i    (dec_rd),
        .alu_op_i     (dec_alu_op),
        .lsu_op_i     (dec_lsu_op),
        .branch_op_i  (dec_branch_op),
        .mul_op_i     (dec_mul_op),
        .reg_write_i  (dec_reg_write),
        .alu_src_i    (dec_alu_src),
        .mem_write_i  (dec_mem_write),
        .mem_read_i   (dec_mem_read),
        .mem_to_reg_i (dec_mem_to_reg),
        .is_jump_i    (dec_is_jump),
        .is_jalr_i    (dec_is_jalr),
        .is_lui_i     (dec_is_lui),
        .is_auipc_i   (dec_is_auipc),

        .pc_o         (ex_pc),
        .instr_o      (ex_instr),
        .rs1_data_o   (ex_rs1_data),
        .rs2_data_o   (ex_rs2_data),
        .imm_o        (ex_imm),
        .rs1_addr_o   (ex_rs1_addr),
        .rs2_addr_o   (ex_rs2_addr),
        .rd_addr_o    (ex_rd_addr),
        .alu_op_o     (ex_alu_op),
        .lsu_op_o     (ex_lsu_op),
        .branch_op_o  (ex_branch_op),
        .mul_op_o     (ex_mul_op),
        .reg_write_o  (ex_reg_write),
        .alu_src_o    (ex_alu_src),
        .mem_write_o  (ex_mem_write),
        .mem_read_o   (ex_mem_read),
        .mem_to_reg_o (ex_mem_to_reg),
        .is_jump_o    (ex_is_jump),
        .is_jalr_o    (ex_is_jalr),
        .is_lui_o     (ex_is_lui),
        .is_auipc_o   (ex_is_auipc)
    );


    // ---------------------------------------------------------
    // FORWARDING & OPERANDS
    // ---------------------------------------------------------
    always_comb begin
        if (mem_reg_write && (mem_rd_addr != 0) && (mem_rd_addr == ex_rs1_addr)) begin
             if (mem_mem_to_reg) alu_operand_a = lsu_final_data;
             else                alu_operand_a = mem_alu_result;
        end else if (wb_reg_write && (wb_rd_addr != 0) && (wb_rd_addr == ex_rs1_addr)) begin
             alu_operand_a = wb_final_data;
        end else begin
             alu_operand_a = ex_rs1_data;
        end
    end

    always_comb begin
        if (mem_reg_write && (mem_rd_addr != 0) && (mem_rd_addr == ex_rs2_addr)) begin
             if (mem_mem_to_reg) alu_operand_b_raw = lsu_final_data;
             else                alu_operand_b_raw = mem_alu_result;
        end else if (wb_reg_write && (wb_rd_addr != 0) && (wb_rd_addr == ex_rs2_addr)) begin
             alu_operand_b_raw = wb_final_data;
        end else begin
             alu_operand_b_raw = ex_rs2_data;
        end
    end

    // ---------------------------------------------------------
    // STAGE 3: EXECUTE
    // ---------------------------------------------------------
    
    // Branch Unit
    branch_comp u_branch (
        .branch_op_i    (ex_branch_op),
        .op_a_i         (alu_operand_a),
        .op_b_i         (alu_operand_b_raw),
        .branch_taken_o (branch_taken)
    );
    assign branch_target = ex_is_jalr ? ((alu_operand_a + ex_imm) & ~64'd1) : (ex_pc + ex_imm);
    assign pc_redirect = branch_taken || ex_is_jump || ex_is_jalr;

    // ALU Input Muxing
    logic [63:0] alu_final_a;
    logic [63:0] alu_final_b;

    always_comb begin
        if (ex_is_jump) begin
            alu_final_a = ex_pc;
            alu_final_b = 64'd4;
        end else if (ex_is_lui) begin
            alu_final_a = 64'b0; 
            alu_final_b = ex_imm;
        end else if (ex_is_auipc) begin
            alu_final_a = ex_pc; 
            alu_final_b = ex_imm;
        end else begin
            alu_final_a = alu_operand_a;
            alu_final_b = (ex_alu_src) ? ex_imm : alu_operand_b_raw;
        end
    end

    alu u_alu (
        .alu_op_i (ex_alu_op),
        .op_a_i   (alu_final_a),
        .op_b_i   (alu_final_b),
        .result_o (alu_result)
    );

    // Multiplier Unit
    multiplier u_multiplier (
        .clk         (clk),
        .rst_n       (rst_n),
        .mul_op_i    (ex_mul_op),
        .op_a_i      (alu_operand_a),
        .op_b_i      (alu_operand_b_raw),
        .result_o    (mul_result),
        .stall_mul_o (stall_mul)
    );

    // MUX: Choose ALU or Multiplier Result
    assign final_ex_result = (ex_mul_op != M_NONE) ? mul_result : alu_result;

    // ---------------------------------------------------------
    // PIPELINE: EX -> MEM
    // ---------------------------------------------------------
    ex_mem_reg u_ex_mem (
        .clk          (clk),
        .rst_n        (rst_n),
        .flush_i      (flush_mem),

        .pc_i         (ex_pc),        //new:
        .instr_i      (ex_instr),     //new:

        .alu_result_i (final_ex_result),
        .store_data_i (alu_operand_b_raw),
        .rd_addr_i    (ex_rd_addr),
        .reg_write_i  (ex_reg_write),
        .lsu_op_i     (ex_lsu_op),
        .mem_write_i  (ex_mem_write),
        .mem_read_i   (ex_mem_read),
        .mem_to_reg_i (ex_mem_to_reg),

        .pc_o         (mem_pc),       //new:
        .instr_o      (mem_instr),    //new:

        .alu_result_o (mem_alu_result),
        .store_data_o (mem_store_data),
        .rd_addr_o    (mem_rd_addr),
        .reg_write_o  (mem_reg_write),
        .lsu_op_o     (mem_lsu_op),
        .mem_write_o  (mem_mem_write),
        .mem_read_o   (mem_mem_read),
        .mem_to_reg_o (mem_mem_to_reg)
    );


    // ---------------------------------------------------------
    // STAGE 4: MEMORY (LSU)
    // ---------------------------------------------------------
    lsu u_lsu (
        .mem_read_i   (mem_mem_read),
        .mem_write_i  (mem_mem_write),
        .lsu_op_i     (mem_lsu_op),
        .addr_i       (mem_alu_result),
        .store_data_i (mem_store_data),
        .load_data_i  (lsu_rdata),
        .mem_req_o    (mem_req),
        .mem_we_o     (mem_we),
        .mem_addr_o   (dmem_addr),
        .mem_wdata_o  (dmem_wdata),
        .mem_be_o     (mem_be),
        .result_o     (lsu_final_data)
    );

    // ---------------------------------------------------------
    // PIPELINE: MEM -> WB
    // ---------------------------------------------------------
    mem_wb_reg u_mem_wb (
        .clk          (clk),
        .rst_n        (rst_n),

        .pc_i         (mem_pc),        //new:
        .instr_i      (mem_instr),     //new:

        .alu_result_i (mem_alu_result),
        .mem_data_i   (lsu_final_data),
        .rd_addr_i    (mem_rd_addr),
        .reg_write_i  (mem_reg_write),
        .mem_to_reg_i (mem_mem_to_reg),

        .pc_o         (wb_pc),         //new:
        .instr_o      (wb_instr),      //new:

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
    // Tracer
    // ---------------------------------------------------------
    tracer u_tracer (
        .clk         (clk),
        .valid_wb_i  (wb_reg_write), 
        .pc_i        (wb_pc),          
        .instr_i     (wb_instr),      
        .reg_write_i (wb_reg_write),
        .rd_addr_i   (wb_rd_addr),
        .rd_data_i   (wb_final_data)
    );


    // ---------------------------------------------------------
    // OUTPUTS & UNUSED
    // ---------------------------------------------------------
    assign imem_addr = fetch_addr;
    assign dmem_wen  = mem_we;

    /* verilator lint_off UNUSED */
    logic [31:0] unused_imem;
    logic [63:0] unused_dmem;
    logic [63:0] unused_pc, unused_id_pc;
    logic unused_mem_write;
    logic unused_stall_id;
    assign unused_stall_id = stall_id; // Sink this
    assign unused_mem_write = mem_mem_write;
    assign unused_imem = imem_rdata;
    assign unused_dmem = dmem_rdata;
    assign unused_pc   = current_pc;
    assign unused_id_pc = id_pc;
    /* verilator lint_on UNUSED */

endmodule