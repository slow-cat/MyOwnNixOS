{ ... }:

{
  assets = { };

  corn = ''
    $tray = { type = "tray" icon_size = 14 }
    $tray_widget ={
        type = "custom"
        name = "tray-widget"
        class = "tray-widget"
        bar =[{type="button" name="tray-btn" label="󱊖" on_click="popup:toggle"}]
        popup=[{
            type="box"
            widgets=[
                {type="label" name="header" label="Tray"}
                $tray
            ]
        }]
    }
  '';

  css = ''
    /* --- tray --- */

        .tray popover contents {
            padding: var(--margin-lg);
        }
  '';
}
