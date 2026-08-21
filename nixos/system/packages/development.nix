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
      strace
      silicon
    ]
  );
}
