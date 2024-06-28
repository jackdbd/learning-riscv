# Learning RISC-V

This project contains small programs and notes to help me learn [RISC-V](https://riscv.org/).

## Register types

| ABI Register | Description | Saver | ABI Register | Description | Saver |
| --- | --- | --- | --- | --- | --- |
| zero | Zero | immutable | ra | Return address | not applicable |
| sp | Stack pointer | callee | gp | Global pointer | global |
| tp | Thread pointer | global | t0-t2, t3-t6 | Temporary registers | none |
| s0-s1, s2-s11 | Saved registers | callee | a0-a7 | Argument/return value | caller |

Reference: Table [Register Types](https://five-embeddev.com/quickref/regs_abi.html#register-types) on [Five EmbedDev](https://five-embeddev.com/).

## Unix ABI (UABI)

| Register | ABI Name | Description | Saver |
| :--- | :--- | :--- | :--- |
| x0 | zero | Hard-wired zero | — |
| x1 | ra | Return address | caller |
| x2 | sp | Stack pointer | callee |
| x3 | gp | Global pointer | — |
| x4 | tp | Thread pointer | — |
| x5-7 | t0-2 | Temporaries | caller |
| x8 | s0/fp | Saved register/frame pointer | callee |
| x9 | s1 | Saved register | callee |
| x10-11 | a0-1 | Function arguments/return values | caller |
| x12-17 | a2-7 | Function arguments | caller |
| x18-27 | s2-11 | Saved registers | callee |
| x28-31 | t3-6 | Temporaries | caller |
| f0-7 | ft0-7 | FP temporaries | caller |
| f8-9 | fs0-1 | FP saved registers | callee |
| f10-11 | fa0-1 | FP arguments/return values | caller |
| f12-17 | fa2-7 | FP arguments | caller |
| f18-27 | fs2-11 | FP saved registers | callee |
| f28-31 | ft8-11 | FP temporaries | caller |

Reference: Table RISC-V calling convention register usage in chapter [Calling Convention](https://riscv.org/wp-content/uploads/2015/01/riscv-calling.pdf).

## Reference

- [RISC-V Reference Card (PDF)](https://www.cl.cam.ac.uk/teaching/1516/ECAD+Arch/files/docs/RISCVGreenCardv8-20151013.pdf)
- [RISC-V Instruction Set Specifications](https://msyksphinz-self.github.io/riscv-isadoc/html/index.html)
- [RISC-V Linux syscall table](https://jborza.com/post/2021-05-11-riscv-linux-syscalls/)
- [RISC-V Assembler: Arithmetic](https://projectf.io/posts/riscv-arithmetic/)
- [RISC-V Add Immediate](https://msyksphinz-self.github.io/riscv-isadoc/html/rvi.html#addi)
- [RISC-V Load Immediate](https://quantaly.github.io/riscv-li/)
- [RISC-V Register Definitions](https://msyksphinz-self.github.io/riscv-isadoc/html/regs.html)
- [Registers - RISC-V (WikiChip)](https://en.wikichip.org/wiki/risc-v/registers)
- [What is the advantage of an x0 register?](https://www.reddit.com/r/RISCV/comments/qnacg2/what_is_the_advantage_of_an_x0_register/)
- [List of standard RISC-V pseudoinstructions](https://github.com/riscv-non-isa/riscv-asm-manual/blob/main/riscv-asm.md#-a-listing-of-standard-risc-v-pseudoinstructions)
- [RISC-V Instruction Set Manual](https://github.com/riscv/riscv-isa-manual)
- [RISC-V ISA Specifications (Volume 1, Unprivileged Specification and Volume 2, Privileged Specification)](https://riscv.org/technical/specifications/)
- [RISC-V ISA Manuals to HTML](https://five-embeddev.com/updates/2023/07/31/html-docs/)
- [RISC-V Assembly Programmer's Manual](https://github.com/riscv-non-isa/riscv-asm-manual/blob/main/riscv-asm.md)
- [Linux kernel system calls for all architectures](https://gpages.juszkiewicz.com.pl/syscalls-table/syscalls.html)
- [Five EmbedDev: An Embedded RISC-V Blog](https://five-embeddev.com/)
- [RiscV - Esercizi Base](https://chrisquack.medium.com/riscv-esercizi-base-a37c1830734a)
- [Processor Design #2: Introduction to RISC-V](https://www.linkedin.com/pulse/processor-design-2-introduction-risc-v-simon-southwell/)
- [RISC-V Reference (PDF)](https://www.cs.sfu.ca/~ashriram/Courses/CS295/assets/notebooks/RISCV/RISCV_CARD.pdf)
- [RISC-V Online Assembler](https://riscvasm.lucasteske.dev/)
- [RISC-V System call table](https://jborza.com/post/2021-05-11-riscv-linux-syscalls/)
- [The Magic of RISC-V Vector Processing (LaurieWired - YouTube)](https://youtu.be/Ozj_xU0rSyY?si=Ba6-AvblLUVcKzMW)
- [Understanding RISC-V Calling Convention (PDF)](https://www2.cs.sfu.ca/~ashriram/Courses/CS295/assets/notebooks/RISCV/RISCV_CALL.pdf)
- [Syscalls, exceptions, and
interrupts, …oh my! (PDF)](https://www.cs.cornell.edu/courses/cs3410/2019sp/schedule/slides/14-ecf-pre.pdf)
- [LearnRISC-V - YouTube](https://www.youtube.com/@LearnRISCV/videos)
- [RISC-V Directives](https://sourceware.org/binutils/docs/as/RISC_002dV_002dDirectives.html)
