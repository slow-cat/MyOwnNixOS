{ config, host, ... }:
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
    firewall = {
      enable = true;
      trustedInterfaces = [ config.services.tailscale.interfaceName ];
      allowedUDPPorts = [ config.services.tailscale.port ];
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
  services.tailscale = {
    enable = true;
  };
  # This avoids the "iptables-compat" translation layer issues.
  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];
  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;
  systemd.network.links = {
    "30-random-mac" = {
      matchConfig.OriginalName = "enp0s20f0u2";
      linkConfig = {
        MACAddressPolicy = "random";
      };
    };
  };
}
