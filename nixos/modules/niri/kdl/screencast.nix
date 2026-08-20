''
  window-rule {
      match is-window-cast-target=true

      focus-ring {
          active-color "#f38ba8"
          inactive-color "#7d0d2d"
      }

      border {
          on
          active-color "#f38ba8"
          inactive-color "#7d0d2d"
      }

      shadow {
          color "#7d0d2d70"
      }

      tab-indicator {
          active-color "#f38ba8"
          inactive-color "#7d0d2d"
      }
  }
  binds {
      Mod+P {spawn-sh r#"niri msg action set-dynamic-cast-window --id $(niri msg --json pick-window | jq .id)"#; }
      Mod+M {spawn-sh r#"niri msg action set-dynamic-cast-monitor"#; }
  }
''
