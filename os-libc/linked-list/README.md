# Linked list

Assemble and link the RISC-V assembly demo:

```sh
zig cc demo.s linkedlist.s linkedlist_struct.s \
  -o demo.elf -target riscv64-linux -lc
```

Execute the program:

```sh
qemu-riscv64 demo.elf
```

Compile the Zig demo:

```sh
zig build-exe demo-singly-linked-list.zig \
  -lc -target riscv64-linux
```

> [!TIP]
> If zig fails to compile, see [this issue](https://github.com/ziglang/zig/issues/5558) and read [this article](https://www.sifive.com/blog/all-aboard-part-4-risc-v-code-models) and [this thread](https://ziggit.dev/t/linking-fails-on-risc-v/2679).

Execute the Zig demo:

```sh
qemu-riscv64 demo-singly-linked-list
```

Produce `demo-singly-linked-list.s` from the Zig demo:

```sh
zig build-obj demo-singly-linked-list.zig \
  -femit-asm -lc -target riscv64-linux
```
