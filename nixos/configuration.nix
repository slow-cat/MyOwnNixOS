{
  imports = [
    ./hardware-configuration.nix
    ./system
    ./modules/stylix.nix
    ./modules/ironbar
    ./modules/niri
    ./modules/vale.nix
    ./home/home.nix
  ];
}
