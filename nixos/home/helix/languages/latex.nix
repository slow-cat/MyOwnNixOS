{ pkgs }:

{
  packages = [ pkgs.texlab ];
  language-server.texlab.command = "${pkgs.texlab}/bin/texlab";
  language = {
    name = "latex";
    language-servers = [
      "texlab"
      "typos"
      "vale"
    ];
    auto-pairs = {
      "(" = ")";
      "{" = "}";
      "[" = "]";
      "`" = "`";
      "\"" = "\"";
      "$" = "$";
    };
  };
}
