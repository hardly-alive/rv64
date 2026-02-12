module decode 
    import riscv_pkg::*;
(
    input  logic [31:0] instr_i,

    output logic [4:0]  rs1_addr_o,
    output logic [4:0]  rs2_addr_o,
    output logic [4:0]  rd_addr_o,
    
    output alu_op_t     alu_op_o,
    output lsu_op_t     lsu_op_o,
    output branch_op_t  branch_op_o,
    output logic        reg_write_o,
    output logic        alu_src_o,
    output logic        mem_write_o,
    output logic        mem_to_reg_o,
    output logic        mem_read_o,  // NEW: For Hazard Detection
    output logic        is_jump_o,
    output logic        is_jalr_o,
    output logic        is_lui_o,    // NEW: Op A = 0
    output logic        is_auipc_o,  // NEW: Op A = PC
    output logic [63:0] imm_o
);

    opcode_t    opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    assign opcode     = opcode_t'(instr_i[6:0]);
    assign rd_addr_o  = instr_i[11:7];
    assign funct3     = instr_i[14:12];
    assign rs1_addr_o = instr_i[19:15];
    assign rs2_addr_o = instr_i[24:20];
    assign funct7     = instr_i[31:25];

    /* verilator lint_off UNUSED */
    logic [6:0] unused_funct7;
    assign unused_funct7 = funct7;
    /* verilator lint_on UNUSED */

    // ------------------------------------
    // IMMEDIATE GENERATION
    // ------------------------------------
    always_comb begin
        case (opcode)
            OP_IMM, OP_LOAD, OP_JALR: 
                imm_o = {{52{instr_i[31]}}, instr_i[31:20]};
            OP_STORE: 
                imm_o = {{52{instr_i[31]}}, instr_i[31:25], instr_i[11:7]};
            OP_BRANCH: 
                imm_o = {{51{instr_i[31]}}, instr_i[31], instr_i[7], instr_i[30:25], instr_i[11:8], 1'b0};
            OP_JAL: 
                imm_o = {{43{instr_i[31]}}, instr_i[31], instr_i[19:12], instr_i[20], instr_i[30:21], 1'b0};
            OP_LUI, OP_AUIPC: // U-Type
                imm_o = {{32{instr_i[31]}}, instr_i[31:12], 12'b0};
            default:          
                imm_o = 64'b0;
        endcase
    end

    // ------------------------------------
    // CONTROL LOGIC
    // ------------------------------------
    always_comb begin
        // Defaults
        alu_op_o     = ALU_ADD;
        lsu_op_o     = LSU_NONE;
        branch_op_o  = BRANCH_NONE;
        reg_write_o  = 1'b0;
        alu_src_o    = 1'b0;
        mem_write_o  = 1'b0;
        mem_read_o   = 1'b0; 
        mem_to_reg_o = 1'b0;
        is_jump_o    = 1'b0;
        is_jalr_o    = 1'b0;
        is_lui_o     = 1'b0;
        is_auipc_o   = 1'b0;

        case (opcode)
            OP_IMM: begin
                reg_write_o = 1'b1;
                alu_src_o   = 1'b1;
                case (funct3)
                    3'b000: alu_op_o = ALU_ADD;
                    3'b010: alu_op_o = ALU_SLT;
                    3'b011: alu_op_o = ALU_SLTU;
                    3'b100: alu_op_o = ALU_XOR;
                    3'b110: alu_op_o = ALU_OR;
                    3'b111: alu_op_o = ALU_AND;
                    3'b001: alu_op_o = ALU_SLL;
                    3'b101: alu_op_o = (funct7[5]) ? ALU_SRA : ALU_SRL;
                    default: alu_op_o = ALU_ADD;
                endcase
            end
            OP_REG: begin
                reg_write_o = 1'b1;
                case (funct3)
                    3'b000: alu_op_o = (funct7[5]) ? ALU_SUB : ALU_ADD;
                    3'b001: alu_op_o = ALU_SLL;
                    3'b010: alu_op_o = ALU_SLT;
                    3'b011: alu_op_o = ALU_SLTU;
                    3'b100: alu_op_o = ALU_XOR;
                    3'b101: alu_op_o = (funct7[5]) ? ALU_SRA : ALU_SRL;
                    3'b110: alu_op_o = ALU_OR;
                    3'b111: alu_op_o = ALU_AND;
                    default: alu_op_o = ALU_ADD;
                endcase
            end
            OP_LOAD: begin
                reg_write_o  = 1'b1;
                alu_src_o    = 1'b1;
                mem_to_reg_o = 1'b1;
                mem_read_o   = 1'b1; // This is a Load!
                alu_op_o     = ALU_ADD;
                case (funct3)
                    3'b000: lsu_op_o = LSU_LB;
                    3'b001: lsu_op_o = LSU_LH;
                    3'b010: lsu_op_o = LSU_LW;
                    3'b011: lsu_op_o = LSU_LD;
                    3'b100: lsu_op_o = LSU_LBU;
                    3'b101: lsu_op_o = LSU_LHU;
                    3'b110: lsu_op_o = LSU_LWU;
                    default: lsu_op_o = LSU_LD;
                endcase
            end
            OP_STORE: begin
                alu_src_o   = 1'b1;
                mem_write_o = 1'b1;
                alu_op_o    = ALU_ADD;
                case (funct3)
                    3'b000: lsu_op_o = LSU_SB;
                    3'b001: lsu_op_o = LSU_SH;
                    3'b010: lsu_op_o = LSU_SW;
                    3'b011: lsu_op_o = LSU_SD;
                    default: lsu_op_o = LSU_SD;
                endcase
            end
            OP_BRANCH: begin
                branch_op_o = branch_op_t'(funct3);
            end
            OP_JAL: begin
                reg_write_o = 1'b1;
                is_jump_o   = 1'b1;
            end
            OP_JALR: begin
                reg_write_o = 1'b1;
                is_jump_o   = 1'b1;
                is_jalr_o   = 1'b1;
                alu_src_o   = 1'b1;
                alu_op_o    = ALU_ADD;
            end
            // --- NEW INSTRUCTIONS ---
            OP_LUI: begin
                reg_write_o = 1'b1;
                alu_src_o   = 1'b1; // Use Imm
                is_lui_o    = 1'b1; // Op A = 0
                alu_op_o    = ALU_ADD; // 0 + Imm = Imm
            end
            OP_AUIPC: begin
                reg_write_o = 1'b1;
                alu_src_o   = 1'b1; // Use Imm
                is_auipc_o  = 1'b1; // Op A = PC
                alu_op_o    = ALU_ADD; // PC + Imm
            end
            default: reg_write_o = 1'b0;
        endcase
    end
endmodule