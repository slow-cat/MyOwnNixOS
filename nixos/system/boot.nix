{
  host,
  pkgs,
  ...
}:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = if host.isQemu then [ "console=ttyS0,115200n8" ] else [ ];
    loader.timeout = if host.isQemu then 0 else 5;
    loader.grub = {
      enable = true;
      efiSupport = false;
      devices = [ "/dev/sda" ];
    };
  };
}
