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
      man-pages-posix
      man-pages
    ]
  );
  documentation.man.cache.enable = true;
}
