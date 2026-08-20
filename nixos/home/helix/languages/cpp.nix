{ pkgs }:

{
  packages = [ pkgs.clang-tools ];
  language = {
    name = "cpp";
    language-servers = [
      "clangd"
      "typos"
    ];
  };
}
