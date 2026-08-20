{
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
    (import ./rust.nix { inherit pkgs; })
    (import ./toml.nix { inherit pkgs; })
    (import ./typst.nix { inherit pkgs; })
  ];
  sharedLanguageDefinitions = [
    (import ./typos.nix { inherit pkgs; })
    (import ./vale.nix { inherit pkgs; })
  ];
  sharedLanguageServers = map (definition: definition.language-server) sharedLanguageDefinitions;
  sharedLanguagePackages = lib.concatMap (definition: definition.packages) sharedLanguageDefinitions;
  languageSpecificServers = map (definition: definition.language-server or { }) languageDefinitions;
  languagePackages = lib.concatMap (definition: definition.packages or [ ]) languageDefinitions;
in
{
  packages = lib.unique (sharedLanguagePackages ++ languagePackages);
  config = {
    language-server = lib.foldl' lib.recursiveUpdate { } (
      sharedLanguageServers ++ languageSpecificServers
    );
    language = map (definition: definition.language) languageDefinitions;
    grammar = import ./grammars.nix;
  };
}
