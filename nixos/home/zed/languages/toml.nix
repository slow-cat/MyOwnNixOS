{ pkgs }:

let
  helixToml = import ../../helix/languages/toml.nix { inherit pkgs; };
  helixTaplo = helixToml.language-server.taplo;
in
{
  name = "TOML";
  language.language_servers = helixToml.language.language-servers;
  lsp.taplo.binary = {
    path = helixTaplo.command;
    arguments = helixTaplo.args;
  };
}
