{ pkgs, ... }:

let
  helixVale = import ../home/helix/languages/vale.nix { inherit pkgs; };
in
{
  environment.variables.VALE_CONFIG_PATH = helixVale.configFile;
}
