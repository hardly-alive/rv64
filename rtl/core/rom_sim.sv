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

        // 1. ADDI x1, x0, 5  (Loop Counter = 5)
        // 00500093
        mem[0] = 8'h93; mem[1] = 8'h00; mem[2] = 8'h50; mem[3] = 8'h00;

        // 2. ADDI x2, x0, 0  (Accumulator = 0)
        // 00000113
        mem[4] = 8'h13; mem[5] = 8'h01; mem[6] = 8'h00; mem[7] = 8'h00;

        // --- LOOP START (Address 8) ---
        
        // 3. ADD x2, x2, x1  (Accumulate: x2 = x2 + x1)
        // 00110133
        mem[8] = 8'h33; mem[9] = 8'h01; mem[10]= 8'h11; mem[11]= 8'h00;

        // 4. ADDI x1, x1, -1 (Decrement: x1 = x1 - 1)
        // FFF08093
        mem[12]= 8'h93; mem[13]= 8'h80; mem[14]= 8'hf0; mem[15]= 8'hff;

        // 5. BNE x1, x0, -8  (Branch if x1 != 0, go back 8 bytes to Address 8)
        // Offset -8 (Twos complement 1111...1000)
        // Imm[12|10:5] = 1111111 (Top bits)
        // Imm[4:1|11]  = 1100 (Bottom bits)
        // Opcode BNE = 1100011
        // Hex: FE009CE3
        mem[16]= 8'he3; mem[17]= 8'h9c; mem[18]= 8'h00; mem[19]= 8'hfe;
        
        // --- LOOP END ---

        // 6. SW x2, 100(x0) (Store Result 15 to memory address 100)
        // 06202223
        mem[20]= 8'h23; mem[21]= 8'h22; mem[22]= 8'h20; mem[23]= 8'h06;
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