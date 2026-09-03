{ host, ... }:
let
  dispatcher =
    if builtins.pathExists /etc/nixos/private_dispatcher.nix then
      import /etc/nixos/private_dispatcher.nix
    else
      { };
in
{
  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = host.isQemu;
      wifi.backend = "iwd";
    };
    useNetworkd = !host.isQemu;
    useDHCP = !host.isQemu;
    wireless.iwd = {
      enable = true;
      settings.Settings.AutoConnect = !host.isQemu;
    };
  };
  services.resolved.enable = !host.isQemu;
  services.networkd-dispatcher = dispatcher;
  services.openssh = {
    enable = host.isQemu;
    openFirewall = host.isQemu;
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = true;
    };
  };
}
