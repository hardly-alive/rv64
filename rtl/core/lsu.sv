module lsu 
    import riscv_pkg::*;
(
    // Pipeline Control Signals (NEW)
    input  logic        mem_read_i,
    input  logic        mem_write_i,

    // Data Signals
    input  lsu_op_t     lsu_op_i,
    input  logic [63:0] addr_i,      
    input  logic [63:0] store_data_i,
    input  logic [63:0] load_data_i, 

    // To Memory
    output logic        mem_req_o,   
    output logic        mem_we_o,    
    output logic [63:0] mem_addr_o,
    output logic [63:0] mem_wdata_o,
    output logic [7:0]  mem_be_o,    

    // To Writeback
    output logic [63:0] result_o
);

    logic [2:0] addr_offset;
    assign mem_addr_o  = addr_i;
    assign addr_offset = addr_i[2:0];

    // Only request memory if the pipeline explicitly says so
    assign mem_req_o = mem_read_i || mem_write_i;
    assign mem_we_o  = mem_write_i; // Write enable comes directly from pipeline

    // 2. STORE ALIGNMENT
    always_comb begin
        mem_wdata_o = store_data_i;
        mem_be_o    = 8'b0;

        if (mem_write_i) begin
            case (lsu_op_i)
                LSU_SB: begin
                    mem_wdata_o = store_data_i << (addr_offset * 8);
                    mem_be_o    = 8'b0000_0001 << addr_offset;
                end
                LSU_SH: begin
                    mem_wdata_o = store_data_i << (addr_offset * 8);
                    mem_be_o    = 8'b0000_0011 << addr_offset;
                end
                LSU_SW: begin
                    mem_wdata_o = store_data_i << (addr_offset * 8);
                    mem_be_o    = 8'b0000_1111 << addr_offset;
                end
                LSU_SD: begin
                    mem_wdata_o = store_data_i;
                    mem_be_o    = 8'b1111_1111;
                end
                default: mem_be_o = 8'b0;
            endcase
        end
    end

    // 3. LOAD ALIGNMENT & SIGN EXTENSION
    // Using manual bit replication for maximum safety
    /* verilator lint_off UNUSED */
    logic [63:0] raw_shifted;
    /* verilator lint_on UNUSED */
    assign raw_shifted = load_data_i >> (addr_offset * 8);

    always_comb begin
        result_o = 64'b0;
        if (mem_read_i) begin
            case (lsu_op_i)
                LSU_LB:  result_o = {{56{raw_shifted[7]}},  raw_shifted[7:0]};
                LSU_LBU: result_o = {56'b0,                 raw_shifted[7:0]};
                LSU_LH:  result_o = {{48{raw_shifted[15]}}, raw_shifted[15:0]};
                LSU_LHU: result_o = {48'b0,                 raw_shifted[15:0]};
                LSU_LW:  result_o = {{32{raw_shifted[31]}}, raw_shifted[31:0]};
                LSU_LWU: result_o = {32'b0,                 raw_shifted[31:0]};
                LSU_LD:  result_o = load_data_i;
                default: result_o = 64'b0;
            endcase
        end
    end
endmodule