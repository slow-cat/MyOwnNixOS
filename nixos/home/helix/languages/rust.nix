{ pkgs }:
let
  muslCc = pkgs.pkgsCross.musl64.stdenv.cc;
  muslGcc = "${muslCc}/bin/${muslCc.targetPrefix}gcc";
  rustOverlay = import (fetchGit {
    url = "https://github.com/oxalica/rust-overlay.git";
    ref = "master";
    shallow = true;
  });
  rustPackages = pkgs.extend rustOverlay;
  rustStable = rustPackages.rust-bin.stable."1.89.0".minimal.override {
    extensions = [
      "clippy"
      "rust-analyzer"
      "rust-src"
      "rustfmt"
    ];
  };
  rustNightly = rustPackages.rust-bin.selectLatestNightlyWith (
    toolchain:
    toolchain.minimal.override {
      extensions = [
        "clippy"
        "rust-analyzer"
        "rust-src"
        "rustfmt"
      ];
      targets = [
        "wasm32-unknown-unknown"
        "x86_64-unknown-linux-musl"
      ];
    }
  );
in
{

  packages = [
    pkgs.openssl
    pkgs.pkg-config
    pkgs.rustup
  ];
  home.sessionVariables.PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  # Run the compiler on glibc while producing code for musl.
  home.sessionVariables.CC_x86_64_unknown_linux_musl = muslGcc;
  home.sessionVariables.CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_LINKER = muslGcc;
  activation = ''
    $DRY_RUN_CMD ${pkgs.rustup}/bin/rustup toolchain link nix-1.89 ${rustStable}
    $DRY_RUN_CMD ${pkgs.rustup}/bin/rustup toolchain link nix-nightly ${rustNightly}
    $DRY_RUN_CMD ${pkgs.rustup}/bin/rustup default nix-nightly
  '';
  language-server.rust-analyzer = {
    command = "${pkgs.rustup}/bin/rust-analyzer";
    args = [ ];
    config = {
      checkOnSave = true;
      procMacro.enable = true;
      cargo.buildScripts.enable = true;
      files.excludeDirs = [
        "target"
        ".git"
        ".direnv"
      ];
    };
  };
  language = {
    name = "rust";
    language-servers = [
      "rust-analyzer"
      "typos"
    ];
  };
}
