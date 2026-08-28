{
  config,
  pkgs,
  ...
}:

let
  codexWithBun = pkgs.writeShellApplication {
    name = "codex";
    text = ''
      exec ${pkgs.bun}/bin/bun x --bun \
        --package @openai/codex@latest codex "$@"
    '';
  };
in
{
  programs.bun = {
    enable = true;
    settings = {
      telemetry = false;
      install = {
        globalDir = "${config.xdg.dataHome}/bun/install/global";
        globalBinDir = "${config.xdg.dataHome}/bun/bin";
        cache.dir = "${config.xdg.cacheHome}/bun";
      };
    };
  };

  home = {
    packages = [ codexWithBun ];
    sessionPath = [ "${config.xdg.dataHome}/bun/bin" ];
  };
}
