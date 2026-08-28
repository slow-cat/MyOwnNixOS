{
  inputs,
  lib,
  pkgs,
  ...
}:

let
  helixTypos = import ../helix/languages/typos.nix { inherit pkgs; };
  helixVale = import ../helix/languages/vale.nix { inherit pkgs; };
  languageConfiguration = import ./languages { inherit inputs lib pkgs; };
  commonLanguageServers = import ./common-language-servers.nix {
    inherit helixTypos helixVale;
  };
in
{
  programs.zed-editor = {
    enable = true;
    mutableUserSettings = false;
    mutableUserKeymaps = false;

    extensions = [
      "catppuccin"
      "nix"
      "toml"
      "typos"
      "vale"
    ];

    extraPackages = [
      pkgs.nixd
      pkgs.nixfmt
      pkgs.taplo
    ]
    ++ helixTypos.packages
    ++ helixVale.packages;

    userSettings = import ./settings.nix { inherit pkgs; } // {
      languages = languageConfiguration.languages;
      lsp = commonLanguageServers // languageConfiguration.lsp;
    };

    userKeymaps = import ./keymaps.nix;
  };
}
