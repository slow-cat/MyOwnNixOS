{ stylixHex }:

let
  theme = builtins.replaceStrings
    [
      "@base00@"
      "@base01@"
      "@base02@"
      "@base03@"
      "@base05@"
      "@base0D@"
    ]
    [
      stylixHex.base00
      stylixHex.base01
      stylixHex.base02
      stylixHex.base03
      stylixHex.base05
      stylixHex.base0D
    ]
    (builtins.readFile ./theme.css);
in
builtins.concatStringsSep "\n" [
  theme
  (builtins.readFile ./settings.css)
  (builtins.readFile ./addons.css)
]
