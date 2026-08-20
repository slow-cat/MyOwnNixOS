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
  localUserscripts = map (name: builtins.readFile (userscriptDirectory + "/${name}")) userscriptNames;
  remoteUserscripts = map builtins.readFile [
    (pkgs.fetchurl {
      name = "RisCredential.user.js";
      url = "https://gist.github.com/slow-cat/af8ea0163a8353f1020fd58dc83077ad/raw/f602680e2ef63813b09e3c65593a551c931e6cc0/RisCredential.user.js";
      hash = "sha256-UFxxULqSVXpz68u/MQpTvwSZ+Q0IRjRPq2I+OUrZaY4=";
    })
    (pkgs.fetchurl {
      name = "atcoder-difficulty-display.user.js";
      url = "https://update.greasyfork.org/scripts/397185/atcoder-difficulty-display.user.js";
      hash = "sha256-CNIZOSe9pWZ9aeIqgmOMw3w8yRRAehpBgx0oOnGHY7U=";
    })
    (pkgs.fetchurl {
      name = "AtCoderStandingsAnalysis.user.js";
      url = "https://update.greasyfork.org/scripts/398439/AtCoderStandingsAnalysis.user.js";
      hash = "sha256-l6zwPImNuNpGmJBMimUkmXIa7GsdKKj+5DcglvCiTvY=";
    })
    (pkgs.fetchurl {
      name = "AnnoyingImageSwapper.user.js";
      url = "https://github.com/slow-cat/risk-swapper/raw/refs/heads/master/AnnoyingImageSwapper.user.js";
      hash = "sha256-bEuyW9Brt6JEHYK89hOMiApziZ60eK6ODUuwIUmOOrE=";
    })
  ];
  userscripts = localUserscripts ++ remoteUserscripts;
  extension = declarativeExtensions.violentmonkey-declarative.overrideAttrs (previous: {
    patches = (previous.patches or [ ]) ++ [
      ./managed-policy.patch
      ./imagemagick-icons.patch
    ];
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
