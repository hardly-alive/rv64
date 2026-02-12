module decode 
    import riscv_pkg::*;
(
    input  logic [31:0] instr_i,

    // To Regfile
    output logic [4:0]  rs1_addr_o,
    output logic [4:0]  rs2_addr_o,
    output logic [4:0]  rd_addr_o,
    
    // To Execute
    output alu_op_t     alu_op_o,
    output lsu_op_t     lsu_op_o, 
    output logic        reg_write_o,
    output logic        alu_src_o,   // 0=Reg2, 1=Immediate
    output logic        mem_write_o, // (1 for Stores)
    output logic        mem_to_reg_o,// (1 for Loads)
    output logic [63:0] imm_o        // The sign-extended immediate
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
            OP_IMM, OP_LOAD:  // I-Type
                imm_o = {{52{instr_i[31]}}, instr_i[31:20]};
            OP_STORE:         // S-Type (Split immediate)
                imm_o = {{52{instr_i[31]}}, instr_i[31:25], instr_i[11:7]};
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
        reg_write_o  = 1'b0;
        alu_src_o    = 1'b0;
        mem_write_o  = 1'b0;
        mem_to_reg_o = 1'b0;

        case (opcode)
            OP_IMM: begin // ADDI, SLTI, etc.
                reg_write_o = 1'b1;
                alu_src_o   = 1'b1; // Use Immediate!
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

            OP_REG: begin // ADD, SUB, etc.
                reg_write_o = 1'b1;
                alu_src_o   = 1'b0; // Use Register!
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
            
            // ---------------------------------
            // LOADS (I-Type)
            // ---------------------------------
            OP_LOAD: begin
                reg_write_o  = 1'b1;
                alu_src_o    = 1'b1; // Address = rs1 + imm
                mem_to_reg_o = 1'b1; // Result comes from Memory
                alu_op_o     = ALU_ADD; // ALU calculates Address
                
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

            // ---------------------------------
            // STORES (S-Type)
            // ---------------------------------
            OP_STORE: begin
                reg_write_o = 1'b0;  // Stores don't write to Register File
                alu_src_o   = 1'b1;  // Address = rs1 + imm
                mem_write_o = 1'b1;  // Write to Memory
                alu_op_o    = ALU_ADD; // ALU calculates Address

                case (funct3)
                    3'b000: lsu_op_o = LSU_SB;
                    3'b001: lsu_op_o = LSU_SH;
                    3'b010: lsu_op_o = LSU_SW;
                    3'b011: lsu_op_o = LSU_SD;
                    default: lsu_op_o = LSU_SD;
                endcase
            end

            default: begin
                reg_write_o = 1'b0;
            end
        endcase
    end

endmodule