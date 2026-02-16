#include "test_macros.h"

// Simple recursion to test stack depth
long long depth_test(long long n, long long sum) {
    if (n == 0) return sum;
    return depth_test(n - 1, sum + n);
}

int main() {
    // sum of 1 to 5 = 15
    long long result = depth_test(5, 0);
    
    if (result == 15) {
        TEST_PASS();
    } else {
        // If result is garbage, your stack loads/stores are failing
        TEST_FAIL_CODE(result); 
    }
    return 0;
}