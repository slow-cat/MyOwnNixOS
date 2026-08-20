set -u

tab=$(printf '\t')
mode=${1:-prefix}

fail() {
  tmux display-message "tmux-key-fzf: $*"
  exit 1
}

normalize_key() {
  case "$1" in
    \\*) printf '%s\n' "${1#\\}" ;;
    *) printf '%s\n' "$1" ;;
  esac
}

list_keys() {
  case "$mode" in
    all) tmux list-keys ;;
    *) tmux list-keys -T "$mode" ;;
  esac | awk -v mode="$mode" '
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
  list_keys | fzf \
    --layout=reverse \
    --border \
    --delimiter='\t' \
    --nth=1,2 \
    --prompt='keys> ' \
    --info=inline \
    --height=100% \
    --no-hscroll \
    --header='Enter: execute  Esc: close' \
    --preview 'echo {2} | bat --color=never' \
    --preview-window=down:25%:wrap \
    --bind=tab:down,change:top
)" || exit 0

case "$selection" in
  *"$tab"*)
    entry=${selection%"$tab"*}
    command=${selection#*"$tab"}
    ;;
  *) fail "invalid selection" ;;
esac

[ -n "$command" ] || fail "empty command"

case "$mode" in
  all)
    table=${entry%% *}
    key=${entry#"$table"}
    key=${key# }
    ;;
  *)
    table=$mode
    key=$entry
    ;;
esac

[ -n "$table" ] || fail "empty table"
[ -n "$key" ] || fail "empty key"
key=$(normalize_key "$key")

client=$(tmux display-message -p "#{client_tty}") || fail "failed to resolve client"
[ -n "$client" ] || fail "client_tty is empty"

tmux display-popup -C -c "$client" \; \
  switch-client -T "$table" -c "$client" \; \
  send-keys -K -c "$client" "$key" || fail "failed to dispatch $table $key"
