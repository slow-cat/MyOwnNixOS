{
  pkgs,
  stylixColors,
  stylixHex,
  ...
}:

let
  clockLua = pkgs.writeText "ironbar-clock.lua" ''
    local function draw_clock(cr, width, height)
        local center_x = width / 2
        local center_y = height / 2
        local compact = math.min(width, height) <= 32
        local inset = compact and 0 or 20
        local radius = math.max(1, math.min(width, height) / 2 - inset)

        local date_table = os.date("*t")

        local hours = date_table["hour"]
        local minutes = date_table["min"]
        local seconds = date_table["sec"]
        local ms = ironbar:unixtime().subsec_millis / 1000


        local label_seconds = seconds
        seconds = seconds + ms

        local hours_str = tostring(hours)
        if string.len(hours_str) == 1 then
            hours_str = "0" .. hours_str
        end

        local minutes_str = tostring(minutes)
        if string.len(minutes_str) == 1 then
            minutes_str = "0" .. minutes_str
        end

        local seconds_str = tostring(label_seconds)
        if string.len(seconds_str) == 1 then
            seconds_str = "0" .. seconds_str
        end

        cr:set_source_rgb(
            ${stylixColors."base05-dec-r"},
            ${stylixColors."base05-dec-g"},
            ${stylixColors."base05-dec-b"}
        )

        if not compact then
            local font_size = radius / 5.5
            cr:move_to(center_x - font_size * 2.5 + 10, center_y + font_size / 2.5)
            cr:set_font_size(font_size)
            cr:show_text(hours_str .. ':' .. minutes_str .. ':' .. seconds_str)
            cr:stroke()
        end

        if hours > 12 then
            hours = hours - 12
        end

        local line_width = radius / 8
        local start_angle = -math.pi / 2

        local end_angle = start_angle + ((hours + minutes / 60 + seconds / 3600) / 12) * 2 * math.pi
        cr:set_line_width(line_width)
        cr:arc(center_x, center_y, radius, start_angle, end_angle)
        cr:stroke()

        end_angle = start_angle + ((minutes + seconds / 60) / 60) * 2 * math.pi
        cr:set_line_width(line_width)
        cr:arc(center_x, center_y, radius * 0.8, start_angle, end_angle)
        cr:stroke()

        if seconds == 0 then
            seconds = 60
        end

        end_angle = start_angle + (seconds / 60) * 2 * math.pi
        cr:set_line_width(line_width)
        cr:arc(center_x, center_y, radius * 0.6, start_angle, end_angle)
        cr:stroke()

        return 0
    end

    return draw_clock
  '';
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
