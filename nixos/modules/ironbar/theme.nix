{ stylixHex, ironbarFont }:

''
  :root {
          --color-dark-primary: ${stylixHex.base00}ee;
          --color-dark-secondary: ${stylixHex.base01}ee;

          --color-border-dark: ${stylixHex.base04}66;
          --color-border-light: ${stylixHex.base04}33;

          --color-white: ${stylixHex.base05};
          --color-active: ${stylixHex.base0D}cc;
          --color-urgent: ${stylixHex.base08};

          --gradient: linear-gradient(
              90deg,
              ${stylixHex.base00}ee 0%,
              ${stylixHex.base01}ee 50%,
              ${stylixHex.base00}ee 100%
          );

          --margin-lg: 1em;
          --margin-sm: 0.5em;
          --margin-xs: 0.25em;

          --size-xxl: 2.6em;
          --size-xl: 2.2em;
          --size-lg: 1.5em;
          --size-md: 12px;
      }

      * {
          color: var(--color-white);
        font-family: "${ironbarFont}";
          font-size: var(--size-md);
          border-radius: 0;
          border: none;
          box-shadow: none;
      }

      popover, popover contents {
          border-radius: 12px;
          padding: 0;
      }

      window, popover {
          background-color: var(--color-dark-secondary);
      }

      box, label, calendar {
          background-color: transparent;
      }

      #bar, popover contents {
          background: var(--gradient);
      }

      scale.horizontal highlight {
          background: linear-gradient(90deg, ${stylixHex.base0D}cc 35%, ${stylixHex.base0E}b2 100%);
      }

      scale.vertical highlight {
          background: linear-gradient(0, ${stylixHex.base0D}cc 35%, ${stylixHex.base0E}b2 100%);
      }

      slider {
          border-radius: 100%;
      }

      button {
          background: transparent;
          color: var(--color-white);
          padding-left: var(--margin-sm);
          padding-right: var(--margin-sm);
      }

      button:hover {
          background: ${stylixHex.base02}cc;
      }

      button:active, button:checked {
          background: ${stylixHex.base03}cc;
      }

      dropdown popover row:hover, dropdown popover row:focus, dropdown popover row:selected {
          background-color: var(--color-dark-secondary);
      }

      radio {
          /* make purple */
          -gtk-icon-filter: hue-rotate(45deg) contrast(0.6);
          margin-right: var(--margin-sm);
      }

      #end > * + * {
          margin-left: var(--margin-sm);
      }

      .popup {
          padding: var(--margin-lg);
      }
''
