{ pkgs }:

{
  packages = [
    pkgs.ruff
    pkgs.ty
  ];
  language-server = {
    ruff = {
      command = "${pkgs.ruff}/bin/ruff";
      args = [ "server" ];
    };
    ty = {
      command = "${pkgs.ty}/bin/ty";
      args = [ "server" ];
    };
  };
  language = {
    name = "python";
    language-servers = [
      "ruff"
      "typos"
      "ty"
    ];
  };
}
