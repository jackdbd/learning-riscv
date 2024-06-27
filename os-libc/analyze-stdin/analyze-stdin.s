.section .text

.globl main

main:
    # Function prologue ########################################################
    # Decrement the stack pointer to store 5 registers. Given that in riscv64
    # each register is 8 bytes long, and that we need 2 words of memory for each
    # register, we need to reserve 40 bytes memory on the stack.
    addi sp, sp, -40
    # Store the return address on the stack. Since it's the first address we
    # store on the stack, the offset is 0.
    sd ra, 0(sp)
    # Store another address on the stack. Since it's the 2nd address we store on
    # the stack, and that each address in riscv64 is 8 bytes, the offset is 8.
    sd s0, 8(sp)
    sd s1, 16(sp)
    sd s2, 24(sp)
    sd s3, 32(sp)
    ############################################################################

    li s0, 0 # counter characters
    li s1, 0 # counter decimals
    li s2, 0 # counter letters

loop:
    # Get input from stdin in a0 (i.e. a0 stores 1 character)
    call getchar

    # If getchar returns EOF, a0 is < 0 (the standard permits EOF to have any
    # negative value of type int). bltz stands for Branch if Less Than Zero.
    bltz a0, end

    # increment characters
    addi s0, s0, 1

    # ASCII code (in hex) for digits from 0 to 9 is 0x30 to 0x39
    # https://www.sciencebuddies.org/science-fair-projects/references/ascii-table
    addi t0, a0, -0x30 # t0 = (char-0x30)
    li t1, 0x9
    # If t0 >= 0 AND t0 <= 0x9, then the input character is a decimal.
    # If t0 < 0, by using an unsigned comparison (bleu) we "convert" t0 into a
    # value larger than 0x9.
    bleu t0, t1, increment_decimals

    # Uppercase letters go from 0x41 to 0x5a
    li t0, 0x00
    li t1, 0x19 # 0x5a - 0x41 = 0x19
    addi t0, a0, -0x41 # t0 = (char-0x41)
    # If t0 >= 0 AND t0 <= 0x19, then the input character is an uppercase letter.
    bleu t0, t1, increment_letters

    # Lowercase letters go from 0x61 to 0x7a
    li t0, 0x00
    li t1, 0x19 # 0x7a - 0x61 = 0x19
    addi t0, a0, -0x61 # t0 = (char-0x61)
    # If t0 >= 0 AND t0 <= 0x19, then the input character is a lowercase letter.
    bleu t0, t1, increment_letters

    j loop

increment_decimals:
    addi s1, s1, 1
    j loop

increment_letters:
    addi s2, s2, 1
    j loop

end:
    li s3, 0
    add s3, s3, s0
    sub s3, s3, s1
    sub s3, s3, s2

    # Prepare the arguments for printf (format string + counters)
    la a0, result_fmt
    mv a1, s0
    mv a2, s1
    mv a3, s2
    mv a4, s3
    call printf

    # Set the return value to 0 to indicate an exit code of success
    li a0, 0

    # Function epilogue ########################################################
    # Restore saved registers.
    ld s3, 32(sp)
    ld s2, 24(sp)
    ld s1, 16(sp)
    ld s0, 8(sp)
    # Restore the value of the return address from the stack.
    ld ra, 0(sp)
    # Restore the position of the stack pointer.
    addi sp, sp, 40
    ############################################################################
    # Return to the caller
    ret

.section .rodata

prompt:
    .asciz "Enter some text: \n"

result_fmt:
    .asciz "Characters: %u Decimals: %u  Letters: %u  Others (neither decimal nor letter): %u\n"    
