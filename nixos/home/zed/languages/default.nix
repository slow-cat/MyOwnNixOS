{
  inputs,
  lib,
  pkgs,
}:

let
  languageDefinitions = [
    (import ./bash.nix)
    (import ./c.nix { inherit pkgs; })
    (import ./cpp.nix { inherit pkgs; })
    (import ./java.nix { inherit pkgs; })
    (import ./latex.nix { inherit pkgs; })
    (import ./markdown.nix)
    (import ./nix.nix { inherit pkgs; })
    (import ./python.nix { inherit pkgs; })
    (import ./rust.nix { inherit inputs pkgs; })
    (import ./toml.nix { inherit pkgs; })
    (import ./typst.nix { inherit pkgs; })
  ];
in
{
  languages = builtins.listToAttrs (
    map (definition: {
      name = definition.name;
      value = definition.language;
    }) languageDefinitions
  );
  lsp = lib.foldl' lib.recursiveUpdate { } (
    map (definition: definition.lsp or { }) languageDefinitions
  );
}
