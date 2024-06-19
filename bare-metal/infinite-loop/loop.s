.section .text.bios
.globl _start
.equ UART0, 0x10000000

_start:
    li a1, UART0

    addi a0, x0, 0x68 # 'h'
    sb a0, (a1)

    addi a0, x0, 0x65
    sb a0, (a1) # 'e'

    addi a0, x0, 0x6C
    sb a0, (a1) # 'l'

    addi a0, x0, 0x6C
    sb a0, (a1) # 'l'

    addi a0, x0, 0x6F
    sb a0, (a1) # 'o'
    
loop:
    j loop
