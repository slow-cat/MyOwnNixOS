{
  pkgs,
  stylixColors,
  ...
}:

let
  timerLua = pkgs.replaceVars ./timer.lua {
    base05DecR = stylixColors."base05-dec-r";
    base05DecG = stylixColors."base05-dec-g";
    base05DecB = stylixColors."base05-dec-b";
  };
  timerBtnLua = pkgs.replaceVars ./timer_button.lua {
    base05DecR = stylixColors."base05-dec-r";
    base05DecG = stylixColors."base05-dec-g";
    base05DecB = stylixColors."base05-dec-b";
  };
in
{
  assets = {
    "timer.lua" = timerLua;
    "timer_button.lua" = timerBtnLua;
  };

  corn = ''
    $stopwatch_reset = {
      type = "button"
      name = "stopwatch-reset"
      label = "Reset"
      on_click = "!ironbar var set stopwatch_cmd reset:$(date +%s%N)"
    }

    $stopwatch_toggle = {
      type = "button"
      name = "stopwatch-toggle"
      widgets = [
        {
          type = "cairo"
          path = "$config_dir/timer_button.lua"
          frequency = 1000
          width = 56
          height = 56
        }
      ]
      on_click = "!ironbar var set stopwatch_cmd toggle:$(date +%s%N)"
    }

    $stopwatch_popup = [
      {
        type = "box"
        name = "stopwatch-panel"
        orientation = "vertical"
        widgets = [
          {
            type = "label"
            name = "stopwatch-title"
            label = "Stopwatch"
          }
          {
            type = "cairo"
            path = "$config_dir/timer.lua"
            frequency = 33
            width = 300
            height = 290
          }
          {
            type = "box"
            halign = "center"
            widgets = [
              $stopwatch_toggle
            ]
          }
          $stopwatch_reset
        ]
      }
    ]

    $timer_widget = {
      type = "custom"
      name = "stopwatch"
      bar = [
        {
          type = "button"
          name = "stopwatch-open"
          on_click = "popup:toggle"
          widgets = [
            {
              type = "cairo"
              path = "$config_dir/timer.lua"
              frequency = 1000
              width = 60
              height = 25
            }
          ]
        }
      ]
      popup = $stopwatch_popup
    }
  '';

  css = ''
    /* --- timer --- */

    #stopwatch-open {
        color: var(--color-white);
    }

    #stopwatch-panel {
        background: transparent;
        border-radius: 14px;
        padding: 20px 24px 14px;
    }

    #stopwatch-title {
        color: var(--color-white);
        font-size: 18px;
        margin-bottom: 6px;
    }

    #stopwatch-toggle {
        color: var(--color-white);
        border: 2px solid var(--color-border-dark);
        border-radius: 100%;
        min-width: 56px;
        min-height: 56px;
        padding: 0;
        font-size: 18px;
        margin: 8px 0 16px;
    }

    #stopwatch-toggle:hover {
        border-color: var(--color-white);
        background: var(--color-border-light);
    }

    #stopwatch-toggle:active {
        background: var(--color-border-dark);
    }

    #stopwatch-reset {
        color: var(--color-border-dark);
        padding: 8px;
        border-radius: 6px;
    }

    #stopwatch-reset:hover {
        color: var(--color-white);
        background: var(--color-border-light);
    }
  '';
}
