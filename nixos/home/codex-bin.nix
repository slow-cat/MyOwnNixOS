{ pkgs }:
let
  _ = ''
      curl -s https://api.github.com/repos/openai/codex/releases|jq -r '
       map(select(.prerelease==false  and (.tag_name | startswith("rust-v"))))|.[]|{ 
          tag: .tag_name,
          codex:
            (.assets[]
              | select(.name == "codex-x86_64-unknown-linux-musl.tar.gz")
              | .digest
              | sub("^sha256:"; "")),
          host:
            (.assets[]
              | select(.name == "codex-code-mode-host-x86_64-unknown-linux-musl.tar.gz") 
              | .digest
              | sub("^sha256:"; ""))
        }
      | "\(.tag) \ncodex: \(.codex) \nhost : \(.host)\n"
    '
  '';
in
pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "codex";
  version = "0.154.0";

  src = pkgs.fetchurl {
    url = "https://github.com/openai/codex/releases/download/rust-v${finalAttrs.version}/codex-x86_64-unknown-linux-musl.tar.gz";
    sha256 = "d7e18b2597ae8f242f5f31ee9e90deef48dbc9edd634d9868fb6435d08c07f02";
  };

  codeModeHost = pkgs.fetchurl {
    url = "https://github.com/openai/codex/releases/download/rust-v${finalAttrs.version}/codex-code-mode-host-x86_64-unknown-linux-musl.tar.gz";
    sha256 = "a68df7cca23c6da7cde175677df7de61c73a234add1333a1254b86d641af01f7";
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
