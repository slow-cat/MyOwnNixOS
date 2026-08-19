''
  layout {
      gaps 4

      preset-column-widths {
          proportion 0.33333
          proportion 0.5
          proportion 0.66667
      }

      default-column-width { proportion 0.5; }
      focus-ring {
          width 0
          active-color "#ffbb66"
          inactive-color "#180c24"
      }
      border {
          on
          width 3
          active-color "#3b0f69"
          inactive-color "#505050"
      }
      shadow {
          softness 12
          spread 2
          offset x=0 y=4
          color "#251226cc"
      }
      tab-indicator {
          width 8
          gap 4
          length total-proportion=0.5
          position "left"
          place-within-column
          active-color "#3b0f69"
          inactive-color "#505050"
      }
  }

  window-rule {
      geometry-corner-radius 12
      clip-to-geometry true
  }
''
