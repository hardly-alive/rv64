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
    
    // NEW: Input Latches to protect against pipeline wiggles
    logic [63:0] latched_a;
    logic [63:0] latched_b;

    localparam LATENCY_MUL = 6'd4;
    localparam LATENCY_DIV = 6'd32;

    /* verilator lint_off UNUSED */
    logic [127:0] full_mul_res; 
    /* verilator lint_on UNUSED */

    // State Register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= IDLE;
            counter   <= 6'b0;
            result_o  <= 64'b0;
            latched_a <= 64'b0; // Reset latch
            latched_b <= 64'b0; // Reset latch
        end else begin
            state   <= next_state;
            counter <= counter_next;
            
            // Latch inputs when starting
            if (state == IDLE && mul_op_i != M_NONE) begin
                latched_a <= op_a_i;
                latched_b <= op_b_i;
            end

            // Update result at exact moment of completion
            if (state == CALC && counter == 0) begin
                result_o <= result_next; 
            end
        end
    end

    // Logic
    always_comb begin
        next_state   = state;
        stall_mul_o  = 1'b0;  
        counter_next = counter;
        result_next  = result_o;
        full_mul_res = 128'b0;

        case (state)
            IDLE: begin
                if (mul_op_i != M_NONE) begin
                    next_state   = CALC;
                    stall_mul_o  = 1'b1;
                    if (mul_op_i >= M_DIV) counter_next = LATENCY_DIV;
                    else                   counter_next = LATENCY_MUL;
                end
            end

            CALC: begin
                stall_mul_o = 1'b1; 
                counter_next = counter - 1;

                if (counter == 0) begin
                    next_state = DONE;
                    
                    // USE LATCHED INPUTS HERE
                    case (mul_op_i)
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
                        M_DIV:  result_next = (latched_b == 0) ? -1 : ($signed(latched_a) / $signed(latched_b));
                        M_DIVU: result_next = (latched_b == 0) ? -1 : (latched_a / latched_b);
                        M_REM:  result_next = (latched_b == 0) ? latched_a : ($signed(latched_a) % $signed(latched_b));
                        M_REMU: result_next = (latched_b == 0) ? latched_a : (latched_a % latched_b);
                        default: result_next = 64'b0;
                    endcase
                end
            end

            DONE: begin
                stall_mul_o = 1'b0; 
                next_state  = IDLE;
            end
            
            default: next_state = IDLE;
        endcase
    end
endmodule