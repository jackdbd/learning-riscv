# Linked list

Assemble and link the program:

```sh
zig cc linked-list.s -o linked-list.elf -target riscv64-linux -lc
```

Execute the program:

```sh
qemu-riscv64 linked-list.elf
```

Assemble and link the program:

```sh
zig cc main.s linkedlist.s linkedlist_struct.s -o main.elf -target riscv64-linux -lc
```

Execute the program:

```sh
qemu-riscv64 linked-list.elf
qemu-riscv64 main.elf
```
