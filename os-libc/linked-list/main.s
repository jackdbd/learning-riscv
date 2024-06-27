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

    mv a0, s0
    li a1, 0x12 # 18
    call linkedlist_push

    li a1, 0x23 # 35
    call linkedlist_push

    li a1, 0x45 # 69
    call linkedlist_push

    # call linkedlist_pop
    # call linkedlist_pop

    li a1, 0x56 # 86
    call linkedlist_push

    call linkedlist_print

    call linkedlist_pop
    call linkedlist_pop
    call linkedlist_pop

    # Function epilogue: restore the value of the return address from the stack,
    # and the position of the stack pointer.
    ld ra, 0(sp)
    addi sp, sp, 8
    ret
