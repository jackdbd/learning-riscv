# OS with libc

These examples run in an environment where an operating system is present (i.e. we can make syscalls to the Linux kernel), and rely on the presence of a C standard library.

Compile and link these programs using the Zig toolchain.

```sh
zig cc wordcount.s -o wordcount.elf -target riscv64-linux -lc
```

The generated RISC-V ELF binary should have a `main` symbol in its symbol table (in the `.text` section).

```sh
riscv64-elf-objdump -t -j .text wordcount.elf | grep main
```
