{ pkgs }:

let
  helixJava = import ../../helix/languages/java.nix { inherit pkgs; };
  helixJdtls = helixJava.language-server.jdtls;
in
{
  name = "Java";
  language.language_servers = helixJava.language.language-servers;
  lsp.jdtls.binary = {
    path = helixJdtls.command;
    arguments = [ ];
  };
}
