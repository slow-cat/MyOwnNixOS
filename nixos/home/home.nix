{ inputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager.backupFileExtension = "hm-backup";
  home-manager.extraSpecialArgs = { inherit inputs; };

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
