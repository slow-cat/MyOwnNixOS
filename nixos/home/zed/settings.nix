{ pkgs }:

{
  project_panel.dock = "left";
  outline_panel.dock = "left";
  collaboration_panel.dock = "left";
  git_panel.dock = "left";

  agent_servers.codex = {
    type = "custom";
    command = "${pkgs.codex-acp}/bin/codex-acp";
    args = [ ];
    env = { };
  };

  agent = {
    dock = "right";
    favorite_models = [ ];
    model_parameters = [ ];
  };

  scroll_sensitivity = 4.0;
  fast_scroll_sensitivity = 12.0;

  helix_mode = true;
  vim_mode = false;
  icon_theme = "Zed (Default)";

  theme = {
    mode = "dark";
    dark = "Catppuccin Frappé";
    light = "Catppuccin Latte";
  };
}
