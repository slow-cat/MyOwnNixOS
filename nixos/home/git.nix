{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings.pager.reflog = "${pkgs.delta}/bin/delta";
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      plus-style = "syntax #012800";
      minus-style = "syntax #340001";
      syntax-theme = "Monokai Extended";
      navigate = true;
    };
  };
}
