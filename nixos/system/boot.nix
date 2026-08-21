{
  host,
  pkgs,
  ...
}:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = if host.isQemu then [ "console=ttyS0,115200n8" ] else [ ];
    loader =
      if host.isQemu then
        {
          timeout = 0;
          grub = {
            enable = true;
            efiSupport = false;
            devices = [ "/dev/sda" ];
          };
        }
      else
        {
          timeout = 5;
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };
  };
}
