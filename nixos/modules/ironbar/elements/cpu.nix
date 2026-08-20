{
  pkgs,
  stylixColors,
  ironbarFont,
  ...
}:

let
  cpuGraphLua = pkgs.replaceVars ./cpu-graph.lua {
    inherit ironbarFont;
    base08DecR = stylixColors."base08-dec-r";
    base08DecG = stylixColors."base08-dec-g";
    base08DecB = stylixColors."base08-dec-b";
    base0ADecR = stylixColors."base0A-dec-r";
    base0ADecG = stylixColors."base0A-dec-g";
    base0ADecB = stylixColors."base0A-dec-b";
    base05DecR = stylixColors."base05-dec-r";
    base05DecG = stylixColors."base05-dec-g";
    base05DecB = stylixColors."base05-dec-b";
  };
in
{
  assets = {
    "cpu_graph.lua" = cpuGraphLua;
  };

  corn = ''
    $cpu_graph = {type = "cairo" path = "$config_dir/cpu_graph.lua" frequency = 500 width = 320 height = 20}
    $cpu_button= {
        type  = "custom"
        name  = "cpu-btn"
        class = "cpu-btn"
        bar =[ {
            type = "button"
            name="cpu-btn-toggle"
            on_click="popup:toggle"
            widgets=[{
                type = "sys_info"
                format = [" {cpu_percent}%"]
                interval = 10
                }]
            } ]
        justify = "fill"
        popup=[{
            type = "box"
            orientation = "vertical"
            widgets =[
                $cpu_graph
            ]
        }]
    }
  '';

  css = ''

  '';
}
