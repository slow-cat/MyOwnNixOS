{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    tree-sitter
    wget
    wget2
    aria2
    curl
    file
    tree
    lsof
    pciutils
    usbutils
    inetutils
    zip
    unzip
    nix-zsh-completions
    nix-index
    nix-tree
    nix-doc
    nix-output-monitor
    nix-direnv
    nh
    fd
    sd
    ripgrep
    dash
    impala
  ];
}
