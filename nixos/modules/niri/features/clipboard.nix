{ pkgs }:

pkgs.writeShellScript "niri-clipboard-sync" ''
  exec ${pkgs.wl-clipboard}/bin/wl-paste -pw ${pkgs.wl-clipboard}/bin/wl-copy
''
