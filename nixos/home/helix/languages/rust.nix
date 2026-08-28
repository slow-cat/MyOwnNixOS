{ inputs, pkgs }:
let
  rustPackages = pkgs.extend inputs.rust-overlay.overlays.default;
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
    rustNightly
  ];
  language-server.rust-analyzer = {
    command = "${pkgs.rustup}/bin/rustup";
    args = [
      "run"
      "nightly"
      "rust-analyzer"
    ];
    config = {
      checkOnSave.enable = true;
      procMacro.enable = true;
      cargo = {
        enable = true;
        buildScripts.enable = true;
      };
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
