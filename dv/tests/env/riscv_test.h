#ifndef _ENV_PHYSICAL_SINGLE_CORE_H
#define _ENV_PHYSICAL_SINGLE_CORE_H

#include "test_macros.h"

// -----------------------------------------------------------------
// 1. Core Definitions
// -----------------------------------------------------------------
#define RVTEST_RV64U
#define TESTNUM x28

// -----------------------------------------------------------------
// 2. Initialization Macro (Replaces your crt0.s)
// -----------------------------------------------------------------
#define RVTEST_CODE_BEGIN                                               \
    .section .text.init;                                                \
    .align  6;                                                          \
    .global _start;                                                     \
_start:                                                                 \
    /* Initialize the stack pointer (just in case) */                   \
    la sp, _stack_top;                                                  \
    /* Initialize the trap vector to catch exceptions */                \
    la t0, trap_vector;                                                 \
    csrw mtvec, t0;                                                     \

// -----------------------------------------------------------------
// 3. Pass / Fail Macros
// -----------------------------------------------------------------
// Write 1 to 0xF0000000 (Pass)
#define RVTEST_PASS                                                     \
    li t0, 0xF0000000;                                                  \
    li t1, 1;                                                           \
    sw t1, 0(t0);                                                       \
1:  j 1b;

// Write TESTNUM (which holds the failed test number) to 0xF0000000
#define RVTEST_FAIL                                                     \
    li t0, 0xF0000000;                                                  \
    sw TESTNUM, 0(t0);                                                  \
1:  j 1b;

// -----------------------------------------------------------------
// 4. Trap Handler (Catches unexpected exceptions)
// -----------------------------------------------------------------
#define RVTEST_CODE_END                                                 \
    .align 4;                                                           \
trap_vector:                                                            \
    /* If we trap, treat it as a failure and write cause to exit */     \
    li t0, 0xF0000000;                                                  \
    csrr t1, mcause;                                                    \
    /* Add an offset (e.g., 0xEE0000) so we know it was a trap */       \
    li t2, 0xEE0000;                                                    \
    add t1, t1, t2;                                                     \
    sw t1, 0(t0);                                                       \
1:  j 1b;                                                               \

// We don't need any special data for bare metal
#define RVTEST_DATA_BEGIN .align 4; .section .data;
#define RVTEST_DATA_END

#endif