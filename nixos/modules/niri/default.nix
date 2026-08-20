{
  config,
  host,
  pkgs,
  ...
}:

let
  modKey = if host.isQemu then "Alt" else "Super";

  qr = import ./features/qr.nix { inherit pkgs; };
  ocr = import ./features/ocr.nix { inherit pkgs; };
  clipboardRunner = import ./features/clipboard.nix { inherit pkgs; };

  fragments = {
    layout = import ./kdl/layout.nix;
    input = import ./kdl/input.nix { inherit modKey; };
    bindings = builtins.readFile ./kdl/bindings.kdl;
    startup = import ./kdl/startup.nix;
    screencast = import ./kdl/screencast.nix;
    float = import ./kdl/float.nix;
    qr = qr.kdl;
    ocr = ocr.kdl;
    cursor = import ./kdl/cursor.nix { inherit config; };
  };
  fragmentFiles = {
    layout = pkgs.writeText "config_layout.kdl" fragments.layout;
    input = pkgs.writeText "config_io.kdl" fragments.input;
    bindings = pkgs.writeText "config_bind.kdl" fragments.bindings;
    startup = pkgs.writeText "config_startup.kdl" fragments.startup;
    screencast = pkgs.writeText "config_screencast.kdl" fragments.screencast;
    float = pkgs.writeText "config_float.kdl" fragments.float;
    qr = pkgs.writeText "config_qr.kdl" fragments.qr;
    ocr = pkgs.writeText "config_ocr.kdl" fragments.ocr;
    cursor = pkgs.writeText "config_cursor.kdl" fragments.cursor;
  };

  uncheckedNiriConfig = pkgs.writeText "niri-config.kdl" ''
    prefer-no-csd

    include "${fragmentFiles.layout}"
    include "${fragmentFiles.input}"
    include "${fragmentFiles.bindings}"
    include "${fragmentFiles.startup}"
    include "${fragmentFiles.screencast}"
    include "${fragmentFiles.float}"
    include "${fragmentFiles.qr}"
    include "${fragmentFiles.ocr}"
    include "${fragmentFiles.cursor}"
  '';

  validatedNiriConfig =
    pkgs.runCommand "validated-niri-config.kdl"
      {
        nativeBuildInputs = [ config.programs.niri.package ];
      }
      ''
        cp ${uncheckedNiriConfig} "$out"
        niri validate --config "$out"
      '';
in
{
  programs.niri.enable = true;

  environment.sessionVariables = {
    NIRI_CONFIG = toString validatedNiriConfig;
    NIXOS_OZONE_WL = "1";
  };

  systemd.user.services.niri.environment.NIRI_CONFIG = toString validatedNiriConfig;

  environment.systemPackages = with pkgs; [
    dash
    brightnessctl
    pulseaudio
    swayidle
    wl-clipboard
    grim
    slurp
    ocr.tesseract
    zenity
    jq
    qrencode
    xwayland-satellite
    ironbar
  ];

  security.pam.services.swaylock = { };
  hardware.bluetooth.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  systemd.user.services.niri-swayidle = {
    description = "Idle management for niri";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
  };

  systemd.user.services.niri-clipboard-sync = {
    description = "Wayland primary-selection to clipboard sync";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = clipboardRunner;
      Restart = "on-failure";
    };
  };
}
