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
    output logic        reg_write_o,
    output logic        alu_src_o,   // 0=Reg2, 1=Immediate
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
        // Sign-extend 12-bit immediate to 64-bit
        // {{52{bit}}, 12_bits}
        if (opcode == OP_IMM || opcode == OP_LOAD) begin
            imm_o = {{52{instr_i[31]}}, instr_i[31:20]};
        end else begin
            imm_o = 64'b0; // Default
        end
    end

    // ------------------------------------
    // CONTROL LOGIC
    // ------------------------------------
    always_comb begin
        alu_op_o    = ALU_ADD;
        reg_write_o = 1'b0;
        alu_src_o   = 1'b0; // Default to Register

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
            
            default: begin
                alu_op_o = ALU_ADD;
                reg_write_o = 1'b0;
            end
        endcase
    end
endmodule