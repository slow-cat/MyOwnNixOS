{ pkgs }:
let
  lib = pkgs.lib;
  releasesInfo = builtins.fetchurl "https://api.github.com/repos/openai/codex/releases";
  rustReleases =
    releasesInfo
    |> builtins.readFile
    |> builtins.fromJSON
    |> builtins.filter (r: !r.prerelease && !r.draft && lib.hasPrefix "rust-v" r.tag_name);
  release = builtins.head rustReleases;
  version = lib.removePrefix "rust-v" release.tag_name;

  asset =
    name:
    lib.findFirst (a: a.name == name) (throw "Codex release asset not found: ${name}") release.assets;

  digest = name: lib.removePrefix "sha256:" (asset name).digest;

  codexHash = digest "codex-x86_64-unknown-linux-musl.tar.gz";

  hostHash = digest "codex-code-mode-host-x86_64-unknown-linux-musl.tar.gz";
in

pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "codex";
  inherit version;

  src = pkgs.fetchurl {
    url = "https://github.com/openai/codex/releases/download/rust-v${finalAttrs.version}/codex-x86_64-unknown-linux-musl.tar.gz";
    sha256 = codexHash;
  };

  codeModeHost = pkgs.fetchurl {
    url = "https://github.com/openai/codex/releases/download/rust-v${finalAttrs.version}/codex-code-mode-host-x86_64-unknown-linux-musl.tar.gz";
    sha256 = hostHash;
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
