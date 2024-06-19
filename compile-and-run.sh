#!/usr/bin/env bash 

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euo pipefail

NAME=$1
rm -rf "out/$NAME.o" "out/$NAME"

# The coreboot-toolchain.riscv package I installed (see flake.nix) provides a
# RISC-V toolchain without a specific sysroot configured. This package is meant
# for bare-metal development rather than for linking against the C standard
# library.
# printf "Compiling and linking progran \"$NAME\" using the Coreboot toolchain\n"
# riscv64-elf-as -o "out/$NAME.o" "src/$NAME.s"
# riscv64-elf-ld -o "out/$NAME" "out/$NAME.o"

# QEMU_LD_PREFIX= (or use qemu-riscv64 -L)
# QEMU_LOG= (or use qemu-riscv64 -d)
# QEMU_LOG_FILENAME= (or use qemu-riscv64 -D)

# The Zig toolchain includes a sysroot for RISC-V Linux. We just have to take
# care of linking againstg the C standard library using the -lc flag. Compiling
# RISC-V bare-metal programs (the ones that have _start as the entry point)
# gives me this linker error: duplicate symbol: _start
# Maybe I can use the workaround suggestion here:
# https://github.com/ziglang/zig/issues/5320#issuecomment-1426664567
# Compiling RISC-V programs that have main as the entry point works fine.
printf "Compiling and linking program \"$NAME\" using the Zig toolchain\n"
zig cc "src/$NAME.s" -o "out/$NAME" -target riscv64-linux -lc

if [ $? -eq 0 ]; then
    echo "Compilation successful."
    echo "Running \"out/$NAME\" with QEMU..."
    qemu-riscv64 "out/$NAME"
else
    echo "Compilation failed."
fi


