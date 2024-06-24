# OS without libc

These examples run in an environment where an operating system is present (i.e. we can make syscalls to the Linux kernel), but do not rely on the presence of a C standard library.

Compile and link these programs using the Coreboot RISC-V toolchain.

```sh
riscv64-elf-as -march rv64i -mabi lp64 -o hello.o hello.s
riscv64-elf-ld -o hello.elf --verbose hello.o
```

The generated RISC-V ELF binary should have a `_start` symbol in its symbol table, and no `main` symbol.

```sh
riscv64-elf-objdump -t -j .text hello.elf | grep _start
riscv64-elf-objdump -t hello.elf | grep main
```
