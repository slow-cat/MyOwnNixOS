{ ... }:

{
  assets = { };

  corn = ''

    $brightnesslider={type = "slider" min = 0 max = 100 step = 1 value = "brightnessctl --class=backlight -m | cut -d, -f4 | tr -d '%'" on_change = "!brightnessctl --class=backlight set ''${0%.*}%" show_label = true length = 200}
    $brightness = {
        type = "custom"
        name = "brightness-slider"
        class = "brightness-slider"
        show_if = "brightnessctl --class=backlight get >/dev/null 2>&1"
        bar = [ { type = "button" name="power-btn" label = "󰃠 {{brightnessctl --class=backlight -m | cut -d, -f4}}" on_click = "popup:toggle" } ]
        popup = [{
                type = "box"
                widgets =[
                    { type = "label" name = "header" label = "Brightness" }
                    $brightnesslider
                ]

        }]
    }
  '';

  css = ''

  '';
}
