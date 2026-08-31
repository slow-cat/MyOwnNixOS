{ pkgs, lib }:

{
  packages = [
    pkgs.lua-language-server
    (lib.lowPrio pkgs.luajit_2_1)
    pkgs.lua5_1
    (pkgs.linkFarm "lua51-symlink" [
      {
        name = "bin/lua5.1";
        path = "${pkgs.lua5_1}/bin/lua";
      }
    ])
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
