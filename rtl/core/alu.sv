module alu 
    import riscv_pkg::*;
(
    input  alu_op_t     alu_op_i,
    input  logic [63:0] op_a_i,
    input  logic [63:0] op_b_i,
    output logic [63:0] result_o
);

    always_comb begin
        result_o = '0; // Default
        case (alu_op_i)
            // Arithmetic
            ALU_ADD:  result_o = op_a_i + op_b_i;
            ALU_SUB:  result_o = op_a_i - op_b_i;
            
            // Logical
            ALU_AND:  result_o = op_a_i & op_b_i;
            ALU_OR:   result_o = op_a_i | op_b_i;
            ALU_XOR:  result_o = op_a_i ^ op_b_i;
            
            // Shifts (Cast to 5 bits for 32/64 bit safety, though 64 needs 6 bits)
            // RV64 shift amounts are lower 6 bits of op_b
            ALU_SLL:  result_o = op_a_i << op_b_i[5:0];
            ALU_SRL:  result_o = op_a_i >> op_b_i[5:0];
            ALU_SRA:  result_o = $signed(op_a_i) >>> op_b_i[5:0]; // Arithmetic Shift
            
            // Comparisons
            ALU_SLT:  result_o = ($signed(op_a_i) < $signed(op_b_i)) ? 64'd1 : 64'd0;
            ALU_SLTU: result_o = (op_a_i < op_b_i) ? 64'd1 : 64'd0;
            
            default:  result_o = '0;
        endcase
    end

endmodule