{
  host,
  lib,
  pkgs,
  ...
}:

{
  environment.systemPackages = lib.optionals (!host.isQemu) [ pkgs.freerdp ];
}
