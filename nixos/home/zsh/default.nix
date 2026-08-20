{
  config,
  lib,
  pkgs,
  ...
}:

let
  completionDump = "${config.xdg.cacheHome}/zsh/zcompdump";
  snippets = import ./snippets.nix { inherit pkgs; };
in
{
  imports = [
    ./atuin.nix
    ./integrations.nix
  ];

  home.file.".zshenv".enable = false;

  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/go/bin"
  ];

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    enableCompletion = true;
    completionInit = ''
      ${pkgs.coreutils}/bin/mkdir -p "${config.xdg.cacheHome}/zsh"
      autoload -Uz compinit
      compinit -d "${completionDump}"
      if [[ -s "${completionDump}" && ( ! -s "${completionDump}.zwc" || "${completionDump}" -nt "${completionDump}.zwc" ) ]]; then
        echo "make new zcompdump.zwc"
        zcompile "${completionDump}"
      fi
    '';

    history.path = "${config.xdg.stateHome}/zsh/history";

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];

    shellAliases = {
      g = "git";
      la = "ls -la";
      ll = "ls -l";
      nr = "sudo nixos-rebuild switch";
    };

    sessionVariables = {
      VIRTUAL_ENV_DISABLE_PROMPT = "";
      WINIT_UNIX_BACKEND = "x11";
    };

    initContent = lib.mkOrder 1150 (
      lib.concatStringsSep "\n" [
        snippets.shellSetup
        snippets.basicBindings
        snippets.navigationFunctions
        snippets.enterWidget
        snippets.bindingInspectorWidget
        snippets.promptSetup
      ]
    );
  };
}
