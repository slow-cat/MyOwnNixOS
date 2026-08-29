{
  host,
  lib,
  pkgs,
  ...
}:

{
  environment.systemPackages = lib.optionals (!host.isQemu) (
    with pkgs;
    [
      wf-recorder
      wl-mirror
      nautilus
    ]
  );
}
