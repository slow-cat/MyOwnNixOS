{ ... }:

{
  assets = { };

  corn = ''
    $battery = {
        type = "battery"
        format = "󰁹{percentage}%"
        show_icon = false
        show_if = "ls /sys/class/power_supply/ | grep --quiet '^BAT'"
        icon_size = 0
        use_default_profiles = false
        profiles = {
            low.when = { percent = 20 charging = false}
            low.format = "󱊡{percentage}%"

            low-charging.when = { percent = 20 charging = true }
            low-charging.format = "󱊤{percentage}%"

            medium.when = { percent = 50 charging = false }
            medium.format = "󱊢{percentage}%"

            medium-charging.when = { percent = 50 charging = true}
            medium-charging.format = "󱊥{percentage}%"

            good.when = { percent = 75 charging = false }
            good.format = "󱊣{percentage}%"

            good-charging.when = { percent = 75 charging = true }
            good-charging.format = "{󱊦percentage}%"

            empty.when = { percent = 1 }
        }
    }
  '';

  css = ''

  '';
}
