{
  config,
  pkgs,
  ...
}:

let
  colors = config.lib.stylix.colors;
  rgba =
    color: alpha:
    let
      f = col: "${colors."${color}-rgb-${col}"}";
    in
    "rgba(${f "r"},${f "g"},${f "b"},${toString alpha})";
in
{
  home.packages = [ pkgs.nwg-drawer ];
  xdg.configFile."nwg-drawer/drawer.css".text = ''
    window {
            background-color: ${rgba "base00" 0.70};
            
            color: #${colors.base05}
        }
        /* search entry */
        entry {
            background-color: ${rgba "base0E" 0.20}
        }

        button, image {
            background: none;
            border: none
        }

        button:hover {
            background-color: ${rgba "base0C" 0.20}
        }

        /* in case you wanted to give category buttons a different look */
        #category-button {
            margin: 0 10px 0 10px
        }

        #pinned-box {
            padding-bottom: 5px;
            border-bottom: 1px dotted gray
        }

        #files-box {
            padding: 5px;
            border: 1px dotted gray;
            border-radius: 15px
        }

        /* math operation result label */
        #math-label {
            font-weight: bold;
            font-size: 16px
        }
  '';
}
