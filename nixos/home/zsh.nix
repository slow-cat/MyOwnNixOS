{
  config,
  lib,
  pkgs,
  ...
}:

let
  completionDump = "${config.xdg.cacheHome}/zsh/zcompdump";

  shellSetup = ''
    export LD_LIBRARY_PATH="/usr/local/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'
  '';

  basicBindings = ''
    bindkey '\e[1;5A' beginning-of-line
    bindkey '\e[1;5B' end-of-line
    bindkey '\e[1;5C' forward-word
    bindkey '\e[1;5D' backward-word
    bindkey '^H' backward-kill-word
    bindkey '^[[3;5~' kill-word
  '';

  navigationFunctions = ''
    fzgrep() {
      local rg_prefix='${pkgs.ripgrep}/bin/rg --no-heading --line-number --color=always --smart-case --'
      FZF_DEFAULT_COMMAND="$rg_prefix ." ${pkgs.fzf}/bin/fzf \
        --ansi \
        --phony \
        --query "" \
        --height=100% \
        --bind "change:reload:$rg_prefix {q} . || true" \
        --delimiter : \
        --nth 4.. \
        --with-nth 1,2,4.. \
        --preview-window=right:70%:wrap:+{2} \
        --preview '${pkgs.bat}/bin/bat --style=numbers --color=always --highlight-line {2} {1} 2>/dev/null || ${pkgs.coreutils}/bin/nl -ba {1}'
    }
  '';

  enterWidget = ''
    do_enter() {
      if [[ -n $BUFFER ]]; then
        zle accept-line
        return
      fi

      clear
      zle clear-screen
      echo
      ${pkgs.coreutils}/bin/ls
      echo
      echo -e '\e[0;33m--- git status ---\e[0m'
      if ${pkgs.git}/bin/git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        ${pkgs.git}/bin/git status -sb
      fi
      ${pkgs.acpi}/bin/acpi
      zle reset-prompt
    }
    zle -N do_enter
    bindkey '^M' do_enter
  '';

  bindingInspectorWidget = ''
    zsh_bind_widget() {
      local widget
      widget=$(bindkey | ${pkgs.fzf}/bin/fzf \
        --prompt='Zsh Bindings: ' \
        --preview='
          echo
          cmd=$(echo {} | cut -d" " -f2)
          esc=''${cmd//-/\\\\-}
          ${pkgs.gzip}/bin/zcat $(${pkgs.man}/bin/man -w zshzle) |
            ${pkgs.gawk}/bin/awk "/^\\\\fB''${esc}\\\\fP\\s\\(/{f=2}
              f&&/^\\.TP/{exit}
              f&&/^\\./{print \"\";next}
              f{
                gsub(/\\\\f[BRIP]/,\"\")
                gsub(/\\\\-/,\"-\")
                gsub(/\\\\&/,\"\")
                printf \" %s\",\$0
                if (f==2){f=1;print \"\"}
              }"
        ' \
        --height=40% \
        --layout=reverse \
        --border \
        --preview-window=right:50% \
        --bind='alt-/:change-preview-window(80%|hidden|)' \
        --bind='alt-k:preview-half-page-up,alt-j:preview-half-page-down' \
        --preview-window=wrap-word | ${pkgs.gawk}/bin/awk '{print $2}')
      if [[ -n $widget ]]; then
        zle "$widget"
      fi
      zle reset-prompt
    }
    zle -N zsh_bind_widget
    bindkey '^[?' zsh_bind_widget
  '';

  promptSetup = ''
    setopt prompt_subst
    typeset CYAN=$'%{\e[36m%}'
    typeset GRAY=$'%{\e[37m%}'
    zstyle ':vcs_info:*' formats '%F{magenta}[%F{green}%u%b%F{magenta}]%f'
    zstyle ':vcs_info:*' actionformats '[%b|%a]'

    prepcmd() {
      local exit_status=$?
      local ERROR DEFAULT PYTHON
      ERROR=""
      (( exit_status != 0 )) && ERROR="%B%F{red}$exit_status %f%b"
      DEFAULT='%B%F{blue}%n%f@%m%b %~'
      if [[ -n $VIRTUAL_ENV_PROMPT ]]; then
        PYTHON="%F{yellow}[$CYAN$VIRTUAL_ENV_PROMPT%F{yellow}]%f"
      else
        PYTHON=""
      fi
      vcs_info
      PROMPT="$ERROR$DEFAULT$vcs_info_msg_0_$PYTHON$GRAY%%%f "
    }

    autoload -Uz add-zsh-hook vcs_info
    add-zsh-hook precmd prepcmd
  '';
in
{
  # NixOS sets ZDOTDIR before user startup files are read, so no ~/.zshenv
  # bootstrap is needed. The generated files remain symlinks into the Nix store.
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
        shellSetup
        basicBindings
        navigationFunctions
        enterWidget
        bindingInspectorWidget
        promptSetup
      ]
    );
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    themes.stylix = {
      # Use the ANSI slots themed by Stylix. Unlike literal RGB values, these
      # remain colored on the Linux console's 16-color TTY.
      theme.name = "stylix";
      colors = {
        AlertError = "@red";
        AlertInfo = "@cyan";
        AlertWarn = "@yellow";
        Annotation = "@grey";
        Guidance = "@dark_grey";
        Important = "@magenta";
        Title = "@blue";
      };
    };
    settings = {
      auto_sync = false;
      enter_accept = true;
      theme.name = "stylix";
    };
  };

  programs.broot.enableZshIntegration = true;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
