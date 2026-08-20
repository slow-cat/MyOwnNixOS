{ pkgs }:

let
  vale = pkgs.vale.withStyles (styles: [ styles.google ]);
  valeLs = pkgs.vale-ls.override { inherit vale; };
in
{
  packages = [
    vale
    valeLs
  ];
  configFile = pkgs.writeText ".vale.ini" ''
    MinAlertLevel =suggestion
    SkippedScopes=code,tt,span,code
    [*.{md,markdown}]
    BlockIgnores=(?s)```.*?```
    TokenIgnores=(\b\w*[_0-9]\w*\b|TODO|FIXME|\d{4}-\d{2}-d{2})
    BasedOnStyles=Google
  '';
  language-server.vale.command = "${valeLs}/bin/vale-ls";
}
