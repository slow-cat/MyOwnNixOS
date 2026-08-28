{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  stylixHex = config.lib.stylix.colors.withHashtag;
  userChrome = import ./chrome { inherit pkgs stylixHex; };
  userContent = import ./content { inherit stylixHex; };
  browserPolicies = import ./browser-policies.nix;
  cookiePolicies = import ./cookies.nix;
  profile = import ./profile.nix { inherit stylixHex; };
  searchConfig = import ./search.nix { inherit pkgs; };
  hoverMenusAutoconfig = pkgs.writeText "hover-menus.js" (
    builtins.readFile ./autoconfig/hover-menus.js
  );
  declarativeExtensions = import inputs.firefox-extensions-declarative { inherit pkgs; };
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
      extraPrefsFiles = [ hoverMenusAutoconfig ];
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
      inherit userChrome userContent;
      search = searchConfig;
    };
  };

  home.sessionVariables.MOZ_ENABLE_WAYLAND = "0";
}
