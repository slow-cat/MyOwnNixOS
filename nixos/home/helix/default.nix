{
  inputs,
  lib,
  pkgs,
  ...
}:

let
  languageConfiguration = import ./languages {
    inherit inputs lib pkgs;
  };
in
{
  home.packages = languageConfiguration.packages;

  programs.helix = {
    enable = true;
    extraPackages = [ pkgs.nixfmt ];
    settings = import ./settings.nix;
    languages = languageConfiguration.config;
    themes = import ./themes.nix;
  };
}
