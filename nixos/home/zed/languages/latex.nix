{ pkgs }:

let
  helixLatex = import ../../helix/languages/latex.nix { inherit pkgs; };
  helixTexlab = helixLatex.language-server.texlab;
in
{
  name = "LaTeX";
  language.language_servers = helixLatex.language.language-servers;
  lsp.texlab.binary = {
    path = helixTexlab.command;
    arguments = [ ];
  };
}
