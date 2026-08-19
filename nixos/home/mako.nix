{ config, ... }:

{
  services.mako.enable = true;

  systemd.user.services.mako = {
    Unit = {
      Description = "Mako notification daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart = "${config.services.mako.package}/bin/mako";
      Restart = "on-failure";
    };
  };
}
