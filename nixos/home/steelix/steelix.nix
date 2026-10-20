{
  pkgs ? import <nixpkgs> { },
  steelix ? pkgs.steelix,
  syntaxRuntime ? pkgs.helix.runtime,
}:
let
  runtime = pkgs.runCommand "steelix-runtime" { } ''
    mkdir -p "$out/themes"
    ln -s ${syntaxRuntime}/queries "$out/queries"
    ln -s ${syntaxRuntime}/grammars "$out/grammars"
    for theme in ${steelix.src}/runtime/themes/*.toml; do
      ln -s "$theme" "$out/themes/$(basename "$theme")"
    done
    for entry in ${steelix.src}/runtime/*; do
      name="$(basename "$entry")"
      case "$name" in
        grammars|queries|themes) ;;
        *) ln -s "$entry" "$out/$name" ;;
      esac
    done
  '';
in
pkgs.runCommand "sx"
  {
    passthru = { inherit runtime steelix syntaxRuntime; };
    meta = steelix.meta // {
      mainProgram = "sx";
    };
  }
  ''
    mkdir -p "$out/bin" "$out/share/steelix"
    cp ${steelix}/bin/.hx-wrapped "$out/bin/sx"
    ln -s ${runtime} "$out/bin/runtime"
    ln -s ${runtime} "$out/share/steelix/runtime"
  ''
