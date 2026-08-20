{ pkgs }:

let
  nixdSettings = {
    nixpkgs.expr = "import <nixpkgs> { }";
    formatting.command = [ "nixfmt" ];
    options = {
      nixos.expr = "(import <nixpkgs/nixos> { configuration = /etc/nixos/configuration.nix; }).options";
      home_manager.expr = "(import <nixpkgs/nixos> { configuration = /etc/nixos/configuration.nix; }).options.home-manager.users.type.getSubOptions []";
    };
  };
in
{
  packages = [
    pkgs.nil
    pkgs.nixd
  ];
  language-server = {
    nil.command = "${pkgs.nil}/bin/nil";
    nixd = {
      command = "${pkgs.nixd}/bin/nixd";
      config.nixd = nixdSettings;
    };
  };
  language = {
    name = "nix";
    language-servers = [
      "nixd"
      "typos"
    ];
  };
}
