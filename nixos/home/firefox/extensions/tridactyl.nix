{
  config,
  lib,
  pkgs,
  stylixHex,
  amo,
}:

let
  tridactylTheme =
    builtins.replaceStrings
      [
        "@monospaceFont@"
        "@sansSerifFont@"
        "@fontSize@"
        "@base00@"
        "@base01@"
        "@base02@"
        "@base05@"
        "@base0A@"
        "@base0B@"
        "@base0D@"
        "@base0E@"
      ]
      [
        config.stylix.fonts.monospace.name
        config.stylix.fonts.sansSerif.name
        (toString config.stylix.fonts.sizes.applications)
        stylixHex.base00
        stylixHex.base01
        stylixHex.base02
        stylixHex.base05
        stylixHex.base0A
        stylixHex.base0B
        stylixHex.base0D
        stylixHex.base0E
      ]
      (builtins.readFile ./tridactyl.css);

  tridactylRc = ''
    " Generated declaratively from the Stylix palette.
    colourscheme stylix
  '';
in
{
  extensionSettings."tridactyl.vim@cmcaine.co.uk" = {
    install_url = amo "tridactyl-vim";
    installation_mode = "force_installed";
    private_browsing = true;
  };

  xdgConfigFile = {
    "tridactyl/tridactylrc".text = tridactylRc;
    "tridactyl/themes/stylix.css".text = tridactylTheme;
  };

  nativeMessagingHosts = lib.optional (pkgs ? tridactyl-native) pkgs.tridactyl-native;
}
