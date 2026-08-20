{
  lib,
  pkgs,
  stylixColors,
  ...
}:

let
  memorySysfs = /sys/devices/system/memory;
  memoryBlockCount =
    if builtins.pathExists memorySysfs then
      builtins.length (
        builtins.filter (name: builtins.match "memory[0-9]+" name != null) (
          builtins.attrNames (builtins.readDir memorySysfs)
        )
      )
    else
      0;
  memoryTotalKiBFile =
    pkgs.runCommandLocal "ironbar-memory-total-${toString memoryBlockCount}-kib" { }
      ''
        awk '/^MemTotal:/ { print $2; exit }' /proc/meminfo > "$out"
        test -s "$out"
      '';
  memoryTotalKiB = lib.strings.toInt (lib.removeSuffix "\n" (builtins.readFile memoryTotalKiBFile));

  memstatLua = pkgs.replaceVars ./memory.lua {
    memoryTotalKiB = toString memoryTotalKiB;
    base00DecR = stylixColors."base00-dec-r";
    base00DecG = stylixColors."base00-dec-g";
    base00DecB = stylixColors."base00-dec-b";
    base05DecR = stylixColors."base05-dec-r";
    base05DecG = stylixColors."base05-dec-g";
    base05DecB = stylixColors."base05-dec-b";
  };
in
{
  assets = {
    "memstat.lua" = memstatLua;
  };

  corn = ''
    $memstat_graph = {
        type = "cairo"
        path = "$config_dir/memstat.lua"
        frequency = 250
        width = 640
        height = 240
    }
    $mem_button= {
        type  = "custom"
        name  = "mem-btn"
        class = "mem-btn"
        bar =[ {
            type = "button"
            name="mem-btn-toggle"
            on_click="popup:toggle"
            widgets=[{
                type = "sys_info"
                format = [" {memory_percent}%"]
                interval = 10
            }]
        }]
        justify = "fill"
        popup=[{
            type = "box"
            orientation = "h"
            widgets =[
            $memstat_graph
            ]
        }]
    }
  '';

  css = ''

  '';
}
