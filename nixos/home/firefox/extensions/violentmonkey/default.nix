{
  declarativeExtensions,
  lib,
  pkgs,
  ...
}:

let
  extensionId = "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}";
  userscriptDirectory = ./scripts;
  userscriptNames = builtins.attrNames (
    lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".user.js" name) (
      builtins.readDir userscriptDirectory
    )
  );
  userscripts = map (name: builtins.readFile (userscriptDirectory + "/${name}")) userscriptNames;
  extension = declarativeExtensions.violentmonkey-declarative.overrideAttrs (previous: {
    patches = (previous.patches or [ ]) ++ [ ./imagemagick-icons.patch ];
    nativeBuildInputs = (previous.nativeBuildInputs or [ ]) ++ [ pkgs.imagemagick ];
  });
  extensionXpi = "${extension}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${extensionId}.xpi";
in
{
  extensionSettings.${extensionId} = {
    installation_mode = "force_installed";
    install_url = "file://${extensionXpi}";
    updates_disabled = true;
    private_browsing = true;
  };

  policies."3rdparty".Extensions.${extensionId} = {
    options = { };
    scripts = userscripts;
  };
}
