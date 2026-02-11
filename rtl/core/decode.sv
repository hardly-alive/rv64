module decode 
    import riscv_pkg::*;
(
    input  logic [31:0] instr_i,

    // Outputs to Register File / Execute
    output opcode_t     opcode_o,
    output logic [4:0]  rs1_addr_o,
    output logic [4:0]  rs2_addr_o,
    output logic [4:0]  rd_addr_o,
    output logic [2:0]  funct3_o,
    output logic [6:0]  funct7_o
);

    // ---------------------------------------------
    // RISC-V Instruction Format Slicing
    // ---------------------------------------------
    // [31:25] funct7
    // [24:20] rs2
    // [19:15] rs1
    // [14:12] funct3
    // [11: 7] rd
    // [ 6: 0] opcode

    assign opcode_o   = opcode_t'(instr_i[6:0]); // Cast bits to Enum
    assign rd_addr_o  = instr_i[11:7];
    assign funct3_o   = instr_i[14:12];
    assign rs1_addr_o = instr_i[19:15];
    assign rs2_addr_o = instr_i[24:20];
    assign funct7_o   = instr_i[31:25];

endmodule