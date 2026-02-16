#include "test_macros.h"

int main() {
    volatile long long a = 100;
    volatile long long b = 7;
    volatile long long result;

    // 1. ADD: 100 + 7 = 107
    result = a + b;
    if (result != 107) TEST_FAIL_CODE(2);

    // 2. SUB: 100 - 7 = 93
    result = a - b;
    if (result != 93) TEST_FAIL_CODE(3);

    // 3. XOR: 100 ^ 7  (1100100 ^ 0000111 = 1100011 = 99)
    result = a ^ b;
    if (result != 99) TEST_FAIL_CODE(4);

    // 4. AND: 100 & 7  (1100100 & 0000111 = 0000100 = 4)
    result = a & b;
    if (result != 4) TEST_FAIL_CODE(5);

    // 5. OR:  100 | 7  (1100100 | 0000111 = 1100111 = 103)
    result = a | b;
    if (result != 103) TEST_FAIL_CODE(6);

    // 6. SLL (Shift Left Logical): 7 << 1 = 14
    result = b << 1;
    if (result != 14) TEST_FAIL_CODE(7);

    // 7. SRL (Shift Right Logical): 100 >> 2 = 25
    result = a >> 2;
    if (result != 25) TEST_FAIL_CODE(8);

    // 8. SRA (Arithmetic Shift): -100 >> 2 = -25
    // This is the most common bug in RISC-V implementations!
    long long neg = -100;
    result = neg >> 2;
    if (result != -25) TEST_FAIL_CODE(9);

    TEST_PASS();
    return 0;
}