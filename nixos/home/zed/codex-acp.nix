{ pkgs }:

pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "codex-acp";
  version = "0.16.0";

  src = pkgs.fetchurl {
    url = "https://github.com/zed-industries/codex-acp/releases/download/v${finalAttrs.version}/codex-acp-${finalAttrs.version}-x86_64-unknown-linux-musl.tar.gz";
    sha256 = "2e123b97871846fa2e01e835a921f0d7a373a6fc91e76a556dc7cf7eb3910587";
  };

  nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
  sourceRoot = ".";
  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 codex-acp $out/bin/codex-acp
    mkdir -p $out/bin/codex-resources
    ln -s ${pkgs.bubblewrap}/bin/bwrap $out/bin/codex-resources/bwrap
    wrapProgram $out/bin/codex-acp --prefix PATH : ${
      pkgs.lib.makeBinPath [
        pkgs.ripgrep
        pkgs.bubblewrap
      ]
    }
    runHook postInstall
  '';

  meta = {
    mainProgram = "codex-acp";
    platforms = [ "x86_64-linux" ];
  };
})
