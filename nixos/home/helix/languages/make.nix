{ pkgs }:

{
  packages = [ pkgs.gnumake ];
  language = {
    name = "make";
    language-servers = [
      "typos"
    ];
  };
}
