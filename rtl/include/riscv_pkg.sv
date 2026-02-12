package riscv_pkg;

    // ------------------------------------
    // 1. Basic Parameters
    // ------------------------------------
    localparam int XLEN = 64;   // Data width
    localparam int ILEN = 32;   // Instruction width

    // ------------------------------------
    // 2. Opcodes (RV64I Base)
    // ------------------------------------
    typedef enum logic [6:0] {
        OP_LUI    = 7'b0110111,
        OP_AUIPC  = 7'b0010111,
        OP_JAL    = 7'b1101111,
        OP_JALR   = 7'b1100111,
        OP_BRANCH = 7'b1100011,
        OP_LOAD   = 7'b0000011,
        OP_STORE  = 7'b0100011,
        OP_IMM    = 7'b0010011, 
        OP_REG    = 7'b0110011,
        OP_SYSTEM = 7'b1110011 
    } opcode_t;

    // ------------------------------------
    // 3. ALU Operations
    // ------------------------------------
    typedef enum logic [3:0] {
        ALU_ADD,  ALU_SUB,
        ALU_SLL,  ALU_SLT,
        ALU_SLTU, ALU_XOR,
        ALU_SRL,  ALU_SRA,
        ALU_OR,   ALU_AND
    } alu_op_t;

    typedef enum logic [3:0] {
        LSU_NONE,   // Not a memory op
        LSU_LB,     // Load Byte (Signed)
        LSU_LH,     // Load Halfword (Signed)
        LSU_LW,     // Load Word (Signed)
        LSU_LD,     // Load Doubleword
        LSU_LBU,    // Load Byte (Unsigned)
        LSU_LHU,    // Load Halfword (Unsigned)
        LSU_LWU,    // Load Word (Unsigned)
        LSU_SB,     // Store Byte
        LSU_SH,     // Store Halfword
        LSU_SW,     // Store Word
        LSU_SD      // Store Doubleword
    } lsu_op_t;

    typedef enum logic [2:0] {
        BRANCH_NONE = 3'b010, // Default (No Branch) - mapped to safe value
        BRANCH_BEQ  = 3'b000, // Equal
        BRANCH_BNE  = 3'b001, // Not Equal
        BRANCH_BLT  = 3'b100, // Less Than (Signed)
        BRANCH_BGE  = 3'b101, // Greater/Equal (Signed)
        BRANCH_BLTU = 3'b110, // Less Than (Unsigned)
        BRANCH_BGEU = 3'b111  // Greater/Equal (Unsigned)
    } branch_op_t;

    typedef enum logic [3:0] { // 4 bits to be safe
        M_NONE,
        M_MUL,      // Low 64 bits of Signed*Signed
        M_MULH,     // High 64 bits of Signed*Signed
        M_MULHSU,   // High 64 bits of Signed*Unsigned
        M_MULHU,    // High 64 bits of Unsigned*Unsigned
        M_DIV,      // Signed Divide
        M_DIVU,     // Unsigned Divide
        M_REM,      // Signed Remainder
        M_REMU      // Unsigned Remainder
    } mul_op_t;

endpackage