#define TEST_EXIT_ADDR 0xF0000000

// -----------------------------------------------------------------
// Trap Handler (Must be aligned to 4 bytes for mtvec)
// GCC's interrupt attribute automatically saves registers and uses mret
// -----------------------------------------------------------------
__attribute__((interrupt("machine"), aligned(4)))
void trap_handler() {
    // If the CPU successfully jumped here after the ECALL, the trap unit works!
    // Write '1' to the exit address to tell the Python script "TEST PASSED"
    *((volatile unsigned int*)TEST_EXIT_ADDR) = 1;
    
    while(1); // Halt
}

// -----------------------------------------------------------------
// Main Program
// -----------------------------------------------------------------
int main() {
    unsigned long write_val = 0xDEADBEEFCAFEBABE;
    unsigned long read_val  = 0;

    // 1. Test CSR Read/Write (mscratch)
    asm volatile ("csrw mscratch, %0" : : "r"(write_val));
    asm volatile ("csrr %0, mscratch" : "=r"(read_val));

    // If the CSR didn't save the data correctly, fail the test
    if (read_val != write_val) {
        *((volatile unsigned int*)TEST_EXIT_ADDR) = 2; // Fail code
        while(1);
    }

    // 2. Set the Trap Vector (mtvec) to our trap_handler function
    asm volatile ("csrw mtvec, %0" : : "r"(&trap_handler));

    // 3. Trigger a hardware trap!
    asm volatile ("ecall");

    // 4. We should NEVER reach this code. 
    // The ecall should instantly jump to the trap_handler.
    // If we get here, the trap unit failed.
    *((volatile unsigned int*)TEST_EXIT_ADDR) = 3; // Fail code
    while(1);

    return 0;
}