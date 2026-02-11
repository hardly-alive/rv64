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
    // Internal Wires
    // ---------------------------------------------------------
    logic [63:0] current_pc;
    logic [63:0] fetch_addr;   // Fetch -> ROM
    logic [31:0] raw_instr;    // ROM -> Decode

    // Decode outputs (for waveform visibility)
    opcode_t     dec_opcode;
    logic [4:0]  dec_rs1;
    logic [4:0]  dec_rs2;
    logic [4:0]  dec_rd;

    // IF/ID Pipeline Register signals
    logic [63:0] id_pc;
    logic [31:0] id_instr;

    // ---------------------------------------------------------
    // 1. FETCH STAGE
    // ---------------------------------------------------------
    fetch u_fetch (
        .clk             (clk),
        .rst_n           (rst_n),
        .branch_target_i (64'b0),
        .branch_taken_i  (1'b0),

        .imem_addr_o     (fetch_addr),
        .pc_out_o        (current_pc)
    );

    // ---------------------------------------------------------
    // 2. INSTRUCTION ROM (Simulation Model)
    // ---------------------------------------------------------
    rom_sim u_rom (
        .addr_i (fetch_addr),
        .data_o (raw_instr)
    );

    // ---------------------------------------------------------
    // 3. PIPELINE REGISTER: IF -> ID
    // ---------------------------------------------------------
    if_id_reg u_if_id (
        .clk      (clk),
        .rst_n    (rst_n),
        .stall_i  (1'b0), // No stalls yet
        .flush_i  (1'b0), // No flushes yet

        // Inputs from Fetch/ROM
        .pc_i     (current_pc),
        .instr_i  (raw_instr),

        // Outputs to Decode
        .pc_o     (id_pc),
        .instr_o  (id_instr)
    );

    // ---------------------------------------------------------
    // 4. DECODE STAGE
    // ---------------------------------------------------------
    /* verilator lint_off PINCONNECTEMPTY */
    decode u_decode (
        .instr_i    (id_instr),

        .opcode_o   (dec_opcode),
        .rs1_addr_o (dec_rs1),
        .rs2_addr_o (dec_rs2),
        .rd_addr_o  (dec_rd),

        .funct3_o   (), // unused for now
        .funct7_o   ()  // unused for now
    );
    /* verilator lint_on PINCONNECTEMPTY */

    // ---------------------------------------------------------
    // Expose fetch address to top-level output (for debugging)
    // ---------------------------------------------------------
    assign imem_addr = fetch_addr;

    // ---------------------------------------------------------
    // TEMP: unused dmem
    // ---------------------------------------------------------
    assign dmem_addr  = 64'b0;
    assign dmem_wdata = 64'b0;
    assign dmem_wen   = 1'b0;

    /* verilator lint_off UNUSED */
    logic [31:0] unused_imem;
    logic [63:0] unused_dmem;
    logic [63:0] unused_pc;
    opcode_t     unused_opcode;
    logic [4:0]  unused_rs1;
    logic [4:0]  unused_rs2;
    logic [4:0]  unused_rd;
    logic [63:0] unused_id_pc;
    
    assign unused_imem = imem_rdata;
    assign unused_dmem = dmem_rdata;
    assign unused_pc   = current_pc;
    assign unused_opcode = dec_opcode;
    assign unused_rs1    = dec_rs1;
    assign unused_rs2    = dec_rs2;
    assign unused_rd     = dec_rd;
    assign unused_id_pc = id_pc;
    /* verilator lint_on UNUSED */

endmodule
