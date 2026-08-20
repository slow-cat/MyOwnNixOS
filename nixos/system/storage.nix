{
  host,
  lib,
  ...
}:

{
  zramSwap = {
    enable = !host.isQemu;
    memoryPercent = 100;
  };

  fileSystems."/etc/nixos" = lib.mkIf host.isQemu {
    device = "nixos";
    fsType = "9p";
    options = [
      "trans=virtio"
      "rw"
    ];
  };
}
