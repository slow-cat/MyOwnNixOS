{ pkgs }:

{
  packages = [
    pkgs.clang-tools
    pkgs.clang
    pkgs.lld
    pkgs.lldb
  ];
  language = {
    name = "cpp";
    language-servers = [
      "clangd"
      "typos"
    ];
  };
}
