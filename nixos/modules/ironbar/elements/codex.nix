{ pkgs, ... }:

let
  src = pkgs.fetchgit {
    url = "https://github.com/slow-cat/codex_widget.git";
    rev = "b883ab571b1d9a80ed2933b3a1f0033505b0639a";
    hash = "sha256-JBXorpBphkrGfDlo/+RvDrM9rpHaimLpDPt7h2YF4FY=";
  };
  logo = pkgs.fetchurl {
    url = "https://upload.wikimedia.org/wikipedia/commons/6/66/OpenAI_logo_2025_%28symbol%29.svg";
    hash = "sha256-yjWlcjFjtqdmuLN96b7dJMKzroHTyqS5QpzLke+HPMc=";
  };
  widget = pkgs.runCommand "ironbar-codex-widget" { nativeBuildInputs = [ pkgs.python3 ]; } ''
    mkdir -p "$out"
    cp ${src}/*.lua "$out/"
    # Resolve the widget's assets in the Nix store instead of the user's config directory.
    substituteInPlace "$out/codex.lua" "$out/load_mask.lua" \
      --replace-fail 'ironbar.config_dir' "\"$out\"" \
      --replace-fail '/codex_widget/' '/'
    cp ${logo} "$out/openai.svg"
    python ${src}/split_openai_holes.py "$out/openai.svg" -o "$out/holes"
  '';
in
{
  ironvarDefaults = {
    codex_color_logo = "0.0, 0.0, 0.0, 1.0";
    codex_color_primary = "0.3, 1.0, 0.3, 0.7";
    codex_color_secondary = "1.0, 0.3, 0.3, 0.7";
    codex_color_hands = "1.0, 1.0, 1.0, 1.0";
  };
  assets.codex_widget = widget;
  corn = ''
    $codex_widget = {type = "cairo" path = "$config_dir/codex_widget/codex.lua" frequency = 100 width = 24 height = 24}
  '';
  css = "";
}
