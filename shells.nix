# development shells for different tech stacks.
# usage: `nix develop .#<name>` from this repo.
#
# packages are only downloaded when the shell is first used,
# so adding shells here has no impact on system size.
#
# TODO: create a global alias/script (e.g., `devsh <name>`) that works
# from any directory by pointing to this flake's path.

{ pkgs, ... }:
let
  mkShell = pkgs.mkShell;
in
{
  # base tools for working with this repo.
  # includes secrets management and pre-commit hooks.
  default = mkShell {
    packages = with pkgs; [
      sops
      age
      cachix
      flake-checker
      pre-commit
    ];
    shellHook = ''
      pre-commit install --install-hooks -t pre-commit 2>/dev/null || true
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
