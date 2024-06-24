# Exit code

## Instructions

Assemble:

```sh
riscv64-elf-as -march rv64i -mabi lp64 -o exit-code.o exit-code.s
```

Link:

```sh
riscv64-elf-ld -o exit-code.elf --verbose exit-code.o
```

Execute:

```sh
qemu-riscv64 exit-code.elf
```

Check that the exit status code was `7`:

```sh
echo $?
```

## ELF analysis

Command:

```sh
readelf --symbols exit-code.elf
```

Output:

```sh
Symbol table '.symtab' contains 14 entries:
   Num:    Value          Size Type    Bind   Vis      Ndx Name
     0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND
     1: 00000000000100b0     0 SECTION LOCAL  DEFAULT    1 .text
     2: 0000000000000000     0 SECTION LOCAL  DEFAULT    2 .riscv.attributes
     3: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS exit-code.o
     4: 000000000000005d     0 NOTYPE  LOCAL  DEFAULT  ABS EXIT
     5: 00000000000100b0     0 NOTYPE  LOCAL  DEFAULT    1 $xrv64i2p1
     6: 00000000000118bc     0 NOTYPE  GLOBAL DEFAULT  ABS __global_pointer$
     7: 00000000000110bc     0 NOTYPE  GLOBAL DEFAULT    1 __SDATA_BEGIN__
     8: 00000000000100b0     0 NOTYPE  GLOBAL DEFAULT    1 _start
     9: 00000000000110c0     0 NOTYPE  GLOBAL DEFAULT    1 __BSS_END__
    10: 00000000000110bc     0 NOTYPE  GLOBAL DEFAULT    1 __bss_start
    11: 00000000000110bc     0 NOTYPE  GLOBAL DEFAULT    1 __DATA_BEGIN__
    12: 00000000000110bc     0 NOTYPE  GLOBAL DEFAULT    1 _edata
    13: 00000000000110c0     0 NOTYPE  GLOBAL DEFAULT    1 _end
```
