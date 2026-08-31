{ ... }:

let
  home-manager = fetchGit {
    url = "https://github.com/nix-community/home-manager.git";
    ref = "release-26.05";
  };
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

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
      ./firefox
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
      ./helix
      ./tmux
      ./zed
      ./zsh
      ./nwg-drawwer.nix
      ./chawan
    ];
    home.stateVersion = "26.05";
  };
}
