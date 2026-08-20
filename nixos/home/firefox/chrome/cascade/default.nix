{ pkgs }:

let
  source = pkgs.fetchFromGitHub {
    owner = "cascadefox";
    repo = "cascade";
    rev = "52dd00e76348bab226701c6316a8b6581549d21b";
    hash = "sha256-MW6E9OaTGlnbHMRl8svgIyqd7BzYOjvUYi92sdgxNCc=";
  };
  patchedSource = pkgs.applyPatches {
    name = "cascade-firefox-css";
    src = source;
    patches = [
      ./firefox-152.patch
      ./hide-window-controls.patch
    ];
  };
in
builtins.readFile "${patchedSource}/chrome/includes/cascade-tabs.css"
