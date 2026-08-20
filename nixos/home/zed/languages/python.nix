{ pkgs }:

let
  helixPython = import ../../helix/languages/python.nix { inherit pkgs; };
  helixRuff = helixPython.language-server.ruff;
  helixTy = helixPython.language-server.ty;
in
{
  name = "Python";
  language.language_servers = helixPython.language.language-servers;
  lsp = {
    ruff.binary = {
      path = helixRuff.command;
      arguments = helixRuff.args;
    };
    ty.binary = {
      path = helixTy.command;
      arguments = helixTy.args;
    };
  };
}
