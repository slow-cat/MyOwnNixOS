{ pkgs }:

let
  helixRust = import ../../helix/languages/rust.nix { inherit pkgs; };
  helixRustAnalyzer = helixRust.language-server.rust-analyzer;
in
{
  name = "Rust";
  language.language_servers = helixRust.language.language-servers;
  lsp.rust-analyzer = {
    binary = {
      path = helixRustAnalyzer.command;
      arguments = helixRustAnalyzer.args;
    };
    initialization_options = helixRustAnalyzer.config;
  };
}
