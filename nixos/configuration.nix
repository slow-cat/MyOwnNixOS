{
  _module.args.host = {
    isQemu = false;
  }
  // (if builtins.pathExists /etc/nixos/host.nix then import /etc/nixos/host.nix else { });

  imports = [
    /etc/nixos/hardware-configuration.nix
    ./system
    ./modules/stylix.nix
    ./modules/ironbar
    ./modules/niri
    ./modules/vale.nix
    ./modules/latex.nix
    ./home/home.nix
  ]
  # ++ [ ./modules/steam.nix ]
  ;
}
