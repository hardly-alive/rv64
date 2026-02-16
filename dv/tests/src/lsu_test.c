#include "test_macros.h"

int main() {
    // We use a 64-bit buffer initialized to all zeros
    volatile long long buffer = 0;
    volatile char *ptr_b = (char *)&buffer;
    volatile short *ptr_h = (short *)&buffer;
    volatile int *ptr_w = (int *)&buffer;
    long long result;

    // ---------------------------------------------------
    // TEST 1: Store Byte (SB)
    // ---------------------------------------------------
    // Write 0xAA to the first byte. Buffer should be 0x...00AA
    *ptr_b = 0xAA; 
    if (buffer != 0xAA) TEST_FAIL_CODE(1);

    // Write 0xBB to the second byte. Buffer should be 0x...BBAA
    *(ptr_b + 1) = 0xBB;
    if (buffer != 0xBBAA) TEST_FAIL_CODE(2);


    // ---------------------------------------------------
    // TEST 2: Store Half-Word (SH)
    // ---------------------------------------------------
    // Reset buffer
    buffer = 0;
    // Write 0xDEAD to the lower 16 bits
    *ptr_h = 0xDEAD;
    if (buffer != 0xDEAD) TEST_FAIL_CODE(3);


    // ---------------------------------------------------
    // TEST 3: Store Word (SW)
    // ---------------------------------------------------
    // Reset buffer
    buffer = 0;
    // Write 0xCAFEBABE to the lower 32 bits
    *ptr_w = 0xCAFEBABE;
    // In 64-bit, this is just 0x00000000CAFEBABE
    if (buffer != 0xCAFEBABE) TEST_FAIL_CODE(4);


    // ---------------------------------------------------
    // TEST 4: Load Byte Signed vs Unsigned (LB vs LBU)
    // ---------------------------------------------------
    // Set buffer to have 0xFF in the lowest byte
    buffer = 0xFF;
    
    // Signed Load (LB): 0xFF represents -1 in 8-bit.
    // It should sign-extend to 0xFFFFFFFFFFFFFFFF (-1)
    signed char *s_ptr = (signed char *)&buffer;
    volatile long long val_signed = *s_ptr;
    if (val_signed != -1) TEST_FAIL_CODE(val_signed);

    // Unsigned Load (LBU): 0xFF is just 255.
    // It should zero-extend to 0x00000000000000FF (255)
    unsigned char val_unsigned = *(volatile unsigned char *)&buffer;
    if (val_unsigned != 255) TEST_FAIL_CODE(6);


    // ---------------------------------------------------
    // TEST 5: Load Word Signed vs Unsigned (LW vs LWU)
    // ---------------------------------------------------
    // Set buffer to -1 (All Fs)
    buffer = -1;
    
    // Store 0xFFFFFFFF (which is -1 in 32-bit)
    *ptr_w = -1; 
    
    // LW (Signed): Should be 0xFFFFFFFFFFFFFFFF (-1)
    // Note: We need assembly to strictly force LW vs LWU if the compiler is smart,
    // but typical casts work well enough for logic verification.
    long long val_w_signed = *ptr_w; 
    if (val_w_signed != -1) TEST_FAIL_CODE(7);

    // LWU (Unsigned): Should be 0x00000000FFFFFFFF
    unsigned int val_w_unsigned = *ptr_w; // 32-bit uint
    // Promoting 32-bit unsigned to 64-bit long long prevents sign extension
    if ((long long)val_w_unsigned != 0xFFFFFFFFL) TEST_FAIL_CODE(8);

    TEST_PASS();
    return 0;
}