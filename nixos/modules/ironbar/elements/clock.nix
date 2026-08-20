{
  pkgs,
  stylixColors,
  stylixHex,
  ...
}:

let
  clockLua = pkgs.replaceVars ./clock.lua {
    base05DecR = stylixColors."base05-dec-r";
    base05DecG = stylixColors."base05-dec-g";
    base05DecB = stylixColors."base05-dec-b";
  };
in
{
  assets = {
    "clock.lua" = clockLua;
  };

  corn = ''
    $clock = { type = "clock" }
    $cairo_clock={type="cairo" path = "$config_dir/clock.lua" frequency = 100 width = 300 height = 300}
    $cairo_clock_mini={type="cairo" path = "$config_dir/clock.lua" frequency = 15000 width = 14 height = 14}
    $clock_widget = {
        type  = "custom"
        name  = "clock-widget"
        class = "clock-widget"
        bar =[{type = "button" name="clock-toggle" on_click="popup:toggle" widgets=[$cairo_clock_mini]} ]
        justify = "fill"
        popup=[{
            type = "box"
            orientation = "vertical"
            widgets =[
                $cairo_clock
            ]
        }]
    }
  '';

  css = ''
    /* --- clock --- */

        .clock {
            font-weight: bold;
        }

        .popup-clock .calendar-clock {
            font-size: var(--size-xl);
            margin-bottom: var(--margin-xs);
        }

        .popup-clock .calendar .today {
            background-color: ${stylixHex.base0E}99;
            border-radius: 0.25em;
        }
  '';
}
