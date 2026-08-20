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
      wf-wf-recorder
      wl-wl-mirror
    ]
  );
}
