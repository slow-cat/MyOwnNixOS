{ pkgs, ... }:

let
  logo = pkgs.fetchurl {
    url = "https://upload.wikimedia.org/wikipedia/commons/6/66/OpenAI_logo_2025_%28symbol%29.svg";
    hash = "sha256-yjWlcjFjtqdmuLN96b7dJMKzroHTyqS5QpzLke+HPMc=";
  };
  widget = pkgs.runCommand "ironbar-codex-widget" { nativeBuildInputs = [ pkgs.python3 ]; } ''
    mkdir -p "$out"
    cp ${./codex_widget}/*.lua "$out/"
    # Resolve the widget's assets in the Nix store instead of the user's config directory.
    substituteInPlace "$out/codex.lua" "$out/load_mask.lua" \
      --replace-fail 'ironbar.config_dir' "\"$out\"" \
      --replace-fail '/codex_widget/' '/'
    cp ${logo} "$out/openai.svg"
    python ${./codex_widget/split_openai_holes.py} "$out/openai.svg" -o "$out/holes"
  '';
in
{
  assets.codex_widget = widget;
  corn = ''
    $codex_widget = {type = "cairo" path = "$config_dir/codex_widget/codex.lua" frequency = 100 width = 24 height = 24}
  '';
  css = "";
}
