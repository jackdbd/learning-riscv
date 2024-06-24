.section .text
.globl _start
.equ EXIT, 93 # Linux exit syscall
.equ N, 5 # compute for n = 5

# Sequence:
# a(n) = a(n-1) + 3
# Iterations: 
# a(0) = 2
# a(1) = a(0) + 3 = 5
# a(2) = a(1) + 3 = (a(0)+3) + 3 = 8
# and so on...

_start:
    li a0, N
    # Call subroutine `compute`
    call compute
    li a7, EXIT
    ecall

compute:
    # Function prologue: allocate stack + save return address
    # Allocate the stack: subtract 8 from the current value of the stack pointer
    # register. This operation allocates 8 bytes on the stack. RV64 registers
    # are 64 bit (8 bytes), so we are allocating space for one register.
    addi sp, sp, -8
    # Save ra: store the 64-bit value found in register ra (return address) into
    # the memory location pointed to by the sp register.
    sd ra, 0(sp)
       
    # In this program, recursion ends when n (that we store in a0) reaches 0.
    # The x0 register on RISC-V is always zero.
    beq a0, x0, compute_end
    addi a0, a0, -1
    call compute
    addi a0, a0, 3
    j compute_ret

compute_end:
    li a0, 2
    # Recursion has now ended, but we still need to restore the ra register and
    # free the stack.

compute_ret:
    # Restore ra: load the return address from the stack into the ra register.
    ld ra, 0(sp)
    # Free the stack: restore the stack pointer by adding 8, cleaning up the
    # stack frame used by the function.
    addi sp, sp, 8 
    # Return to the caller.
    ret
