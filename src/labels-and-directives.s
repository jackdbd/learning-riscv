# Define a constant called EXIT and assign the number 93 to it.
# On riscv32 and riscv64, 93 identifies the Linux exit syscall.
.equ EXIT, 93

# The .text section of an ELF binary contains machine code
.section .text
# Define a symbol called _start. The symbol _start is required to provide the
# program's entry point for the linker.
.globl  _start
_start:
    li a7, EXIT
    ecall

# The .data section of an ELF binary contains the default values of initialized
# variables. The .data section is marked as writable, so the values of these
# variables may change at runtime.
.section .data
counter:
    # Allocate one word and initialize it with the value 1. In RISC-V, a word of
    # memory is defined as 32 bits (4 bytes).
    .word 1

# The .rodata section of an ELF binary contains constant values. The .rodata
# section is marked as read-only, so these values cannot change at runtime.
.section .rodata
text_begin:
    # Define a null-terminated ASCII string.
    .asciz  "Hello World!\n"
text_length:
    # Current address (the .) minus address of text_begin = length of text.
    # We store the result in a 8-bit word using the .byte directive.
    .byte .-text_begin

# The .bss section of an ELF binary contains initialized values.
.section .bss 
# The .align directive aligns the memory address to a power of 2. So .align 2
# means a multiple of 2^2 = 4.
.align 2
copy_begin:
    # Allocate these bytes of memory and initialize them to zero.
    .zero text_length-text_begin
