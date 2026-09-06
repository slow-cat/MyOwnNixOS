{ pkgs }:

pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "codex";
  version = "0.153.4";

  src = pkgs.fetchurl {
    url = "https://github.com/openai/codex/releases/download/rust-v${finalAttrs.version}/codex-x86_64-unknown-linux-musl.tar.gz";
    sha256 = "f479424eca092484dc40d87ae28c44f4cc40234a60045d6131e493800d814a30";
  };

  codeModeHost = pkgs.fetchurl {
    url = "https://github.com/openai/codex/releases/download/rust-v${finalAttrs.version}/codex-code-mode-host-x86_64-unknown-linux-musl.tar.gz";
    sha256 = "f95830a869590957664bbfc67bccb08773806b693670baf15908176f89b4cd31";
  };

  nativeBuildInputs = [
    pkgs.makeBinaryWrapper
    pkgs.installShellFiles
  ];
  sourceRoot = ".";
  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  postInstall = ''
    installShellCompletion --cmd codex \
      --bash <($out/bin/codex completion bash) \
      --fish <($out/bin/codex completion fish) \
      --zsh <($out/bin/codex completion zsh)
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 codex-x86_64-unknown-linux-musl $out/bin/codex
    tar xf "$codeModeHost"
    install -Dm755 codex-code-mode-host-x86_64-unknown-linux-musl $out/bin/codex-code-mode-host
    wrapProgram $out/bin/codex --prefix PATH : ${
      pkgs.lib.makeBinPath [
        pkgs.ripgrep
        pkgs.bubblewrap
      ]
    }
    runHook postInstall
  '';

  meta = {
    mainProgram = "codex";
    platforms = [ "x86_64-linux" ];
  };
})
