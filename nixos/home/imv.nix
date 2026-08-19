{ config, ... }:

let
  colors = config.lib.stylix.colors;
in
{
  programs.imv = {
    enable = true;
    settings.options = {
      background = colors.base00;
      overlay_text_color = colors.base05;
      overlay_background_color = colors.base01;
    };
  };
}
