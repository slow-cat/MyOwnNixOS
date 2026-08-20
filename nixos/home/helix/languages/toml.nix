{ pkgs }:

{
  packages = [ pkgs.taplo ];
  language-server.taplo = {
    command = "${pkgs.taplo}/bin/taplo";
    args = [
      "lsp"
      "stdio"
    ];
  };
  language = {
    name = "toml";
    language-servers = [ "taplo" ];
  };
}
