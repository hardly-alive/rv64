#include "test_macros.h"

int main() {
    // Use 'long long' to force 64-bit registers and instructions (LD/SD/ADD)
    long long a = 10;
    long long b = 20;
    long long c = a + b;

    // Check if 10 + 20 == 30
    if (c == 30) {
        TEST_PASS(); 
    } else {
        TEST_FAIL(); 
    }

    return 0;
}