{ ... }:

{
  _module.args.host = import ./host.nix;

  imports = [
    ./audio.nix
    ./base.nix
    ./boot.nix
    ./network.nix
    ./packages/cli.nix
    ./packages/development.nix
    ./packages/documents.nix
    ./packages/formal-methods.nix
    ./packages/hardware.nix
    ./packages/media.nix
    ./packages/productivity.nix
    ./packages/remote-access.nix
    ./packages/wayland.nix
    ./packages/web.nix
    ./storage.nix
    ./user.nix
  ];
}
