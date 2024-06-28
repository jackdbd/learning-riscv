.include "linkedlist_struct.s"

.section .text

.globl main
main:
    # Function prologue: store the return address on the stack. In riscv64, the
    # return address—like all general-purpose registers (x0 through x31)—is 64
    # bits long, namely 8 bytes. To store 8 bytes of memory on the stack, we
    # decrement the stack pointer by 8 bytes.
    addi sp, sp, -8
    sd ra, 0(sp)
    
    # new head of list
    li s0, 0

    # linkedlist_push uses a0 and a1 as inputs, and sets the output in a0.
    mv a0, s0 # head
    li a1, 0x12 # value (0x12 in hexadecimal is 18 in decimal)
    call linkedlist_push # allocation 1

    li a1, 0x23 # 35
    call linkedlist_push # allocation 2

    li a1, 0x45 # 69
    call linkedlist_push # allocation 3

    call linkedlist_pop # deallocation 1

    li a1, 0x56 # 86
    call linkedlist_push # allocation 4

    call linkedlist_print

    call linkedlist_pop # deallocation 2
    call linkedlist_pop # deallocation 3
    call linkedlist_pop # deallocation 4

    call linkedlist_print

    # Function epilogue: restore the value of the return address from the stack,
    # and the position of the stack pointer.
    ld ra, 0(sp)
    addi sp, sp, 8
    ret
