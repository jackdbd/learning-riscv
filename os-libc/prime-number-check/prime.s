.section .text

# In RISC-V, there's no specific requirement to define a main function like in C.
# However, it's common to use this convention when writing assembly code that's
# intended to interact with the C runtime environment.
.globl main

.equ MAX_NUM, 0x100000 # 1048576 in decimal. TODO: why this number?

main:
    # Function prologue: we need to store the return address on the stack.
    # In riscv64, the return address—like all general-purpose registers (x0
    # through x31)—is 64 bits long, namely 8 bytes.
    # To store 8 bytes of memory on the stack, we decrement the stack pointer by
    # 8 bytes.
    addi sp, sp, -8
    # RISC-V defines a word of memory as 32 bits long (4 bytes). Since we need
    # to store 64 bits of memory (8 bytes) we need 2 words of memory. We can
    # store 2 words using the `sd` instruction (store double word).
    sd ra, 0(sp)

    la a0, prompt
    # printf is a function available in libc (more precisely, printf is a family
    # of subroutines). Since this program assumes the libc to be available, we
    # can use the `call` instruction to invoke printf. With `call printf` we
    # jump to the address associated with the label `printf`. 
    call printf

    # scanf is a function available in libc. It requires 2 arguments, so we
    # store them in the a0 and a1 registers. Then we invoke it with `call`.
    # The scanf return value will be stored in a0.
    la a0, scanfmt
    la a1, input
    call scanf

    # If the value in a0 is <= 0, it means scanf couldn't read the data from
    # stdin and store them according to the format specifier (e.g. "%u", "%d").
    # This happens when the user digits "foo" instead of an integer.
    # blez stands for Branch if Less than or Equal to Zero
    blez a0, print_error_message_input_not_a_number

    # scanf("%d", &input) returns the number of values converted and assigned
    # successfully. For example, if &input is -42, scanf("%d", &input) reads -42,
    # stores -42, and returns 1.
    # One could argue that it doesn't make sense to ask whether zero or a
    # negative number is prime. If we take this definition of prime number:
    # "A prime number is a natural number greater than 1 that has no positive
    # divisors other than 1 and itself".
    # Since this definition inherently excludes negative numbers, I would
    # consider a negative input as a user error.
    la a1, input
    lw a1, 0(a1)
    blez a1, print_error_message_input_not_positive_number

    # If the value in a1 is greater then MAX_NUM, we tell the caller is too high.
    la a1, input
    lw a1, 0(a1)
    li t0, MAX_NUM
    bge a1, t0, print_error_message_input_too_high # if a1 >= t0, branch

    # sieve is a label defined in this program. It requires 1 argument. Its
    # return value is stored in a0. If n is prime, a0=1. Otherwise a0=0
    la a0, input
    call sieve

    # bnez stands for Branch if Not Equal to Zero
    bnez a0, print_success_message_prime

    la a0, message_success_not_prime
    j print_message

print_success_message_prime:
    la a0, message_success_prime
    j print_message

print_error_message_input_not_a_number: 
    la a0, message_error_input_not_a_number
    j print_message

print_error_message_input_not_positive_number: 
    la a0, message_error_input_not_positive_number
    j print_message

print_error_message_input_too_high: 
    la a0, message_error_input_too_high
    j print_message

print_message:
    call printf

    # We store the return value in a0. We store 0 to indicate success.
    li a0, 0

    # Function epilogue: we need to restore the value of the return address from
    # the stack, and the value of the stack pointer.
    ld ra, 0(sp)
    addi sp, sp,8

    # Return to the caller (return FROM the `main` subroutine)
    ret

# sieve of Erastosthenes
# input: register a0 points to number n that is checked if it is a prime.
# output: if n is prime a0 is one else zero
sieve:
    # a0 contains the address where the number n is stored, not the value of n
    # itself. We read the value of n from memory into t1.
    lw t1, 0(a0)
    li t2, 2            # counter start with 2
    # Initialize an array with numbers
    la t3, array        # pointer to the first address of an array

sieve_0:
    sw t2, 8(t3)      # set item to index, 8() is begin with index 2
    addi t3, t3, 4      # increment by four for word size
    addi t2, t2, 1      # counter
    ble t2, t1, sieve_0   # until counter == number to check

    # array has now the values: 0 0 2 3 4 5 6 7 8 9 10...

    # non-primes are cancelled out by setting their array items to zero
    li t2, 2            # start with 2, t2 is index i
    la t3, array        # t3 is pointer to array

sieve_1:
    lw t4, 8(t3)      # t4 is current array item (offset by 2) 
    beqz t4, sieve_3       # no prime, continue at sieve_3

    mul t4, t2, t2      # t4 = t2 * t2; t4 is index j

sieve_2:
    slli t5, t4, 2      # t5 = t4 * 4 for offset (words) in array
    add t5, t3, t5     # t5 = t3 + t5; t5 is address in array for j
    sw x0, 0(t5)      # set entry to 0, no prime number, array[j] = 0
    add t4, t4, t2     # t4 = t4 + t2; j += i
    ble t4, t1, sieve_2   # cancel out all multiples of i for i < n

sieve_3:
    addi t2, t2, 1      # continue with next number
    mul t0, t2, t2     # as long as n*n > index
    ble t0, t1, sieve_1 

    slli t0, t1, 2      # use n as index
    add t0, t3, t0     # compute address in array
    lw t0, 0(t0)      # load its item
    snez a0, t0         # set a0 to 1 if array[n] != 0 

    # Return to the caller (return TO the `main` subroutine)
    ret

.section .rodata

message_error_input_not_a_number:
    .asciz "incorrect input. Please enter a number.\n"

message_error_input_not_positive_number:
    .asciz "incorrect input. Please enter a positive number.\n"

message_error_input_too_high:
    .asciz "incorrect input. Please enter a number <1048576.\n"

message_success_not_prime:
    .asciz "is not a prime number.\n" 

message_success_prime:
    .asciz "is a prime number.\n" 

prompt:
    .asciz "Enter a number (<1048576): \n"

scanfmt:
    .asciz "%d" # format specifier for a signed integer

.section .bss

# In riscv64 a register is 8 bytes long (64 bits), so we need to allocate 2
# words of memory (in RISC-V 1 word is 4 bytes).
input:
    .dword 0

array:
    .zero 4*MAX_NUM     # max number storage
