{ pkgs }:

{
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
}
