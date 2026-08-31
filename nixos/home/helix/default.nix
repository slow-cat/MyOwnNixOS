{ lib, pkgs, ... }:

let
  languageConfiguration = import ./languages {
    inherit lib pkgs;
  };
in
{
  home.packages = languageConfiguration.packages;
  home.activation.linkRustToolchains = lib.hm.dag.entryAfter [
    "writeBoundary"
  ] languageConfiguration.activation;

  programs.helix = {
    enable = true;
    extraPackages = [ pkgs.nixfmt ];
    settings = import ./settings.nix;
    languages = languageConfiguration.config;
    themes = import ./themes.nix;
  };
}
