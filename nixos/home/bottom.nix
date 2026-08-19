{ config, ... }:

let
  colors = config.lib.stylix.colors.withHashtag;
in
{
  programs.bottom = {
    enable = true;
    settings.styles = {
      cpu = {
        all_entry_colour = colors.base0B;
        avg_entry_colour = colors.base08;
        cpu_core_colours = [
          colors.base0E
          colors.base0A
          colors.base0C
          colors.base0B
          colors.base0D
        ];
      };
      memory = {
        ram_colour = colors.base0E;
        cache_colour = colors.base08;
        swap_colour = colors.base0A;
      };
      network = {
        rx_colour = colors.base0C;
        tx_colour = colors.base0A;
        rx_total_colour = colors.base0D;
        tx_total_colour = colors.base0B;
      };
      tables.headers = {
        colour = colors.base0D;
        bold = true;
      };
      graphs = {
        graph_colour = colors.base04;
        legend_text.colour = colors.base04;
      };
      widgets = {
        border_colour = colors.base03;
        selected_border_colour = colors.base0D;
        widget_title.colour = colors.base05;
        text.colour = colors.base05;
        selected_text = {
          colour = colors.base00;
          bg_colour = colors.base0D;
        };
        disabled_text.colour = colors.base03;
        bg_colour = colors.base00;
      };
    };
  };
}
