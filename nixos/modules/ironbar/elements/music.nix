{ ... }:

{
  assets = { };

  corn = ''
    $music = { type = "music" player_type = "mpd" }
  '';

  css = ''
    /* --- music --- */

        .popup-music .album-art {
            margin-right: var(--margin-lg);
            border-radius: 5px;
        }

        .popup-music .icon-box {
            margin-right: var(--margin-sm);
        }

        .popup-music .title .icon, .popup-music .title .label {
            font-size: var(--size-lg);
        }

        .popup-music .artist .label, .popup-music .album .label {
            margin-left: 6px;
        }

        .popup-music .volume .icon {
            /* fix icon offset */
            margin-right: 3px;
        }
  '';
}
