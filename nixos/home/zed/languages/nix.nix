{ pkgs }:

let
  helixNix = import ../../helix/languages/nix.nix { inherit pkgs; };
  helixNil = helixNix.language-server.nil;
  helixNixd = helixNix.language-server.nixd;
in
{
  name = "Nix";
  language = {
    language_servers = helixNix.language.language-servers ++ [ "nil" ];
    formatter = "language_server";
    format_on_save = "on";
  };

  lsp = {
    nixd = {
      binary = {
        path = helixNixd.command;
        arguments = [ ];
      };
      settings.nixd = helixNixd.config.nixd;
    };

    nil.binary = {
      path = helixNil.command;
      arguments = [ ];
    };
  };
}
