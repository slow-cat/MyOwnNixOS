{ stylixHex }:

let
  theme =
    builtins.replaceStrings
      [
        "@base00@"
        "@base01@"
        "@base02@"
        "@base03@"
        "@base05@"
        "@base08@"
        "@base09@"
        "@base0A@"
        "@base0B@"
        "@base0C@"
        "@base0D@"
        "@base0E@"
        "@base0F@"
      ]
      [
        stylixHex.base00
        stylixHex.base01
        stylixHex.base02
        stylixHex.base03
        stylixHex.base05
        stylixHex.base08
        stylixHex.base09
        stylixHex.base0A
        stylixHex.base0B
        stylixHex.base0C
        stylixHex.base0D
        stylixHex.base0E
        stylixHex.base0F
      ]
      (builtins.readFile ./theme.css);
  cssFiles = [
    ./cascade.css
    ./toolbar-layout.css
    ./controls.css
    ./appearance.css
    ./autohide.css
    ./urlbar-focus.css
    ./utility-windows.css
  ];
in
builtins.concatStringsSep "\n" ([ theme ] ++ map builtins.readFile cssFiles)
