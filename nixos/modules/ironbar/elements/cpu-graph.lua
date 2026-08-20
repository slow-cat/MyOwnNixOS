local function text_left_center(cr, x, y, text)
  local extent = cr:text_extents(text)
  cr:move_to(x, y + extent.height / 2 + 2)
  cr:show_text(text)
  return extent.width
end

local function text_right_center(cr, x, y, text)
  local extent = cr:text_extents(text)
  cr:move_to(x - extent.width, y + extent.height / 2 + 2)
  cr:show_text(text)
  return extent.width
end

local function draw(cr, area_width, area_height)
    local draw_height = area_height - 4
    local mean_cpu_frequency = tonumber(ironbar:var_get("sysinfo.cpu_frequency.mean")) or 0
    local cpu_percent = ironbar:var_list("sysinfo.cpu_percent") or {}
    local mean_cpu_percent = tonumber(cpu_percent["mean"]) or 0
    local cores = {}

    -- Discover the logical CPUs exposed to this VM. This also adapts when
    -- QEMU CPU hotplug changes the count without rebuilding the system.
    for key, value in pairs(cpu_percent) do
      local index = tostring(key):match("^cpu(%d+)$")
      local percent = tonumber(value)
      if index and percent then
        cores[#cores + 1] = {
          index = tonumber(index),
          percent = percent,
        }
      end
    end
    table.sort(cores, function(a, b) return a.index < b.index end)

    -- Some sysinfo implementations expose only the aggregate value.
    if #cores == 0 then
      cores[1] = { index = 0, percent = mean_cpu_percent }
    end

    -- Adjust according to preference.
    -- The used icon requires a Nerd Font though
    cr:select_font_face("@ironbarFont@")
    cr:set_font_size(draw_height - 4)

    -- Color is set by overall usage
    -- Using temperature might be an alternative
    if mean_cpu_percent > 80 then
      cr:set_source_rgb(
        @base08DecR@,
        @base08DecG@,
        @base08DecB@
      )
    elseif mean_cpu_percent > 50 then
      cr:set_source_rgb(
        @base0ADecR@,
        @base0ADecG@,
        @base0ADecB@
      )
    else
      cr:set_source_rgb(
        @base05DecR@,
        @base05DecG@,
        @base05DecB@
      )
    end

    local header_width = text_left_center(cr, 0, draw_height / 2, "\u{eeb2}") + 5
    local cpu_info
    if mean_cpu_frequency > 0 then
      cpu_info = string.format("%3.1f%% %2.2fGHz", mean_cpu_percent, mean_cpu_frequency / 1000000000.0)
    else
      cpu_info = string.format("%3.1f%%", mean_cpu_percent)
    end
    local tail_width = text_right_center(cr, area_width, draw_height / 2, cpu_info) + 5

    local bar_width = math.max(0.5, (area_width - header_width - tail_width - 4) / #cores)

    for slot, core in ipairs(cores) do
      local height = math.max(math.ceil(core.percent * draw_height / 100.0), 1)

      cr:rectangle((slot - 1) * bar_width + header_width + 2, area_height - height - 2, bar_width, height)
      cr:fill()
    end
end

return draw
