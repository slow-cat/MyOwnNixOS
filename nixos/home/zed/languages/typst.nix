{ pkgs }:

let
  helixTypst = import ../../helix/languages/typst.nix { inherit pkgs; };
  helixTinymist = helixTypst.language-server.tinymist;
in
{
  name = "Typst";
  language.language_servers = helixTypst.language.language-servers;
  lsp.tinymist.binary = {
    path = helixTinymist.command;
    arguments = [ ];
  };
}
