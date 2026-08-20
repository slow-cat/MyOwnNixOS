{ pkgs }:

{
  packages = [ pkgs.tinymist ];
  language-server.tinymist.command = "${pkgs.tinymist}/bin/tinymist";
  language = {
    name = "typst";
    language-servers = [
      "tinymist"
      "typos"
      "vale"
    ];
  };
}
