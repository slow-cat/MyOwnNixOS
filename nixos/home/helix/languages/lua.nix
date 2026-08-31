{ pkgs }:

{
  packages = [
    pkgs.lua-language-server
    pkgs.luajit_2_1
    pkgs.lua5_1
  ];
  language-server.lua-ls.command = "${pkgs.lua-language-server}/bin/lua-language-server";
  language = {
    name = "lua";
    language-servers = [
      "lua-ls"
      "typos"
    ];
  };
}
