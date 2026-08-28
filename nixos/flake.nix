{
  description = "moamoa NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-extensions-declarative = {
      url = "github:firefox-extensions-declarative/firefox-extensions-declarative/32bfd276c65167d39ba88dca7ad93eba2ccb47bd";
      flake = false;
    };
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    let
      mkSystem =
        {
          hardware,
          isQemu,
        }:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            hardware
            ./configuration.nix
            {
              _module.args.host = {
                inherit isQemu;
              };
            }
          ];
        };

      native = mkSystem {
        hardware = ./hardware/native.nix;
        isQemu = false;
      };

      qemu =
        if builtins.pathExists ./hardware/qemu.nix then
          {
            qemu = mkSystem {
              hardware = ./hardware/qemu.nix;
              isQemu = true;
            };
          }
        else
          { };
    in
    {
      nixosConfigurations = {
        nixos = native;
        native = native;
      }
      // qemu;
    };
}
