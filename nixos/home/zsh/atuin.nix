{ ... }:

{
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    themes.stylix = {
      theme.name = "stylix";
      colors = {
        AlertError = "@red";
        AlertInfo = "@cyan";
        AlertWarn = "@yellow";
        Annotation = "@grey";
        Guidance = "@dark_grey";
        Important = "@magenta";
        Title = "@blue";
      };
    };
    settings = {
      auto_sync = false;
      enter_accept = true;
      theme.name = "stylix";
    };
  };
}
