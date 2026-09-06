{
  config,
  pkgs,
  ...
}:

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
    sessionPath = [ "${config.xdg.dataHome}/bun/bin" ];
  };
}
