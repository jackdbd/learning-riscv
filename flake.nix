{
  description = "Zig project flake";

  inputs = {
    alejandra = {
      url = "github:kamadorueda/alejandra/3.0.0";
    };
    zig2nix.url = "github:Cloudef/zig2nix";
  };

  outputs = {
    zig2nix,
    self,
    ...
  }: let
    flake-utils = zig2nix.inputs.flake-utils;
  in (flake-utils.lib.eachDefaultSystem (system: let
    # Zig flake helper
    # Check the flake.nix in zig2nix project for more options:
    # https://github.com/Cloudef/zig2nix/blob/master/flake.nix
    # https://github.com/Cloudef/zig2nix/blob/master/versions.json
    env = zig2nix.outputs.zig-env.${system} {
      # TODO: We would need to tie the zig version to the zls version
      # Example: Zig vers. 0.13.0 should be used with ZLS vers. 0.13.0.
      # I think it shouldn't be too hard. I guess I just need to download the
      # specific ZLS version from the GitHub releases.
      # https://github.com/zigtools/zls
      zig = zig2nix.outputs.packages.${system}.zig."0.13.0".bin;
      # zig = zig2nix.outputs.packages.${system}.zig.default.bin;
      # zig = zig2nix.outputs.packages.${system}.zig.master.bin;
    };

    system-triple = env.lib.zigTripleFromString system;
  in
    with builtins;
    with env.lib;
    with env.pkgs.lib; rec {
      # nix build .#target.{zig-target}
      # e.g. nix build .#target.x86_64-linux-gnu
      packages.target = genAttrs allTargetTriples (target:
        env.packageForTarget target ({
            src = cleanSource ./.;

            nativeBuildInputs = with env.pkgs; [];
            buildInputs = with env.pkgsForTarget target; [];

            # Smaller binaries and avoids shipping glibc.
            zigPreferMusl = true;

            # This disables LD_LIBRARY_PATH mangling, binary patching etc...
            # The package won't be usable inside nix.
            zigDisableWrap = true;
          }
          // optionalAttrs (!pathExists ./build.zig.zon) {
            pname = "my-zig-project";
            version = "0.0.0";
          }));

      # nix build .
      packages.default = packages.target.${system-triple}.override {
        # Prefer nix friendly settings.
        zigPreferMusl = false;
        zigDisableWrap = false;
      };

      # For bundling with nix bundle for running outside of nix
      # example: https://github.com/ralismark/nix-appimage
      apps.bundle.target = genAttrs allTargetTriples (target: let
        pkg = packages.target.${target};
      in {
        type = "app";
        program = "${pkg}/bin/default";
      });

      devShells.default = env.mkShell {
        packages = with env.pkgs; [
          # coreboot toolchain for riscv targets
          coreboot-toolchain.riscv

          # Cowsay reborn, just for fun
          # https://github.com/Code-Hex/Neo-cowsay
          neo-cowsay

          # machine & userspace emulator and virtualizer
          # https://www.qemu.org/docs/master/
          qemu

          # graphical processor simulator and assembly editor for the RISC-V ISA
          # https://github.com/mortbopet/Ripes
          ripes
        ];

        shellHook = ''
          cowthink "Nix rocks!" --bold -f tux --rainbow
          printf "\n$(qemu-riscv64 --version)\n"
          printf "\n$(riscv64-elf-objdump --version)\n"
          printf "\nZig version $(zig version)\n\n"

          # export FOO=bar
        '';
        # FOO = "bar";
      };
    }));
}
