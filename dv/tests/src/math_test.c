#include "test_macros.h"

int main() {
    // ---------------------------------------------------------
    // TEST 1: ADDIW (Add Immediate Word & Sign Extend)
    // ---------------------------------------------------------
    // We want to add 1 to the max 32-bit integer (0x7FFFFFFF).
    // In 32-bit math, this overflows to 0x80000000 (negative).
    // In 64-bit math, this would be positive 0x80000000.
    // RV64 'addiw' MUST sign-extend the result to 0xFFFFFFFF80000000.
    
    volatile int a = 0x7FFFFFFF;
    volatile int b = 1;
    long long result = a + b; // Forces addw/addiw

    // Expecting: 0xFFFFFFFF80000000 (-2147483648)
    // If we get: 0x0000000080000000 (Positive), the CPU failed to sign-extend.
    if (result != -2147483648LL) {
        TEST_FAIL_CODE(1); 
    }

    // ---------------------------------------------------------
    // TEST 2: SUBW (Subtract Word)
    // ---------------------------------------------------------
    volatile int x = 10;
    volatile int y = 20;
    long long sub_res = x - y; // 10 - 20 = -10 (0xFF...F6)

    if (sub_res != -10) {
        TEST_FAIL_CODE(2);
    }

    // ---------------------------------------------------------
    // TEST 3: MULW (Multiply Word)
    // ---------------------------------------------------------
    // 0x10000 * 0x10000 = 0x100000000.
    // In 32-bit math, the lower 32 bits are 0. The result should be 0.
    volatile int m1 = 0x10000;
    volatile int m2 = 0x10000;
    volatile int mul_res = m1 * m2; 

    if (mul_res != 0) {
        TEST_FAIL_CODE(3); // If it returns 0x100000000, MULW failed to truncate.
    }

    // ---------------------------------------------------------
    // TEST 4: FENCE (Smoke Test)
    // ---------------------------------------------------------
    // Just ensure the pipeline doesn't crash or hang.
    asm volatile ("fence");
    asm volatile ("fence.i");

    TEST_PASS();
    return 0;
}