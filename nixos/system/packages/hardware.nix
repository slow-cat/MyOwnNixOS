{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    acpi
    brightnessctl
    fastfetch
    evtest
    alsa-utils
  ];
}
