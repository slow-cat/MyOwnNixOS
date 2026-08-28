{ inputs, pkgs, ... }:

{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix = {
    enable = true;
    autoEnable = false;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";

    targets = {
      console.enable = false;
      fontconfig.enable = true;
      "font-packages".enable = true;
      grub = {
        enable = true;
        useWallpaper = false;
      };
      nixos-icons.enable = true;
    };

    cursor = {
      package = pkgs.catppuccin-cursors.frappeBlue;
      name = "catppuccin-frappe-blue-cursors";
      size = 18;
    };

    fonts = {
      monospace = {
        package = pkgs.udev-gothic-nf;
        name = "UDEV Gothic NFLG";
      };
      serif = {
        package = pkgs.crimson;
        name = "Crimson";
      };
      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };
      sizes = {
        terminal = 11.5;
        popups = 12;
      };
    };
  };
  fonts = {
    packages = with pkgs; [
      inter
      biz-ud-gothic
      jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      crimson
      (callPackage ./biz-ud-mincho.nix { })
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [
          "Inter"
          "BIZ UDPGothic"
          "Noto Sans CJK JP"
        ];
        serif = [
          "Crimson"
          "BIZ UDPMincho"
          "Noto Seria CJK JP"
        ];
        monospace = [
          "JetBrains Mono"
          "BIZ UDGothic"
          "Noto Sans Mono CJK JP"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
