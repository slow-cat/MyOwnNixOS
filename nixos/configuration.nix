{
  _module.args.host = import ./host.nix;

  imports = [
    /etc/nixos/hardware-configuration.nix
    ./system
    ./modules/stylix.nix
    ./modules/ironbar
    ./modules/niri
    ./modules/vale.nix
    ./home/home.nix
  ];
}
