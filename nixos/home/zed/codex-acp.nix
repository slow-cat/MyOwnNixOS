{ pkgs }:

pkgs.buildFHSEnv {
  name = "codex-acp";
  targetPkgs = pkgs: [
    pkgs.bun
    pkgs.openssl
    pkgs.zlib
  ];
  runScript = pkgs.writeShellScript "codex-acp-run" ''
    exec ${pkgs.bun}/bin/bun x --bun \
      --package @agentclientprotocol/codex-acp@latest codex-acp "$@"
  '';
}
