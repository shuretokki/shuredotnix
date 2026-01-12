# development shells for different tech stacks.
# usage: `nix develop .#<name>` from this repo.
#
# packages are only downloaded when the shell is first used,
# so adding shells here has no impact on system size.
#
# TODO: create a global alias/script (e.g., `devsh <name>`) that works
# from any directory by pointing to this flake's path.

{ pkgs, repo, alias, ... }:
let
  mkShell = pkgs.mkShell;
  sdnpkgs = import ./pkgs { inherit pkgs repo alias; };

  menu = pkgs.writeShellScriptBin "menu" ''
    echo -e "\n\033[1;34m[SDN] Available commands:\033[0m"
    echo -e "  \033[1;32mmenu\033[0m           - Show this help"
    echo -e "  \033[1;32m${alias}-update\033[0m     - Run system update pipeline"
    echo -e "  \033[1;32m${alias}-init-host\033[0m  - Scaffold a new host/device"
    echo -e "  \033[1;32mdetect-gpu\033[0m     - Scan hardware for GPU profiles"
    echo -e "  \033[1;32mdetect-boot-uuids\033[0m - Scan for dual-boot UEFI UUIDs"
    echo -e "\n\033[1;34m[Maintenance]\033[0m"
    echo -e "  \033[1;32mstatix check\033[0m   - Lint the repository"
    echo -e "  \033[1;32mnixfmt .\033[0m       - Format all nix files"
  '';
in
{
  # base tools for working with this repo.
  # includes secrets management, maintenance tools, and repo scripts.
  default = mkShell {
    packages = (with pkgs; [
      sops
      age
      cachix
      nixfmt-rfc-style
      nil
      statix
      deadnix
      menu
    ]) ++ (builtins.attrValues sdnpkgs);

    shellHook = ''
      echo -e "\033[1;32m[OK] dotnix developer environment loaded.\033[0m"
      echo -e "Type \033[1;32mmenu\033[0m to see available repository tools."
    '';
  };

  # data science and machine learning.
  # includes python with common libs and uv for fast package management.
  python = mkShell {
    packages = with pkgs; [
      (python3.withPackages (ps: with ps; [
        pandas
        numpy
        matplotlib
        ipykernel
        jupyterlab
      ]))
      uv
    ];
  };

  # frontend and backend web development.
  # includes node, pnpm, bun, and language servers for vscode/neovim.
  web = mkShell {
    packages = with pkgs; [
      nodejs
      nodePackages.pnpm
      bun
      typescript
      typescript-language-server
      vscode-langservers-extracted # html/css/json
    ];
  };

  # systems programming with rust.
  # includes cargo, rustc, analyzer, and gcc for linking native deps.
  rust = mkShell {
    packages = with pkgs; [
      cargo
      rustc
      rust-analyzer
      rustfmt
      clippy
      gcc
    ];
  };

  # cloud and backend with go.
  # includes gopls for lsp and golangci-lint for linting.
  go = mkShell {
    packages = with pkgs; [
      go
      gopls
      gotools
      golangci-lint
    ];
  };

  # c/c++ and embedded systems.
  # includes gcc, cmake, gdb for debugging, valgrind for memory checks.
  c = mkShell {
    packages = with pkgs; [
      gcc
      gnumake
      cmake
      gdb
      valgrind
      clang-tools
    ];
  };
}
