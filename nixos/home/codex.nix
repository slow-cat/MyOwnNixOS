{ pkgs, ... }:

{
  home.packages = [ (import ./codex-bin.nix { inherit pkgs; }) ];
}
