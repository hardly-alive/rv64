module rom_sim (
    input  logic        clk,
    
    // Port A: Instruction Fetch
    input  logic [63:0] addr_i,
    output logic [31:0] data_o,

    // Port B: Data Access
    input  logic        mem_req_i,
    input  logic        mem_we_i,
    input  logic [7:0]  mem_be_i,
    input  logic [63:0] mem_addr_i,
    input  logic [63:0] mem_wdata_i,
    output logic [63:0] mem_rdata_o
);

    // 4KB Memory
    logic [7:0] mem [0:4095]; 

    // Internal short addresses (12 bits) to satisfy Verilator
    logic [11:0] fetch_addr_short;
    logic [11:0] data_addr_short;

    assign fetch_addr_short = addr_i[11:0];
    assign data_addr_short  = mem_addr_i[11:0];

    /* verilator lint_off UNUSED */
    logic [127:0] dummy_sink;
    assign dummy_sink = {addr_i, mem_addr_i}; // Tell Verilator we "used" them
    /* verilator lint_on UNUSED */

    // Initialize
    initial begin
        for (int i=0; i<4096; i++) mem[i] = 8'h0;

        // 1. ADDI x1, x0, 5  (x1 = 5)
        // 00500093
        mem[0] = 8'h93; mem[1] = 8'h00; mem[2] = 8'h50; mem[3] = 8'h00;

        // 2. ADDI x2, x0, 10 (x2 = 10)
        // 00A00113
        mem[4] = 8'h13; mem[5] = 8'h01; mem[6] = 8'hA0; mem[7] = 8'h00;

        // 3. MUL x3, x1, x2  (x3 = 5 * 10 = 50 / 0x32)
        // Opcode: 0110011 (Reg-Reg)
        // Funct3: 000 (MUL)
        // Funct7: 0000001 (M-Ext)
        // RD=3 (x3), RS1=1 (x1), RS2=2 (x2)
        // Hex: 022081B3
        mem[8] = 8'hB3; mem[9] = 8'h81; mem[10]= 8'h20; mem[11]= 8'h02;

        // 4. ADDI x4, x3, 1  (x4 = 50 + 1 = 51 / 0x33)
        // This instruction MUST WAIT for MUL to finish!
        // 00118213
        mem[12]= 8'h13; mem[13]= 8'h82; mem[14]= 8'h11; mem[15]= 8'h00;
    end

    // Port A Read
    assign data_o = {
        mem[fetch_addr_short+12'd3], 
        mem[fetch_addr_short+12'd2], 
        mem[fetch_addr_short+12'd1], 
        mem[fetch_addr_short]
    };

    // Port B Read
    assign mem_rdata_o = {
        mem[data_addr_short+12'd7], mem[data_addr_short+12'd6], 
        mem[data_addr_short+12'd5], mem[data_addr_short+12'd4],
        mem[data_addr_short+12'd3], mem[data_addr_short+12'd2], 
        mem[data_addr_short+12'd1], mem[data_addr_short]
    };

    // Port B Write
    always @(posedge clk) begin
        if (mem_req_i && mem_we_i) begin
            if (mem_be_i[0]) mem[data_addr_short]       <= mem_wdata_i[7:0];
            if (mem_be_i[1]) mem[data_addr_short+12'd1] <= mem_wdata_i[15:8];
            if (mem_be_i[2]) mem[data_addr_short+12'd2] <= mem_wdata_i[23:16];
            if (mem_be_i[3]) mem[data_addr_short+12'd3] <= mem_wdata_i[31:24];
            if (mem_be_i[4]) mem[data_addr_short+12'd4] <= mem_wdata_i[39:32];
            if (mem_be_i[5]) mem[data_addr_short+12'd5] <= mem_wdata_i[47:40];
            if (mem_be_i[6]) mem[data_addr_short+12'd6] <= mem_wdata_i[55:48];
            if (mem_be_i[7]) mem[data_addr_short+12'd7] <= mem_wdata_i[63:56];
        end
    end
endmodule