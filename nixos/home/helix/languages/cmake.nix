{ pkgs }:

{
  packages = [
    pkgs.cmake
    pkgs.ninja
    pkgs.neocmakelsp
  ];
  language-server.neocmakelsp.command = "${pkgs.neocmakelsp}/bin/neocmakelsp";
  language = {
    name = "cmake";
    language-servers = [
      "neocmakelsp"
      "typos"
    ];
  };
}
