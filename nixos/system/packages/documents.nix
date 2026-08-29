{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    typst
    libreoffice-qt
  ];
}
