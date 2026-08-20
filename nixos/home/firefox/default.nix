{
  config,
  lib,
  pkgs,
  ...
}:

let
  stylixHex = config.lib.stylix.colors.withHashtag;
  userChrome = import ./chrome { inherit pkgs stylixHex; };
  browserPolicies = import ./browser-policies.nix;
  cookiePolicies = import ./cookies.nix;
  profile = import ./profile.nix { inherit stylixHex; };
  searchConfig = import ./search.nix { inherit pkgs; };
  declarativeExtensions = import (builtins.fetchTarball {
    url = "https://github.com/firefox-extensions-declarative/firefox-extensions-declarative/archive/32bfd276c65167d39ba88dca7ad93eba2ccb47bd.tar.gz";
    sha256 = "0v0v5y9dbmwglriiw3wg4l7lp5d41ij0abmp7m13ig8xs0mlj6qc";
  }) { inherit pkgs; };
  extensions = import ./extensions {
    inherit
      config
      lib
      pkgs
      stylixHex
      declarativeExtensions
      ;
  };
in
{
  home.activation = extensions.activation;
  xdg.configFile = extensions.xdgConfigFile;

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition.override {
      cfg.speechSynthesisSupport = false;
    };
    languagePacks = [
      "en-US"
      "de"
      "fr"
      "ja"
    ];

    nativeMessagingHosts = extensions.nativeMessagingHosts;

    policies = browserPolicies // extensions.policies // cookiePolicies;

    profiles.dev-edition-default = {
      id = 0;
      path = "default";
      isDefault = true;
      extensions = {
        force = true;
        packages = extensions.packages;
      };
      settings = profile.settings // {
        "xpinstall.signatures.required" = false;
      };
      inherit userChrome;
      search = searchConfig;
    };
  };

  home.sessionVariables.MOZ_ENABLE_WAYLAND = "0";
}
