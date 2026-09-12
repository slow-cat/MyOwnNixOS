{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    package = pkgs.steam.override {
      extraArgs = "-system-composer";
    };

    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
}
