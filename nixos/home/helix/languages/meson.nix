{ pkgs }:

{
  packages = [
    pkgs.meson
    pkgs.ninja
    pkgs.mesonlsp
  ];
  language-server.mesonlsp.command = "${pkgs.mesonlsp}/bin/mesonlsp";
  language = {
    name = "meson";
    language-servers = [
      "mesonlsp"
      "typos"
      "vale"
    ];
  };
}
