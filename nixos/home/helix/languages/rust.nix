{ pkgs }:
let
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
