{ pkgs }:

{
  packages = [ pkgs.rustup ];
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
