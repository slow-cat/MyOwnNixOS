{ pkgs }:

{
  packages = [ pkgs.jdt-language-server ];
  language-server.jdtls.command = "${pkgs.jdt-language-server}/bin/jdtls";
  language = {
    name = "java";
    language-servers = [
      "jdtls"
      "typos"
    ];
  };
}
