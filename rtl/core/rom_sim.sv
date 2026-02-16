module rom_sim (
    input  logic        clk,
    /* verilator lint_off UNUSED */
    input  logic [63:0] addr_i,       
    /* verilator lint_on UNUSED */
    output logic [31:0] data_o,
    input  logic        mem_req_i,   
    input  logic        mem_we_i,
    input  logic [7:0]  mem_be_i,
    /* verilator lint_off UNUSED */
    input  logic [63:0] mem_addr_i,
    /* verilator lint_on UNUSED */
    input  logic [63:0] mem_wdata_i,
    output logic [63:0] mem_rdata_o
);

    logic [7:0] mem [0:4095]; 
    logic [11:0] fetch_addr;
    logic [11:0] data_addr_aligned;

    assign fetch_addr = addr_i[11:0];
    // Align to 8-byte boundary. LSU handles the offset within these 8 bytes.
    assign data_addr_aligned = {mem_addr_i[11:3], 3'b000};

    initial begin
        for (int i=0; i<4096; i++) mem[i] = 8'h0;
        $readmemh("sw/program.hex", mem);
    end

    // Instruction Fetch
    assign data_o = {mem[fetch_addr+3], mem[fetch_addr+2], mem[fetch_addr+1], mem[fetch_addr]};

    // Data Read
    assign mem_rdata_o = {
        mem[data_addr_aligned+7], mem[data_addr_aligned+6], mem[data_addr_aligned+5], mem[data_addr_aligned+4],
        mem[data_addr_aligned+3], mem[data_addr_aligned+2], mem[data_addr_aligned+1], mem[data_addr_aligned]
    };

    // Data Write
    always @(posedge clk) begin
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
endmodule