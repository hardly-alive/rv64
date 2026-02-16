#include "test_macros.h"

// We use 'long long' (64-bit) to force the compiler to use
// standard 64-bit instructions (ADD, ADDI, SUB) and avoid
// 32-bit word instructions (ADDIW, SEXT.W) which are not implemented yet.

volatile long long val_a = 100;
volatile long long val_b = -50;
volatile long long val_u = 200;

int main() {
    // ----------------------------------------------------------------
    // 1. Signed Comparison Test (BLT)
    // -50 < 100 is TRUE.
    // ----------------------------------------------------------------
    if (val_b < val_a) {
        // Pass
    } else {
        TEST_FAIL_CODE(2);
    }

    // ----------------------------------------------------------------
    // 2. Unsigned Comparison Test (BLTU)
    // -50 (0xFF...CE) is huge in unsigned. 200 < -50 is TRUE.
    // ----------------------------------------------------------------
    if ((unsigned long long)val_u < (unsigned long long)val_b) {
        // Pass
    } else {
        TEST_FAIL_CODE(3);
    }

    // ----------------------------------------------------------------
    // 3. JALR Test (Function Pointer / Computed Jump)
    // ----------------------------------------------------------------
    void (*target)() = &&label_jump;
    goto *target;

    TEST_FAIL_CODE(4); // Should be skipped by the jump above

label_jump:
    ; // Dummy statement for label syntax

    // ----------------------------------------------------------------
    // 4. Backward Branch (Loop Stress)
    // We use 'volatile long long' to force 64-bit math and prevent optimization.
    // ----------------------------------------------------------------
    volatile long long count = 0;
    
    // Loop 10 times. Compiler will use 64-bit ADDI for this.
    for (volatile long long i = 0; i < 10; i++) {
        count++;
    }

    if (count != 10) {
        // If it fails, return 5. 
        // If it returns a weird number, it means the stack/load failed.
        TEST_FAIL_CODE(5); 
    }

    TEST_PASS();
    return 0;
}