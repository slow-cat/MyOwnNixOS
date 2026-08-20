{ pkgs }:

let
  helixCpp = import ../../helix/languages/cpp.nix { inherit pkgs; };
in
{
  name = "C++";
  language.language_servers = helixCpp.language.language-servers;
}
