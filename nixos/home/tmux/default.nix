{ pkgs, ... }:

let
  tmuxKeyFzf = pkgs.writeShellApplication {
    name = "tmux-key-fzf";
    runtimeInputs = with pkgs; [
      bat
      coreutils
      fzf
      gawk
      tmux
    ];
    text = builtins.readFile ./key-fzf.sh;
  };
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
      bind -n C-Space display-popup -E -w 75% -h 75% -T "prefix commands" "${tmuxKeyFzf}/bin/tmux-key-fzf prefix"
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"
      bind -n C-M-o run-shell '${pkgs.brightnessctl}/bin/brightnessctl set 2%- >/dev/null 2>&1'
      bind -n C-M-p run-shell '${pkgs.brightnessctl}/bin/brightnessctl set +2% >/dev/null 2>&1'
    '';
  };
}
