#include "test_macros.h"

int main() {
    volatile long long a = 10;
    volatile long long b = 5;
    volatile long long result;

    // ---------------------------------------------------
    // TEST 1: Multiplication (MUL)
    // ---------------------------------------------------
    // 10 * 5 = 50
    result = a * b;
    if (result != 50) TEST_FAIL_CODE(1);

    // ---------------------------------------------------
    // TEST 2: Division (DIV) - The Long Wait
    // ---------------------------------------------------
    // 10 / 5 = 2
    // This instruction stalls the CPU for ~32 cycles!
    result = a / b;
    if (result != 2) TEST_FAIL_CODE(2);

    // ---------------------------------------------------
    // TEST 3: Remainder (REM)
    // ---------------------------------------------------
    // 10 % 3 = 1
    volatile long long c = 3;
    result = a % c;
    if (result != 1) TEST_FAIL_CODE(3);

    // ---------------------------------------------------
    // TEST 4: Division by Zero (Corner Case)
    // ---------------------------------------------------
    // RISC-V Spec says: x / 0 = -1 (All bits set)
    volatile long long zero = 0;
    result = a / zero;
    if (result != -1) TEST_FAIL_CODE(4);

    // ---------------------------------------------------
    // TEST 5: Multiply High (MULH)
    // ---------------------------------------------------
    // To test this in C, we need to multiply big numbers.
    // 0x1000_0000_0000_0000 * 0x10 = 0x100_... (Overflows 64-bit)
    // We expect the lower 64 bits to be 0.
    volatile long long big = 0x1000000000000000L;
    result = big * 16;
    if (result != 0) TEST_FAIL_CODE(5);

    TEST_PASS();
    return 0;
}