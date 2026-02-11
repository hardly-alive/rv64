module regfile (
    input  logic        clk,
    input  logic        rst_n,

    // Read Ports (Combinational / Instant)
    input  logic [4:0]  rs1_addr_i,
    output logic [63:0] rs1_data_o,

    input  logic [4:0]  rs2_addr_i,
    output logic [63:0] rs2_data_o,

    // Write Port (Sequential / Clocked)
    input  logic [4:0]  rd_addr_i,
    input  logic [63:0] rd_data_i,
    input  logic        rd_wen_i
);

    // 32 registers, each 64 bits wide
    logic [63:0] regs [0:31];

    // ---------------------------------------------------------
    // READ LOGIC
    // ---------------------------------------------------------
    // If address is 0, output 0. Otherwise, read the array.
    assign rs1_data_o = (rs1_addr_i == 5'd0) ? 64'b0 : regs[rs1_addr_i];
    assign rs2_data_o = (rs2_addr_i == 5'd0) ? 64'b0 : regs[rs2_addr_i];

    // ---------------------------------------------------------
    // WRITE LOGIC
    // ---------------------------------------------------------
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset: Clear all registers
            for (int i=0; i<32; i++) regs[i] <= 64'b0;
        end else begin
            // Write enabled AND destination is not x0
            if (rd_wen_i && (rd_addr_i != 5'd0)) begin
                regs[rd_addr_i] <= rd_data_i;
            end
        end
    end

endmodule