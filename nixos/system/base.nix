{ lib, pkgs, ... }:

{
  time.timeZone = "Asia/Tokyo";

  console = {
    font = "ter-p24b";
    packages = [ pkgs.terminus_font ];
    useXkbConfig = true;
  };

  services.xserver.xkb.layout = "jp";
  services.libinput.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "aseprite"
      # "steam"
      # "steam-unwrapped"
    ];

  system.stateVersion = "26.05";
}
