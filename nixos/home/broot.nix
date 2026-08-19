{ pkgs, ... }:

let
  viewImage = pkgs.writeShellScript "broot-view-image" ''
    ${pkgs.viu}/bin/viu -s -b "$1" | ${pkgs.less}/bin/less -R
  '';

  table = pkgs.writeShellScript "broot-table" ''
    ${pkgs.qsv}/bin/qsv table "$1" | ${pkgs.bat}/bin/bat --paging=always
  '';

  stats = pkgs.writeShellScript "broot-stats" ''
    ${pkgs.qsv}/bin/qsv stats "$1" | ${pkgs.bat}/bin/bat --paging=always
  '';

  midi = pkgs.writeShellScript "broot-midi" ''
    ${pkgs.fluidsynth}/bin/fluidsynth \
      -a pipewire -i -g 2.0 \
      ${pkgs.soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2 \
      "$1" &
    pid=$!

    cleanup() {
      kill "$pid" 2>/dev/null || true
    }
    trap cleanup EXIT HUP INT TERM

    echo "Press q to quit"
    while IFS= read -r -s -n 1 key; do
      [ "$key" = q ] && break
    done
  '';
in
{
  programs.broot = {
    enable = true;
    settings.verbs = [
      {
        invocation = "view-image";
        key = "enter";
        external = [
          (toString viewImage)
          "{file}"
        ];
        leave_broot = false;
        apply_to = "file";
        extensions = [
          "png"
          "jpg"
          "jpeg"
          "webp"
          "bmp"
          "gif"
        ];
      }
      {
        invocation = "play-audio";
        key = "enter";
        external = [
          "${pkgs.mpv}/bin/mpv"
          "--no-video"
          "--really-quiet"
          "--input-conf=/dev/null"
          "{file}"
        ];
        leave_broot = false;
        apply_to = "file";
        extensions = [
          "mp3"
          "ogg"
          "wav"
          "flac"
          "m4a"
        ];
      }
      {
        invocation = "midi";
        key = "enter";
        external = [
          (toString midi)
          "{file}"
        ];
        leave_broot = false;
        apply_to = "file";
        extensions = [
          "mid"
          "midi"
        ];
      }
      {
        invocation = "view-struct";
        key = "enter";
        external = [
          "${pkgs.bat}/bin/bat"
          "--paging=always"
          "--style=plain"
          "{file}"
        ];
        leave_broot = false;
        apply_to = "file";
        extensions = [
          "csv"
          "tsv"
          "log"
        ];
      }
      {
        invocation = "table-view";
        key = "alt-t";
        external = [
          (toString table)
          "{file}"
        ];
        leave_broot = false;
        apply_to = "file";
        extensions = [
          "csv"
          "tsv"
        ];
      }
      {
        invocation = "stats";
        key = "alt-s";
        external = [
          (toString stats)
          "{file}"
        ];
        leave_broot = false;
        apply_to = "file";
        extensions = [ "csv" ];
      }
      {
        invocation = "view-bin";
        key = "enter";
        external = [
          "${pkgs.hexyl}/bin/hexyl"
          "{file}"
        ];
        leave_broot = false;
        apply_to = "file";
        extensions = [
          "bin"
          "dat"
          "elf"
          "so"
          "o"
          "class"
          "wasm"
          "exe"
        ];
      }
      {
        invocation = "view-json";
        key = "enter";
        external = [
          "${pkgs.bat}/bin/bat"
          "--language=json"
          "--paging=always"
          "{file}"
        ];
        leave_broot = false;
        apply_to = "file";
        extensions = [ "json" ];
      }
      {
        invocation = "view-yaml";
        key = "enter";
        external = [
          "${pkgs.bat}/bin/bat"
          "--language=yaml"
          "--paging=always"
          "{file}"
        ];
        leave_broot = false;
        apply_to = "file";
        extensions = [
          "yaml"
          "yml"
        ];
      }
      {
        invocation = "open";
        external = [
          "${pkgs.xdg-utils}/bin/xdg-open"
          "{file}"
        ];
        leave_broot = true;
        apply_to = "file";
      }
    ];
  };
}
