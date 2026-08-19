{ modKey }:

''
  input {
      mod-key "${modKey}"
      keyboard {
          xkb {
              layout "jp"
          }
          numlock
      }

      touchpad {
          tap
          middle-emulation
          natural-scroll
          accel-profile "adaptive"
          accel-speed 1.0
      }

      mouse {
          natural-scroll
          accel-profile "adaptive"
          accel-speed 1.0
      }
      focus-follows-mouse
  }
  output "eDP-1" {
      scale 1
      transform "normal"
  }
''
