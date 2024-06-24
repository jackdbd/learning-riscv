.section .text
.globl _start

_start:
    # Add 7 to the value of the x0 register (which on RISC-V is constantly at 0)
    # and store the sum in x10 (so basically set x10 to 7).
    addi x10, x0,  7

    # Set x17 to 93. 93 is the Linux syscall exit. The x17 user-level base
    # integer register corresponds to a7 in the ABI.
    addi x17, x0, 93
    # The following instruction would have the same effect as `addi x17, x0, 93`,
    # but `li` is a pseudo-instruction, while `addi` is an actual instruction.
    # li a7, 93      

    # Make a request to the supporting execution environment (the execution
    # environment is most likely an operating system).
    ecall
