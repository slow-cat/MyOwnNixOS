{ pkgs, ... }:
let
  source = fetchGit {
    url = "ssh://git@github.com/slow-cat/steelix-fzgrep.git";
    ref = "refs/heads/master";
  };
  fzgrep = import "${source}/steelix-fzgrep.nix" { inherit pkgs; };

in
{
  home.packages = [ (import ./steelix.nix { inherit pkgs; }) ];
  xdg.configFile."helix/helix.scm".text = ''
    (require (only-in "${fzgrep}/share/steelix-fzgrep/fzgrep.scm" fzgrep))
    (provide fzgrep)
  '';
  xdg.configFile."helix/init.scm".text = ''
    (require (only-in "helix/keymaps.scm" keymap))
    (require (only-in "helix/static.scm" cx->current-file))
    (require (only-in "fzgrep/fzgrep.scm"
                    set-fzgrep-query-handler! default-fzgrep-query))
    (require-builtin steel/filesystem)

    (set-fzgrep-query-handler!
      (lambda (input cwd)
        (define file (cx->current-file))
        (define base (if (string? file) (parent-name file) cwd))
        (define plan (default-fzgrep-query input base))
        (hash 'query (hash-ref plan 'query)
              'paths
              (map (lambda (path)
                    (if (equal? (string-ref path 0) #\/)
                        path
                        (string-append base "/" path)))
                  (hash-ref plan 'paths)))))

    (require (only-in "helix/keymaps.scm" keymap))
    (keymap (global) (normal (space (f ":fzgrep"))))
  '';
  xdg.configFile."helix/fzgrep/fzgrep.scm".source = "${fzgrep}/share/steelix-fzgrep/fzgrep.scm";
  xdg.dataFile."steel/native/libsteel_pty.so".source = "${fzgrep}/lib/libsteel_pty.so";
}
