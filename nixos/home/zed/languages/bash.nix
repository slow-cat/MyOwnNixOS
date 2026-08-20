let
  helixBash = import ../../helix/languages/bash.nix;
in
{
  name = "Shell Script";
  language.language_servers = helixBash.language.language-servers;
}
