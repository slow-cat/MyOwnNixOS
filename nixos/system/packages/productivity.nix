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
      himalaya
      apostrophe
      pympress
    ]
  );
}
