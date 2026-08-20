{ ... }:

{
  stylix.targets = {
    bat.enable = true;
    broot.enable = true;
    fcitx5.enable = true;
    foot.enable = true;
    fzf.enable = true;
    gtk.enable = true;
    mako.enable = true;
    mpv.enable = true;
    nixos-icons.enable = true;
    qt.enable = true;
    swaylock = {
      enable = true;
      image.enable = false;
    };
    wofi.enable = true;
    zathura.enable = true;
    tmux.enable = true;
    vim.enable = true;
    xresources.enable = true;

    firefox = {
      enable = true;
      profileNames = [ "dev-edition-default" ];
      colorTheme.enable = true;
    };

    helix.enable = false;
    zed = {
      enable = true;
      colors.enable = false;
    };
    gdu = {
      enable = true;
      colors.override.withHashtag = {
        base00 = "#000080";
      };
    };
  };
}
