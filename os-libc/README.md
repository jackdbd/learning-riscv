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

Execute the ELF binary:

```sh
qemu-riscv64 wordcount.elf
```

If you want to see the dynamic library calls made by this program, use [ltrace](https://gitlab.com/cespedes/ltrace) and redirect all of its output to a file.

```sh
ltrace qemu-riscv64 wordcount.elf 2> ltrace.txt
```

Compile and execute all other programs in the same way.

```sh
zig cc average.s -o average.elf -target riscv64-linux -lc
qemu-riscv64 average.elf
# or
qemu-riscv64 average.elf < numbers.txt
```

```sh
zig cc djb2.s -o djb2.elf -target riscv64-linux -lc
qemu-riscv64 djb2.elf
```

```sh
zig cc prime.s -o prime.elf -target riscv64-linux -lc
qemu-riscv64 prime.elf
```
