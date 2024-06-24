# Hello World

## Instructions

Assemble:

```sh
riscv64-elf-as -march rv64i -mabi lp64 -o hello.o hello.s
```

Link:

```sh
riscv64-elf-ld -o hello.elf --verbose hello.o
```

Execute:

```sh
qemu-riscv64 hello.elf
```

## Binary analysis

Command:

```sh
riscv64-elf-objdump -t -j .text hello.o
```

Output:

```sh
hello.o:     file format elf64-littleriscv

SYMBOL TABLE:
0000000000000000 l    d  .text     0000000000000000 .text
0000000000000000 g       .text     0000000000000000 _start
```

Command:

```sh
readelf --symbols hello.elf
```

Output:

```sh
Symbol table '.symtab' contains 20 entries:
   Num:    Value          Size Type    Bind   Vis      Ndx Name
     0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND
     1: 00000000000100b0     0 SECTION LOCAL  DEFAULT    1 .text
     2: 00000000000100d8     0 SECTION LOCAL  DEFAULT    2 .rodata
     3: 0000000000000000     0 SECTION LOCAL  DEFAULT    3 .riscv.attributes
     4: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS hello.o
     5: 0000000000000001     0 NOTYPE  LOCAL  DEFAULT  ABS STDOUT
     6: 0000000000000040     0 NOTYPE  LOCAL  DEFAULT  ABS WRITE
     7: 000000000000005d     0 NOTYPE  LOCAL  DEFAULT  ABS EXIT
     8: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  ABS EXIT_CODE_SUCCESS
     9: 00000000000100b0     0 NOTYPE  LOCAL  DEFAULT    1 $xrv64i2p1
    10: 00000000000100d8     0 NOTYPE  LOCAL  DEFAULT    2 buf_begin
    11: 00000000000100e6     0 NOTYPE  LOCAL  DEFAULT    2 buf_size
    12: 00000000000118e7     0 NOTYPE  GLOBAL DEFAULT  ABS __global_pointer$
    13: 00000000000110e7     0 NOTYPE  GLOBAL DEFAULT    2 __SDATA_BEGIN__
    14: 00000000000100b0     0 NOTYPE  GLOBAL DEFAULT    1 _start
    15: 00000000000110e8     0 NOTYPE  GLOBAL DEFAULT    2 __BSS_END__
    16: 00000000000110e7     0 NOTYPE  GLOBAL DEFAULT    2 __bss_start
    17: 00000000000110e7     0 NOTYPE  GLOBAL DEFAULT    2 __DATA_BEGIN__
    18: 00000000000110e7     0 NOTYPE  GLOBAL DEFAULT    2 _edata
    19: 00000000000110e8     0 NOTYPE  GLOBAL DEFAULT    2 _end
```

## Reference

- [RISC-V Linux syscall table](https://jborza.com/post/2021-05-11-riscv-linux-syscalls/)
- [RISC-V Register Definitions](https://msyksphinz-self.github.io/riscv-isadoc/html/regs.html)
- [Registers - RISC-V (WikiChip)](https://en.wikichip.org/wiki/risc-v/registers)
