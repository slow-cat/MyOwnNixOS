{ ... }:

{
  assets = { };

  corn = ''
    $notifications = { type = "notifications" show_if = "pgrep -x swaync" }
  '';

  css = ''
    /* --- notifications --- */

        .notifications .count {
            font-size: 0.8em;
            padding: 0.18em;
        }
  '';
}
