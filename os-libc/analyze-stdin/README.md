# Analyze input from stdin

This is an exercise of Chapter 5 of [Foundations of RISC-V Assembly Programming](https://learning.edx.org/course/course-v1:LinuxFoundationX+LFD117x+2T2024/home).

Write a program that analyzes the input given by stdin. The program should count the number of decimals, number of letters, and number of non-letter characters:

- Write a loop that reads in the text by the C function getchar and breaks the loop by EOF.
- Check each input character if it is a decimal, letter, or none of both.
- Increment counters for the result of the checks.
- Use the C function printf for printing the results.

Assemble and link the program:

```sh
zig cc analyze-stdin.s -o analyze-stdin.elf -target riscv64-linux -lc
```

Execute the program:

```sh
qemu-riscv64 analyze-stdin.elf
```

Press `Ctrl+d` to exit this "input mode" and let the program communicate the result.
