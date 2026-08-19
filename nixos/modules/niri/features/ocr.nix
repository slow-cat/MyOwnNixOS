{ pkgs }:

{
  tesseract = pkgs.tesseract4.override {
    enableLanguages = [
      "eng"
      "jpn"
    ];
  };
  kdl = ''
    // Screenshots OCR
    binds {
        Print repeat=false{ spawn-sh r#"grim -g "$(slurp)" /tmp/$(date +"%Y-%m-%d-%H%M%S_screenshot.png")"#; }
        Ctrl+Print repeat=false{ spawn-sh r#"grim -g "$(slurp)" - | wl-copy"#; }
        Shift+Print repeat=false{ spawn "dash" "-c" "ocr_lang=$(tesseract --list-langs | grep -v '^List of' | wofi --dmenu --hide-search -W 100  -H 200); [ -n \"$ocr_lang\" ] && range=$(slurp) && [ -n \"$range\" ] && text=$(grim -g \"$range\"  - | tesseract -l \"$ocr_lang\" - -) && [ -n \"$text\" ] && printf '%s\n' \"$text\" | zenity  --text-info --title='OCR' --width=50 --height=30 && printf '%s\n' \"$text\" | wl-copy"; }
    }
    window-rule {
        match app-id=r#"^zenity$"# title="^OCR$"
        open-floating true
    }
  '';
}
