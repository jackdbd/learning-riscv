# Recursion

## Instructions

Assemble:

```sh
riscv64-elf-as -march rv64i -mabi lp64 -o recursion.o recursion.s
```

Link:

```sh
riscv64-elf-ld -o recursion.elf --verbose recursion.o
```

Execute:

```sh
qemu-riscv64 recursion.elf
```

Check that the exit status code was `17`:

```sh
echo $?
```
