.section .text
.globl _start
.equ EXIT, 93

_start:
    # add 7 to the value of the x0 register (which on RISC-V is constantly at 0)
    # and store the sum in x10 (so basically set x10 to 7)
    addi x10, x0,  7

    # set x17 to 93. 93 is the Linux syscall exit. The x17 user-level base
    # integer register correspondes to a7 in the ABI.
    addi x17, x0, EXIT
    # The following instruction would have the same effect as `addi x17, x0, 93`,
    # but `li` is a pseudo-instruction, while `addi` is an actual instruction.
    # li a7, 93      

    # environment call (make a system call to the operating system)
    ecall
