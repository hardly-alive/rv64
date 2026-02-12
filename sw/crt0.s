.section .text
.global _start

_start:
    li sp, 4096         # Set Stack Pointer to top of 4KB RAM
    call main           # Call C main function
    
loop:
    j loop              # Infinite loop if main returns