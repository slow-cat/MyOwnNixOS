{ ... }:

let
  home-manager = fetchTarball "https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  # Preserve pre-Home-Manager dotfiles during the first activation.
  home-manager.backupFileExtension = "hm-backup";

  users.users.eve.isNormalUser = true;
  home-manager.users.moamoa = { ... }: {
    imports = [
      ./stylix.nix
      ./bat.nix
      ./bottom.nix
      ./broot.nix
      ./bun.nix
      ./fcitx5.nix
      ./firefox.nix
      ./fzf.nix
      ./foot.nix
      ./gdu.nix
      ./git.nix
      ./imv.nix
      ./mako.nix
      ./mpv.nix
      ./swaylock.nix
      ./vim.nix
      ./wofi.nix
      ./zathura.nix
      ./helix.nix
      ./tmux.nix
      ./zed.nix
      ./zsh.nix
      ./nwg-drawwer.nix
      ./chawan.nix
    ];
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "26.05";
  };
}
