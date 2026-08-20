{
  declarativeExtensions,
  stylixHex,
  ...
}:

let
  extensionId = "addon@darkreader.org";
  extension = declarativeExtensions.darkreader-declarative;
  extensionXpi = "${extension}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${extensionId}.xpi";
in
{
  extensionSettings.${extensionId} = {
    installation_mode = "force_installed";
    install_url = "file://${extensionXpi}";
    updates_disabled = true;
    private_browsing = true;
  };

  policies."3rdparty".Extensions.${extensionId} = {
    enabled = true;
    enabledByDefault = true;
    changeBrowserTheme = false;
    syncSettings = false;
    detectDarkTheme = false;
    enableForPDF = true;
    presets = [ ];
    customThemes = [ ];
    theme = {
      mode = 1;
      brightness = 100;
      contrast = 100;
      grayscale = 0;
      sepia = 0;
      useFont = false;
      fontFamily = "Open Sans";
      textStroke = 0;
      engine = "dynamicTheme";
      stylesheet = "";
      darkSchemeBackgroundColor = stylixHex.base00;
      darkSchemeTextColor = stylixHex.base05;
      lightSchemeBackgroundColor = stylixHex.base07;
      lightSchemeTextColor = stylixHex.base00;
      scrollbarColor = stylixHex.base02;
      selectionColor = stylixHex.base0D;
      styleSystemControls = false;
      lightColorScheme = "Default";
      darkColorScheme = "Default";
      immediateModify = false;
    };
  };
}
