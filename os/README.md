# OS examples

Compile and link these programs using the Zig toolchain.

```sh
zig cc wordcount.s -o wordcount.elf -target riscv64-linux -lc
```

The generated RISC-V ELF binary should have a `main` symbol in its symbol table (in the `.text` section).

```sh
riscv64-elf-objdump -t -j .text wordcount.elf | grep main
```
