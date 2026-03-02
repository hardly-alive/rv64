module rom_sim (
    input  logic        clk,

    // ===============================
    // Instruction Interface
    // ===============================
    input  logic [63:0] addr_i,
    output logic [31:0] data_o,

    // ===============================
    // Data Interface
    // ===============================
    input  logic        mem_req_i,
    input  logic        mem_we_i,
    input  logic [7:0]  mem_be_i,
    input  logic [63:0] mem_addr_i,
    input  logic [63:0] mem_wdata_i,
    output logic [63:0] mem_rdata_o
);

    // ==========================================================
    // Memory Configuration
    // ==========================================================
    localparam logic [63:0] MEM_BASE   = 64'h8000_0000;
    localparam int          MEM_SIZE   = 131072;          // FIX: Removed 64'd prefix
    localparam int          ADDR_WIDTH = $clog2(MEM_SIZE);

    // ==========================================================
    // Byte-Addressable Memory
    // ==========================================================
    logic [7:0] mem [0:MEM_SIZE-1];

    // ==========================================================
    // Address Translation (Verilator-Safe)
    // ==========================================================

    /* verilator lint_off UNUSED */
    logic [63:0] fetch_addr_full;
    logic [63:0] data_addr_full;
    /* verilator lint_on UNUSED */

    assign fetch_addr_full = addr_i - MEM_BASE;
    assign data_addr_full  = mem_addr_i - MEM_BASE;

    // FIX: Changed from wire to logic
    /* verilator lint_off UNUSED */
    logic [ADDR_WIDTH-1:0] fetch_addr;
    logic [ADDR_WIDTH-1:0] data_addr;
    logic [ADDR_WIDTH-1:0] data_addr_aligned;
    /* verilator lint_on UNUSED */

    assign fetch_addr = fetch_addr_full[ADDR_WIDTH-1:0];
    assign data_addr  = data_addr_full[ADDR_WIDTH-1:0];
    
    // 8-byte alignment for RV64
    assign data_addr_aligned = {data_addr[ADDR_WIDTH-1:3], 3'b000};

    // ==========================================================
    // Memory Initialization
    // ==========================================================
    initial begin
        for (int i = 0; i < MEM_SIZE; i++)
            mem[i] = 8'h00;
        $readmemh("sw/program.hex", mem);
    end

    // ==========================================================
    // Instruction Fetch (Little Endian)
    // ==========================================================
    assign data_o = {
        mem[fetch_addr + 3],
        mem[fetch_addr + 2],
        mem[fetch_addr + 1],
        mem[fetch_addr + 0]
    };

    // ==========================================================
    // Data Read (64-bit)
    // ==========================================================
    assign mem_rdata_o = {
        mem[data_addr_aligned + 7],
        mem[data_addr_aligned + 6],
        mem[data_addr_aligned + 5],
        mem[data_addr_aligned + 4],
        mem[data_addr_aligned + 3],
        mem[data_addr_aligned + 2],
        mem[data_addr_aligned + 1],
        mem[data_addr_aligned + 0]
    };

    // ==========================================================
    // Data Write (Byte Enables)
    // ==========================================================
    always_ff @(posedge clk) begin
        if (mem_req_i && mem_we_i) begin
            if (mem_be_i[0]) mem[data_addr_aligned + 0] <= mem_wdata_i[7:0];
            if (mem_be_i[1]) mem[data_addr_aligned + 1] <= mem_wdata_i[15:8];
            if (mem_be_i[2]) mem[data_addr_aligned + 2] <= mem_wdata_i[23:16];
            if (mem_be_i[3]) mem[data_addr_aligned + 3] <= mem_wdata_i[31:24];
            if (mem_be_i[4]) mem[data_addr_aligned + 4] <= mem_wdata_i[39:32];
            if (mem_be_i[5]) mem[data_addr_aligned + 5] <= mem_wdata_i[47:40];
            if (mem_be_i[6]) mem[data_addr_aligned + 6] <= mem_wdata_i[55:48];
            if (mem_be_i[7]) mem[data_addr_aligned + 7] <= mem_wdata_i[63:56];
        end
    end

    // // ==========================================================
    // // Safety Guard
    // // ==========================================================
    // always_ff @(posedge clk) begin
    //     if (addr_i < MEM_BASE || addr_i >= MEM_BASE + 64'(MEM_SIZE))
    //         $fatal("IMEM address out of range: %h", addr_i);

    //     if (mem_req_i && (mem_addr_i < MEM_BASE || mem_addr_i >= MEM_BASE + 64'(MEM_SIZE)))
    //         $fatal("DMEM address out of range: %h", mem_addr_i);
    // end

endmodule






