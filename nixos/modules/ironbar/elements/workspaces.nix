{ ... }:

{
  assets = { };

  corn = ''
    $workspaces = { type = "workspaces"}
  '';

  css = ''
    /* --- workspaces --- */

        .workspaces .item.visible {
            box-shadow: inset 0 -1px var(--color-white);
        }

        .workspaces .item.focused {
            box-shadow: inset 0 -1px var(--color-active);
            background-color: var(--color-dark-secondary);
        }

        .workspaces .item.urgent {
            background-color: var(--color-urgent);
        }
  '';
}
