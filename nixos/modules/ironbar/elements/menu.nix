{ ... }:

{
  assets = { };

  corn = ''
    $menu = { type = "menu" label = "󱓞"}
  '';

  css = ''
    /* --- menu --- */

        .menu label {
            padding: 0 var(--margin-sm);
        }

        .popup-menu .sub-menu {
            border-left: 1px solid var(--color-border-light);
            padding-left: var(--margin-sm);
        }

        .popup-menu .category, .popup-menu .application {
            padding: var(--margin-xs);
        }

        .popup-menu .category.open {
            background-color: var(--color-dark-secondary);
        }
  '';
}
