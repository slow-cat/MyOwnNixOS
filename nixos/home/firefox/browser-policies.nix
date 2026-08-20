{
  AppAutoUpdate = false;
  BackgroundAppUpdate = false;

  AIControls.Default = {
    Value = "blocked";
    Locked = true;
  };

  DisableBuiltinPDFViewer = false;
  DisableFirefoxStudies = true;
  DisableFirefoxAccounts = false;
  DisableFirefoxScreenshots = false;
  DisableForgetButton = false;
  DisableMasterPasswordCreation = false;
  DisableProfileImport = false;
  DisableProfileRefresh = false;
  DisableSetDesktopBackground = true;
  DisablePocket = true;
  DisableTelemetry = true;
  DisableFormHistory = false;
  DisablePasswordReveal = false;

  BlockAboutConfig = false;
  BlockAboutProfiles = false;
  BlockAboutSupport = true;

  DisplayMenuBar = "never";
  DontCheckDefaultBrowser = true;
  HardwareAcceleration = true;
  OfferToSaveLogins = true;
  DefaultDownloadDirectory = "/tmp";

  Preferences = {
    "ui.systemUsesDarkTheme" = {
      Value = 1;
      Status = "locked";
      Type = "number";
    };
    "browser.theme.toolbar-theme" = {
      Value = 0;
      Status = "locked";
      Type = "number";
    };
    "browser.theme.content-theme" = {
      Value = 0;
      Status = "locked";
      Type = "number";
    };
    "layout.css.prefers-color-scheme.content-override" = {
      Value = 0;
      Status = "locked";
      Type = "number";
    };
    "browser.profiles.enabled" = {
      Value = false;
      Status = "locked";
      Type = "boolean";
    };
  };
}
