let
  helixMarkdown = import ../../helix/languages/markdown.nix;
in
{
  name = "Markdown";
  language = {
    language_servers = helixMarkdown.language.language-servers;
  };
}
