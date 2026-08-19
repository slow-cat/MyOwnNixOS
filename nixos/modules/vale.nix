{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    (vale.withStyles (s: [ s.google ]))
    vale-ls
  ];
  environment.variables.VALE_CONFIG_PATH = (
    pkgs.writeText ".vale.ini" ''
      MinAlertLevel =suggestion
      SkippedScopes=code,tt,span,code
      [*.{md,markdown}]
      BlockIgnores=(?s)```.*?```
      TokenIgnores=(\b\w*[_0-9]\w*\b|TODO|FIXME|\d{4}-\d{2}-d{2})
      BasedOnStyles=Google
    ''
  );
}
