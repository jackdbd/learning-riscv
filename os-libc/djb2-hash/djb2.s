.section .text

.globl main

# TODO: add tests. I'm not sure this program is correct.

main:
    # Function prologue
    addi sp, sp, -8
    sd ra, 0(sp)

    la a0, prompt
    call printf

    la a0, scanfmt
    la a1, input
    call scanf

    # process input with djb2
    la a0, input
    call djb2
    mv a1, a0

    # print result 
    la a0, message_result
    call printf

    # We store the return value in a0. We store 0 to indicate success.
    li a0, 0
    
    # Function epilogue
    ld ra, 0(sp)
    addi sp, sp,8

    ret

# Compute a hash function with the djb2 algorithm
# Double check the results here:
# https://md5hashing.net/hash/djb2
# https://www.convertcase.com/hashing/djb-hash-calculator
djb2:
    # 5381 was chosen by Daniel J. Bernstein (the creator of the DJB algorithm)
    # as the initial hash value, because it empirically resulted in fewer
    # collisions and better avalanching.
    # https://stackoverflow.com/questions/10696223/reason-for-the-number-5381-in-the-djb-hash-function
    li t1, 5381

djb2_loop:
    lb t0, 0(a0) # process every char of input
    beqz t0, dbj2_end # until zero appears

    mv t2, t1           
    slliw t2, t2, 5 # t2 = hash << 5 = 32 * hash
    addw t1, t1, t2 # t1 = 32 * hash + hash = 33 * hash
    addw t1, t1, t0 # t1 = 33 * hash + char

    addi a0, a0, 1 # next iteration 
    j djb2_loop

dbj2_end:
    # store hash value in a0 and return to the caller
    mv a0, t1
    ret

.section .rodata

message_result:
    .asciz "Hash is %lu\n" # write out the parameter as long unsigned

prompt:
    .asciz "Enter text to hash:\n"

scanfmt:
    .asciz "%127[^\n]" # scanf max 127 chars and end with return

.section .bss

input:
    .zero 128
