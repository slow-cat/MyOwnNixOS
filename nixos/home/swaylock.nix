{ pkgs, ... }:

let
  swaylockSource = pkgs.fetchgit {
    url = "https://github.com/slow-cat/swaylock.git";
    rev = "59489e02657bdcd7e4fdb1dba6990eabaac2a367";
    hash = "sha256-r0IFU9njNriGezzneObQbiMok07O7TsbZB4qwtcmHtQ=";
  };

  swaylock = pkgs.swaylock.overrideAttrs (oldAttrs: {
    version = "1.8.6-lua-59489e0";
    src = swaylockSource;
    buildInputs = oldAttrs.buildInputs ++ [ pkgs.luajit ];
  });

  lockCommand = "${swaylock}/bin/swaylock -f";
in
{
  programs.swaylock = {
    enable = true;
    package = swaylock;
    settings.lua-script = "${swaylockSource}/examples/fractal-tree.lua";
  };

  services.swayidle = {
    enable = true;
    systemdTargets = [ "graphical-session.target" ];
    timeouts = [
      {
        timeout = 600;
        command = lockCommand;
      }
      {
        timeout = 601;
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
        resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
      }
    ];
    events."before-sleep" = lockCommand;
  };
}
