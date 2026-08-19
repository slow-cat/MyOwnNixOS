{ ... }:

{
  assets = { };

  corn = ''
    $volume = { type = "volume" format = "{icon} {percentage}% {name}"}
  '';

  css = ''
    /* --- volume --- */

        .volume .source {
            margin-left: var(--margin-sm);
        }

        .popup-volume .device-box {
            padding-right: var(--margin-lg);
            margin-right: var(--margin-lg);
            border-right: 1px solid var(--color-border-light);
        }
  '';
}
