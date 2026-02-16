#ifndef TEST_MACROS_H
#define TEST_MACROS_H

// Define the Magic Address to match sim_main.cpp
#define TOHOST_ADDR 0xF0000000

// Helper: Write value to address
#define WRITE_TOHOST(val) \
    (*(volatile long long *)(TOHOST_ADDR) = (val))

// Usage: Call PASS() when logic is good
#define TEST_PASS() \
    do { \
        WRITE_TOHOST(1); \
        while(1); \
    } while(0)

// Usage: Call FAIL with a specific code to debug
#define TEST_FAIL_CODE(code) \
    do { \
        WRITE_TOHOST(code); \
        while(1); \
    } while(0)

// Backward compatibility
#define TEST_FAIL() TEST_FAIL_CODE(0)

#endif