{
  config,
  lib,
  pkgs,
  ...
}:

let
  stylixColors = config.lib.stylix.colors;
  stylixHex = stylixColors.withHashtag;
  ironbarFont = config.stylix.fonts.monospace.name;

  elements = import ./elements {
    inherit
      lib
      pkgs
      stylixColors
      stylixHex
      ironbarFont
      ;
  };
  ironbarAssets = pkgs.runCommand "ironbar-assets" { } ''
    mkdir -p "$out"
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: path: ''ln -s ${path} "$out/${name}"'') elements.assets
    )}
  '';
  ironbarConfig = pkgs.writeText "ironbar-config.corn" ''
        let {
            $config_dir = "${ironbarAssets}"
    ${elements.corn}
        } in {
    ${import ./bar.nix}
        }
  '';
  ironbarCss = pkgs.writeText "ironbar-style.css" (
    (import ./theme.nix { inherit stylixHex ironbarFont; }) + "\n" + elements.css
  );
in
{
  environment.systemPackages = with pkgs; [
    ironbar
    brightnessctl
    ripgrep
    procps
    paper-icon-theme
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  environment.sessionVariables = {
    IRONBAR_CONFIG = toString ironbarConfig;
    IRONBAR_CSS = toString ironbarCss;
  };

  systemd.user.services.ironbar = {
    description = "Ironbar";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    restartTriggers = [
      ironbarConfig
      ironbarCss
      ironbarAssets
    ];
    environment = {
      IRONBAR_CONFIG = toString ironbarConfig;
      IRONBAR_CSS = toString ironbarCss;
    };
    serviceConfig = {
      ExecStart = "${pkgs.ironbar}/bin/ironbar";
      Restart = "on-failure";
    };
  };
}
