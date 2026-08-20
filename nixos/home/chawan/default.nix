{
  pkgs,
  ...
}:

let
  startupJs = pkgs.writeText "startup.js" (builtins.readFile ./startup.js);
in
{
  home.packages = [
    (pkgs.chawan.overrideAttrs (old: rec {
      version = "0.4.4";

      src = pkgs.fetchurl {
        url = "https://git.sr.ht/~bptato/chawan/archive/v${version}.tar.gz";
        hash = "sha256-4KBuFQThClHGAJdR15t5jJjYJ05Vn+GV1LS33a35G7g=";
      };
      preBuild = (old.preBuild or "") + ''
        export XDG_CACHE_HOME="$TMPDIR/.cache"
        mkdir -p "$XDG_CACHE_HOME"
      '';
    }))
  ];
  xdg.configFile."chawan/config.toml".text = ''
    [buffer]
    images = true

    [network]

    [start]
    startup-script = ''''
    cmd.webSearch = () => pager.load("ddg:")
    fzfMenu=eval(readFile("${startupJs}",""))
    cmd.fzfMenu = () => fzfMenu()
    ''''

    [page]
    ':' = 'fzfMenu'
    'H' = 'prevBuffer'
    'L' = 'nextBuffer'
    'g e' = 'gotoLineOrEnd'
  '';

}
