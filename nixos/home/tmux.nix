{ pkgs, ... }:

let
  tmuxKeyFzf = pkgs.writeShellScript "tmux-key-fzf" ''
    set -u

    tab=$(${pkgs.coreutils}/bin/printf '\t')
    mode=''${1:-prefix}

    fail() {
      ${pkgs.tmux}/bin/tmux display-message "tmux-key-fzf: $*"
      exit 1
    }

    normalize_key() {
      case "$1" in
        \\*) ${pkgs.coreutils}/bin/printf '%s\n' "''${1#\\}" ;;
        *) ${pkgs.coreutils}/bin/printf '%s\n' "$1" ;;
      esac
    }

    list_keys() {
      case "$mode" in
        all) ${pkgs.tmux}/bin/tmux list-keys ;;
        *) ${pkgs.tmux}/bin/tmux list-keys -T "$mode" ;;
      esac | ${pkgs.gawk}/bin/awk -v mode="$mode" '
        BEGIN { squote = sprintf("%c", 39) }
        function trim_left(s) { sub(/^[[:space:]]+/, "", s); return s }
        function take_token(s, i, c, esc, quote, out) {
          s = trim_left(s); out = ""; esc = 0; quote = ""
          for (i = 1; i <= length(s); i++) {
            c = substr(s, i, 1)
            if (quote != "") {
              out = out c
              if (esc) { esc = 0 }
              else if (c == "\\") { esc = 1 }
              else if (c == quote) { quote = "" }
              continue
            }
            if (esc) { out = out c; esc = 0; continue }
            if (c == "\\") { out = out c; esc = 1; continue }
            if (c == "\"" || c == squote) { out = out c; quote = c; continue }
            if (c ~ /[[:space:]]/) { break }
            out = out c
          }
          token = out; rest = substr(s, i + 1)
        }
        {
          line = $0; table = mode == "all" ? "prefix" : mode
          sub(/^bind-key[[:space:]]+/, "", line)
          sub(/^bind[[:space:]]+/, "", line)
          while (1) {
            line = trim_left(line)
            if (line == "") { next }
            take_token(line)
            if (token == "-T" || token == "-N") {
              option = token; take_token(rest)
              if (option == "-T") { table = token }
              line = rest; continue
            }
            if (token == "-r" || token == "-n") { line = rest; continue }
            key = token; command = trim_left(rest)
            if (mode == "all") { printf "%s %s\t%s\n", table, key, command }
            else { printf "%s\t%s\n", key, command }
            next
          }
        }
      '
    }

    selection="$(
      list_keys | ${pkgs.fzf}/bin/fzf \
        --layout=reverse \
        --border \
        --delimiter='\t' \
        --nth=1,2 \
        --prompt='keys> ' \
        --info=inline \
        --height=100% \
        --no-hscroll \
        --header='Enter: execute  Esc: close' \
        --preview '${pkgs.coreutils}/bin/echo {2} | ${pkgs.bat}/bin/bat --color=never' \
        --preview-window=down:25%:wrap \
        --bind=tab:down,change:top
    )" || exit 0

    case "$selection" in
      *"$tab"*)
        entry=''${selection%"$tab"*}
        command=''${selection#*"$tab"}
        ;;
      *) fail "invalid selection" ;;
    esac

    [ -n "$command" ] || fail "empty command"

    case "$mode" in
      all)
        table=''${entry%% *}
        key=''${entry#"$table"}
        key=''${key# }
        ;;
      *)
        table=$mode
        key=$entry
        ;;
    esac

    [ -n "$table" ] || fail "empty table"
    [ -n "$key" ] || fail "empty key"
    key=$(normalize_key "$key")

    client=$(${pkgs.tmux}/bin/tmux display-message -p "#{client_tty}") || fail "failed to resolve client"
    [ -n "$client" ] || fail "client_tty is empty"

    ${pkgs.tmux}/bin/tmux display-popup -C -c "$client" \; \
      switch-client -T "$table" -c "$client" \; \
      send-keys -K -c "$client" "$key" || fail "failed to dispatch $table $key"
  '';
in
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    mouse = true;
    secureSocket = false;
    terminal = "xterm-256color";

    extraConfig = ''
      set -g allow-passthrough on
      set -ga terminal-overrides ',xterm-kitty:Ms=\E]52;%p1%s;%p2%s\007'
      set -ga terminal-overrides ',xterm*:smcup@:rmcup@:colors=256,alacritty*:smcup@:rmcup@:colors=256,foot*:smcup@:rmcup@:colors=256'
      set-option -g status-interval 120
      set -g status-right '#(${pkgs.acpi}/bin/acpi -b | ${pkgs.coreutils}/bin/cut -d, -f2-3)'
      bind -n C-Space display-popup -E -w 75% -h 75% -T "prefix commands" "${tmuxKeyFzf} prefix"
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"
      bind -n C-M-o run-shell '${pkgs.brightnessctl}/bin/brightnessctl set 2%- >/dev/null 2>&1'
      bind -n C-M-p run-shell '${pkgs.brightnessctl}/bin/brightnessctl set +2% >/dev/null 2>&1'
    '';
  };
}
