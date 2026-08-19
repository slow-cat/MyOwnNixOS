{
  config,
  lib,
  pkgs,
  ...
}:

import ./ironbar/default.nix { inherit config lib pkgs; }
