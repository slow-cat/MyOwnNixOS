{ pkgs }:

let
  helixC = import ../../helix/languages/c.nix { inherit pkgs; };
  helixClangd = helixC.language-server.clangd;
in
{
  name = "C";
  language.language_servers = helixC.language.language-servers;
  lsp.clangd.binary = {
    path = helixClangd.command;
    arguments = helixClangd.args;
  };
}
