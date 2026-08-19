{ ... }:

{
  assets = { };

  corn = ''
    $launcher = { type = "launcher" favorites = [ "firefox" "foot"] truncate.mode = "end" truncate.max_length = 30  icon_size = 14 }
  '';

  css = ''
    /* --- launcher --- */

        .launcher .item + .item {
            margin-left: 4px;
        }

        .launcher .item.open {
            box-shadow: inset 0 -1px var(--color-white);
        }

        .launcher .item.focused {
            box-shadow: inset 0 -1px var(--color-active);
        }

        .launcher .item.urgent {
            box-shadow: inset 0 -1px var(--color-urgent);
        }

        .popup-launcher {
            padding: var(--margin-sm);
        }

        .popup-launcher .popup-item {
            padding: var(--margin-lg);
            border-radius: 10px;
        }

        .popup-launcher .popup-item label {
            margin-top: var(--margin-sm);
        }
  '';
}
