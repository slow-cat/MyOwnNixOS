(() => {
  try {
    const observerService = Components.classes[
      "@mozilla.org/observer-service;1"
    ].getService(Components.interfaces.nsIObserverService);
    const consoleService = Components.classes[
      "@mozilla.org/consoleservice;1"
    ].getService(Components.interfaces.nsIConsoleService);
    const hoverDelay = 300;
    const closeDelay = 150;
    const menus = [
      {
        buttonId: "unified-extensions-button",
        panelId: "unified-extensions-panel",
      },
      {
        buttonId: "PanelUI-menu-button",
        panelId: "appMenu-popup",
      },
    ];

    const reportError = (error) => {
      consoleService.logStringMessage(`hover-menus: ${error.stack || error}`);
    };

    const attachHoverMenus = (browserWindow) => {
      try {
        for (const { buttonId, panelId } of menus) {
          const button = browserWindow.document.getElementById(buttonId);
          if (!button || button.dataset.hoverMenuAttached) continue;

          button.dataset.hoverMenuAttached = "true";
          let openTimerId;
          let closeTimerId;

          const getPanel = () =>
            browserWindow.document.getElementById(panelId);

          const cancelClose = () => {
            browserWindow.clearTimeout(closeTimerId);
          };

          const closeWhenOutside = () => {
            browserWindow.clearTimeout(closeTimerId);
            closeTimerId = browserWindow.setTimeout(() => {
              const panel = getPanel();
              if (
                panel &&
                !button.matches(":hover") &&
                !panel.matches(":hover") &&
                panel.state !== "closed"
              ) {
                if (panelId === "appMenu-popup") {
                  browserWindow.PanelUI.hide();
                } else {
                  panel.hidePopup();
                }
              }
            }, closeDelay);
          };

          const attachPanel = () => {
            const panel = getPanel();
            if (!panel || panel.dataset.hoverMenuAttached) return;

            panel.dataset.hoverMenuAttached = "true";
            panel.addEventListener("mouseenter", cancelClose);
            panel.addEventListener("mouseleave", closeWhenOutside);
          };

          browserWindow.document.addEventListener("popupshown", (event) => {
            if (event.target.id === panelId) attachPanel();
          });

          button.addEventListener("mouseenter", () => {
            cancelClose();
            openTimerId = browserWindow.setTimeout(() => {
              if (button.matches(":hover") && button.getAttribute("open") !== "true") {
                button.click();
                attachPanel();
              }
            }, hoverDelay);
          });

          button.addEventListener("mouseleave", () => {
            browserWindow.clearTimeout(openTimerId);
            closeWhenOutside();
          });

          attachPanel();
        }
      } catch (error) {
        reportError(error);
      }
    };

    observerService.addObserver(
      {
        observe: attachHoverMenus,
      },
      "browser-delayed-startup-finished",
    );
  } catch (error) {
    Components.utils.reportError(error);
  }
})();
