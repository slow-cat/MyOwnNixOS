{ pkgs }:

let
  script = pkgs.writeShellApplication {
    name = "niri-config-qr-focused";
    runtimeInputs = with pkgs; [
      coreutils
      imv
      jq
      niri
      qrencode
      wl-clipboard
    ];
    text = builtins.readFile ./qr-focused.sh;
  };
in
{
  inherit script;
  kdl = ''
    binds{
        Mod+Q repeat=false{ spawn "${script}/bin/niri-config-qr-focused"; }
    }
    window-rule {
        match app-id=r#"^imv$"# title="^QRFloatingWindow$"
        open-floating true
        default-column-width { fixed 500; }
        default-window-height { fixed 500; }
        geometry-corner-radius 0
    }
  '';
}
