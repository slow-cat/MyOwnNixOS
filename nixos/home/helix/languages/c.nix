{ pkgs }:
{
  packages = [
    pkgs.clang-tools
    pkgs.clang
    pkgs.lld
    pkgs.lldb
  ];
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
