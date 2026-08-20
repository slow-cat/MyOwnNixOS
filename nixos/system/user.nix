{ pkgs, ... }:

{
  users.users.moamoa = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "render"
      "audio"
    ];
    initialPassword = "moamoa";
    shell = pkgs.zsh;
  };

  programs.zsh = {
    enable = true;
    shellInit = ''
      if [[ $USER == moamoa ]]; then
        export ZDOTDIR="$HOME/.config/zsh"
      fi
    '';
  };
}
