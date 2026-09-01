{ stylixHex }:

let
  toolbarLayout = builtins.toJSON {
    placements = {
      "widget-overflow-fixed-list" = [ ];
      "unified-extensions-area" = [ ];
      "nav-bar" = [
        "back-button"
        "forward-button"
        "stop-reload-button"
        "urlbar-container"
        "unified-extensions-button"
        "PanelUI-menu-button"
      ];
      "toolbar-menubar" = [ "menubar-items" ];
      TabsToolbar = [ "tabbrowser-tabs" ];
      "vertical-tabs" = [ ];
      PersonalToolbar = [ "personal-bookmarks" ];
    };
    seen = [
      "save-to-pocket-button"
      "developer-button"
      "screenshot-button"
    ];
    dirtyAreaCache = [
      "nav-bar"
      "TabsToolbar"
      "vertical-tabs"
      "PersonalToolbar"
      "toolbar-menubar"
      "unified-extensions-area"
      "widget-overflow-fixed-list"
    ];
    currentVersion = 24;
    newElementCount = 0;
  };
in
{
  settings = {
    "browser.startup.homepage" = "https://wttr.in/";
    "privacy.resistFingerprinting" = false;
    "browser.theme.toolbar-theme" = 0;
    "browser.theme.content-theme" = 0;
    "layout.css.prefers-color-scheme.content-override" = 0;

    "browser.display.background_color" = stylixHex.base00;
    "browser.display.background_color.dark" = stylixHex.base00;
    "browser.display.foreground_color" = stylixHex.base05;
    "browser.display.foreground_color.dark" = stylixHex.base05;
    "browser.profiles.enabled" = false;
    "browser.uiCustomization.state" = toolbarLayout;

    "browser.tabs.tabMinWidth" = 90;
    "toolkit.tabbox.switchByScrolling" = true;
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

    "dom.webgpu.enabled" = true;
    "devtools.chrome.enabled" = true;
    "devtools.debugger.remote-enabled" = true;
    "devtools.debugger.prompt-connection" = false;
    "devtools.toolbox.host" = "window";
    "browser.sessionstore.interval" = 1000000;
    "accessibility.force_disabled" = 1;
    "browser.translation.enable" = false;
    "network.prefetch-next" = false;

    "services.sync.engine.addons" = true;

    "services.sync.engine.addresses" = true;
    "services.sync.engine.addresses.available" = true;

    "services.sync.engine.bookmarks" = true;
    "services.sync.engine.bookmarks.validation.interval" = 86400;
    "services.sync.engine.bookmarks.validation.maxRecords" = 1000;
    "services.sync.engine.bookmarks.validation.percentageChance" = 10;

    "services.sync.engine.creditcards" = true;
    "services.sync.engine.creditcards.available" = true;

    "services.sync.engine.history" = false;

    "services.sync.engine.passwords" = true;
    "services.sync.engine.passwords.validation.interval" = 86400;
    "services.sync.engine.passwords.validation.maxRecords" = 1000;
    "services.sync.engine.passwords.validation.percentageChance" = 10;

    "services.sync.engine.prefs" = false;
    "services.sync.engine.prefs.modified" = false;

    "services.sync.engine.tabs" = false;
    "services.sync.engine.tabs.filteredSchemes" = "about|resource|chrome|file|blob|moz-extension|data";

    "font.name.sans-serif.ja" = "Biz UDPGothic";
    "font.name.serif.ja" = "Biz UDPMincho";
    "font.default.x-western" = "sans-serif";

    # "services.sync.prefs.sync.privacy.sanitize.sanitizeOnShutdown" = true;
    # "privacy.history.custom" = true;
    # "privacy.clearOnShutdown.cookies" = true;
    # "privacy.clearOnShutdown.siteSettings" = false;

    # "privacy.clearOnShutdown_v2.cookiesAndStorage" = true;
    # "privacy.clearOnShutdown_v2.siteSettings" = false;
  };
}
