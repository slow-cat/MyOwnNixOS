{
  lib,
  pkgs,
  stylixColors,
  stylixHex,
  ironbarFont,
  ...
}:

let
  args = {
    inherit
      lib
      pkgs
      stylixColors
      stylixHex
      ironbarFont
      ;
  };
  elements = {
    battery = import ./battery.nix args;
    bluetooth = import ./bluetooth.nix args;
    brightness = import ./brightness.nix args;
    clipboard = import ./clipboard.nix args;
    clock = import ./clock.nix args;
    cpu = import ./cpu.nix args;
    launcher = import ./launcher.nix args;
    memory = import ./memory.nix args;
    # menu = import ./menu.nix args;
    music = import ./music.nix args;
    notifications = import ./notifications.nix args;
    power = import ./power.nix args;
    systemInfo = import ./system-info.nix args;
    tray = import ./tray.nix args;
    volume = import ./volume.nix args;
    workspaces = import ./workspaces.nix args;
  };
  cornOrder = with elements; [
    # menu
    workspaces
    launcher
    music
    battery
    systemInfo
    cpu
    memory
    clipboard
    volume
    tray
    clock
    bluetooth
    notifications
    brightness
    power
  ];
  cssOrder = with elements; [
    clock
    clipboard
    launcher
    # menu
    music
    notifications
    systemInfo
    tray
    volume
    workspaces
    power
  ];
in
{
  corn = lib.concatMapStringsSep "\n" (element: element.corn) cornOrder;
  css = lib.concatMapStringsSep "\n" (element: element.css) cssOrder;
  assets = lib.foldl' lib.recursiveUpdate { } (map (element: element.assets) cornOrder);
}
