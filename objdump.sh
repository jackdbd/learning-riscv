#!/usr/bin/env bash 

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euxo pipefail

NAME=$1

# riscv64-elf-readelf --all "out/$NAME"
riscv64-elf-objdump --all "out/$NAME"

# riscv64-elf-objdump -ds out/hello
# -d,--disassemble
# -s,--full-contents