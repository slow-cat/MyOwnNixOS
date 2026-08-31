{ pkgs, ... }:
let
  private = if builtins.pathExists /etc/nixos/private.nix then import /etc/nixos/private.nix else { };
in
{
  programs.gh = {
    enable = true;
  };
  programs.git = {
    enable = true;
    settings = {
      pager.reflog = "${pkgs.delta}/bin/delta";
      init.defaultBranch = "main";
    }
    // (if private ? git then { user = private.git; } else { });
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
