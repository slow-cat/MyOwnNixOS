{
  config,
  lib,
  pkgs,
  stylixHex,
  declarativeExtensions,
}:

let
  amo = slug: "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
  args = {
    inherit
      config
      lib
      pkgs
      stylixHex
      amo
      ;
  };
  extensions = [
    (import ./dark-reader.nix { inherit declarativeExtensions stylixHex; })
    (import ./flagfox.nix { inherit amo; })
    (import ./firefox-color.nix { inherit amo; })
    (import ./tridactyl.nix args)
    (import ./ublock-origin.nix { inherit lib stylixHex amo; })
    (import ./violentmonkey { inherit declarativeExtensions lib pkgs; })
  ];
  merge =
    field: lib.foldl' lib.recursiveUpdate { } (map (extension: extension.${field} or { }) extensions);
in
{
  policies = {
    ExtensionSettings = {
      "*".installation_mode = "blocked";
    }
    // merge "extensionSettings";
  }
  // merge "policies";

  xdgConfigFile = merge "xdgConfigFile";
  activation = merge "activation";
  packages = lib.concatMap (extension: extension.packages or [ ]) extensions;
  nativeMessagingHosts = lib.concatMap (extension: extension.nativeMessagingHosts or [ ]) extensions;
}
