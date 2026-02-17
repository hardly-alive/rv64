module multiplier 
    import riscv_pkg::*;
(
    input  logic        clk,
    input  logic        rst_n,
    
    input  mul_op_t     mul_op_i,
    input  logic [63:0] op_a_i,
    input  logic [63:0] op_b_i,

    output logic [63:0] result_o,
    output logic        stall_mul_o
);

    typedef enum logic [1:0] { IDLE, CALC, DONE } state_t;
    state_t state, next_state;

    logic [63:0] result_next;
    logic [5:0]  counter;      
    logic [5:0]  counter_next;
    
    // Input Latches to protect against pipeline changes during stall
    logic [63:0] latched_a;
    logic [63:0] latched_b;
    mul_op_t     latched_mul_op;

    localparam LATENCY_MUL = 6'd4;
    localparam LATENCY_DIV = 6'd32;

    /* verilator lint_off UNUSED */
    logic [127:0] full_mul_res; 
    /* verilator lint_on UNUSED */

    // ------------------------------------------------------------
    // State Register
    // ------------------------------------------------------------
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state          <= IDLE;
            counter        <= 6'b0;
            result_o       <= 64'b0;
            latched_a      <= 64'b0;
            latched_b      <= 64'b0;
            latched_mul_op <= M_NONE;
        end else begin
            state   <= next_state;
            counter <= counter_next;

            // ------------------------------------------------------------
            // FIX: latch inputs ONLY when accepting a new operation in IDLE
            // ------------------------------------------------------------
            if (state == IDLE && mul_op_i != M_NONE) begin
                latched_a      <= op_a_i;
                latched_b      <= op_b_i;
                latched_mul_op <= mul_op_i;
            end

            // Update result exactly at completion cycle
            if (state == CALC && counter == 0) begin
                result_o <= result_next;
            end
        end
    end

    // ------------------------------------------------------------
    // Combinational Logic
    // ------------------------------------------------------------
    always_comb begin
        next_state   = state;
        stall_mul_o  = 1'b0;
        counter_next = counter;
        result_next  = result_o;
        full_mul_res = 128'b0;

        case (state)

            // ------------------------------------------------------------
            // IDLE: accept new request
            // ------------------------------------------------------------
            IDLE: begin
                if (mul_op_i != M_NONE) begin
                    next_state  = CALC;
                    stall_mul_o = 1'b1;

                    // ------------------------------------------------------------
                    // FIX: off-by-one latency correction.
                    // If latency is N cycles, load counter = N-1.
                    // ------------------------------------------------------------
                    if (mul_op_i == M_DIV  || mul_op_i == M_DIVU ||
                        mul_op_i == M_REM  || mul_op_i == M_REMU ||
                        mul_op_i == M_DIVW || mul_op_i == M_DIVUW ||
                        mul_op_i == M_REMW || mul_op_i == M_REMUW)
                        counter_next = LATENCY_DIV - 1;
                    else
                        counter_next = LATENCY_MUL - 1;
                end
            end

            // ------------------------------------------------------------
            // CALC: busy state, stall asserted
            // ------------------------------------------------------------
            CALC: begin
                stall_mul_o = 1'b1;

                if (counter != 0)
                    counter_next = counter - 1;

                if (counter == 0) begin
                    next_state = DONE;

                    // ------------------------------------------------------------
                    // FIX: Use latched_mul_op, NOT mul_op_i.
                    // mul_op_i may change while stalled.
                    // ------------------------------------------------------------
                    case (latched_mul_op)

                        // -----------------------------
                        // 64-bit Multiply Instructions
                        // -----------------------------
                        M_MUL:    result_next = latched_a * latched_b;

                        M_MULH: begin
                            full_mul_res = $signed(latched_a) * $signed(latched_b);
                            result_next  = full_mul_res[127:64];
                        end

                        M_MULHSU: begin
                            full_mul_res = $signed(latched_a) * $signed({1'b0, latched_b});
                            result_next  = full_mul_res[127:64];
                        end

                        M_MULHU: begin
                            full_mul_res = latched_a * latched_b;
                            result_next  = full_mul_res[127:64];
                        end

                        // -----------------------------
                        // 64-bit Divide/Reminder
                        // -----------------------------
                        M_DIV: begin
                            // FIX: RISC-V overflow case INT64_MIN / -1 => INT64_MIN
                            if (latched_b == 0)
                                result_next = 64'hFFFF_FFFF_FFFF_FFFF;
                            else if (($signed(latched_a) == 64'sh8000_0000_0000_0000) &&
                                     ($signed(latched_b) == -64'sd1))
                                result_next = 64'h8000_0000_0000_0000;
                            else
                                result_next = $signed(latched_a) / $signed(latched_b);
                        end

                        M_DIVU: begin
                            if (latched_b == 0)
                                result_next = 64'hFFFF_FFFF_FFFF_FFFF;
                            else
                                result_next = latched_a / latched_b;
                        end

                        M_REM: begin
                            // FIX: RISC-V overflow case INT64_MIN % -1 => 0
                            if (latched_b == 0)
                                result_next = latched_a;
                            else if (($signed(latched_a) == 64'sh8000_0000_0000_0000) &&
                                     ($signed(latched_b) == -64'sd1))
                                result_next = 64'd0;
                            else
                                result_next = $signed(latched_a) % $signed(latched_b);
                        end

                        M_REMU: begin
                            if (latched_b == 0)
                                result_next = latched_a;
                            else
                                result_next = latched_a % latched_b;
                        end

                        // -----------------------------
                        // 32-bit WORD Instructions
                        // -----------------------------
                        M_MULW: begin
                            logic signed [31:0] a32;
                            logic signed [31:0] b32;
                            logic signed [31:0] res32;

                            a32   = latched_a[31:0];
                            b32   = latched_b[31:0];
                            res32 = a32 * b32;

                            result_next = {{32{res32[31]}}, res32};
                        end

                        M_DIVW: begin
                            logic signed [31:0] a32;
                            logic signed [31:0] b32;
                            logic signed [31:0] res32;

                            a32 = latched_a[31:0];
                            b32 = latched_b[31:0];

                            // FIX: div-by-zero => -1
                            if (b32 == 0)
                                res32 = -1;

                            // FIX: RISC-V overflow case INT32_MIN / -1 => INT32_MIN
                            else if ((a32 == 32'sh8000_0000) && (b32 == -32'sd1))
                                res32 = 32'sh8000_0000;

                            else
                                res32 = a32 / b32;

                            result_next = {{32{res32[31]}}, res32};
                        end

                        M_DIVUW: begin
                            logic [31:0] a32;
                            logic [31:0] b32;
                            logic [31:0] res32;

                            a32 = latched_a[31:0];
                            b32 = latched_b[31:0];

                            // FIX: div-by-zero => all 1s
                            if (b32 == 0)
                                res32 = 32'hFFFF_FFFF;
                            else
                                res32 = a32 / b32;

                            // NOTE: DIVUW is unsigned but result is sign-extended (spec)
                            result_next = {{32{res32[31]}}, res32};
                        end

                        M_REMW: begin
                            logic signed [31:0] a32;
                            logic signed [31:0] b32;
                            logic signed [31:0] res32;

                            a32 = latched_a[31:0];
                            b32 = latched_b[31:0];

                            // FIX: div-by-zero => dividend
                            if (b32 == 0)
                                res32 = a32;

                            // FIX: RISC-V overflow case INT32_MIN % -1 => 0
                            else if ((a32 == 32'sh8000_0000) && (b32 == -32'sd1))
                                res32 = 32'sd0;

                            else
                                res32 = a32 % b32;

                            result_next = {{32{res32[31]}}, res32};
                        end

                        M_REMUW: begin
                            logic [31:0] a32;
                            logic [31:0] b32;
                            logic [31:0] res32;

                            a32 = latched_a[31:0];
                            b32 = latched_b[31:0];

                            if (b32 == 0)
                                res32 = a32;
                            else
                                res32 = a32 % b32;

                            // NOTE: REMUW is unsigned but result is sign-extended (spec)
                            result_next = {{32{res32[31]}}, res32};
                        end

                        default: result_next = 64'b0;
                    endcase
                end
            end

            // ------------------------------------------------------------
            // DONE: one cycle completion state
            // ------------------------------------------------------------
            DONE: begin
                // NOTE: Stall drops here, upstream can issue next op next cycle.
                stall_mul_o = 1'b0;
                next_state  = IDLE;
            end

            default: begin
                next_state = IDLE;
            end

        endcase
    end

endmodule
