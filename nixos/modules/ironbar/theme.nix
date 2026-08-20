{ stylixHex, ironbarFont }:

builtins.replaceStrings
  [
    "@base00@"
    "@base01@"
    "@base02@"
    "@base03@"
    "@base04@"
    "@base05@"
    "@base08@"
    "@base0D@"
    "@base0E@"
    "@ironbarFont@"
  ]
  [
    stylixHex.base00
    stylixHex.base01
    stylixHex.base02
    stylixHex.base03
    stylixHex.base04
    stylixHex.base05
    stylixHex.base08
    stylixHex.base0D
    stylixHex.base0E
    ironbarFont
  ]
  (builtins.readFile ./theme.css)
