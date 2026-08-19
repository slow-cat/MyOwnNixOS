{ ... }:

{
  assets = { };

  corn = ''
    $power_menu = {
        type = "custom"
        name = "power-menu"
        class = "power-menu"

        bar = [ { type = "button" name="power-btn" label = "󰐥" on_click = "popup:toggle" } ]

        popup = [ {
            type = "box"
            orientation = "vertical"
            widgets = [
                { type = "label" name = "header" label = "Power menu" }
                {
                    type = "box"
                    name = "buttons"
                    widgets = [
                        { type = "button" class="power-btn" label = "<span>󰐥</span>" on_click = "!shutdown now" }
                        { type = "button" class="power-btn" label = "<span>󰜉</span>" on_click = "!reboot" }
                        { type = "button" class="power-btn" label = "<span>󰍃</span>" on_click = "!reboot" }
                    ]
                }
            ]
        } ]
    }
  '';

  css = ''
    /* --- custom: power menu ---  */

        .popup-power-menu #header {
            font-size: var(--size-lg);
            margin-bottom: 0.6em;
        }

        .popup-power-menu .power-btn {
            border: 1px solid var(--color-border-dark);
            border-radius: 10px;
            padding: 0 1.2em;
        }

        .popup-power-menu .power-btn label {
            font-size: var(--size-xxl);
        }

        /* need to use funky selector
        due to widgets being wrapped in GtkRevealers */
        .popup-power-menu #buttons > * + * {
            margin-left: 1.3em;
        }
  '';
}
