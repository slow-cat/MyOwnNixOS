{ pkgs }:

{
  packages = [ pkgs.clang-tools ];
  language-server.clangd = {
    command = "${pkgs.clang-tools}/bin/clangd";
    args = [ "--compile-commands-dir=./builddir" ];
  };
  language = {
    name = "c";
    language-servers = [
      "clangd"
      "typos"
    ];
  };
}
