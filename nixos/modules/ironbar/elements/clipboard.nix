{ ... }:

{
  assets = { };

  corn = ''
    $clipboard = { type = "clipboard" max_items = 5 truncate.mode = "end" truncate.length = 30 }
  '';

  css = ''
    .popup-clipboard .item {
            padding: var(--margin-xs);
        }

        .popup-clipboard .item + .item {
            border-top: 1px solid var(--color-border-light);
        }
  '';
}
