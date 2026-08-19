{
  config,
  pkgs,
  ...
}:

import ./niri/default.nix { inherit config pkgs; }
