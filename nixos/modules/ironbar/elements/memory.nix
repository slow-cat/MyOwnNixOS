{
  lib,
  pkgs,
  stylixColors,
  ...
}:

let
  # /proc files report a size of zero to the Nix evaluator, so capture the
  # exact value in a tiny build. Including the kernel memory-block count in
  # the derivation name invalidates it when QEMU's RAM allocation changes.
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

  memstatLua = pkgs.writeText "ironbar-memstat.lua" ''
    -- Process RSS history graph for Ironbar's Cairo module.
    -- Ironbar controls canvas size using `width` and `height`.

    local lgi = require("lgi")
    local Gio = lgi.Gio
    local GLib = lgi.GLib

    local config = {
        sample_interval_ms = 1000,
        sample_width = 4,
        scale_mode = "physical",
        auto_scale_headroom = 1.10,
        background = {
            ${stylixColors."base00-dec-r"},
            ${stylixColors."base00-dec-g"},
            ${stylixColors."base00-dec-b"},
            0.20
        },
        grid = false,
        grid_color = {
            ${stylixColors."base05-dec-r"},
            ${stylixColors."base05-dec-g"},
            ${stylixColors."base05-dec-b"},
            0.10
        },
        grid_divisions = 4,
        separator_alpha = 0,
    }

    local history = {
        data = {},
        head = 1,
        len = 0,
        capacity = 0,
    }
    local previous = nil
    local last_sample_us = nil
    local mem_total_kib = ${toString memoryTotalKiB}

    local function read_status(pid)
        local file = io.open("/proc/" .. pid .. "/status", "r")
        if not file then
            return nil
        end

        local name = tostring(pid)
        local ppid = 0
        local rss = 0

        for line in file:lines() do
            local key, value = line:match("^([^:]+):%s*(.*)$")
            if key == "Name" then
                name = value
            elseif key == "PPid" then
                ppid = tonumber(value) or 0
            elseif key == "VmRSS" then
                rss = tonumber(value:match("^(%d+)")) or 0
            end
        end

        file:close()
        return {
            pid = pid,
            ppid = ppid,
            name = name,
            rss = rss,
            children = {},
        }
    end

    local function enumerate_pids()
        local pids = {}
        local directory = Gio.File.new_for_path("/proc")
        local ok, enumerator = pcall(
            directory.enumerate_children,
            directory,
            "standard::name",
            Gio.FileQueryInfoFlags.NONE,
            nil
        )

        if not ok or not enumerator then
            return pids
        end

        while true do
            local info = enumerator:next_file(nil)
            if not info then
                break
            end

            local pid = tonumber(info:get_name())
            if pid and pid >= 1 and pid == math.floor(pid) then
                pids[#pids + 1] = pid
            end
        end

        enumerator:close(nil)
        table.sort(pids)
        return pids
    end

    local function base_color(pid)
        local seed = (pid * 1103515245 + 12345) % 2147483648
        local r = 64 + (seed % 192)
        seed = math.floor(seed / 256)
        local g = 64 + (seed % 192)
        seed = math.floor(seed / 256)
        local b = 64 + (seed % 192)
        return { r / 255, g / 255, b / 255 }
    end

    local function child_color(pid, parent_color)
        local own = base_color(pid)
        if not parent_color then
            return own
        end

        return {
            own[1] * 0.35 + parent_color[1] * 0.65,
            own[2] * 0.35 + parent_color[2] * 0.65,
            own[3] * 0.35 + parent_color[3] * 0.65,
        }
    end

    local function collect_snapshot()
        local processes = {}
        local roots = {}

        for _, pid in ipairs(enumerate_pids()) do
            local process = read_status(pid)
            if process then
                processes[pid] = process
            end
        end

        for pid, process in pairs(processes) do
            local parent = processes[process.ppid]
            if parent and process.ppid ~= pid then
                parent.children[#parent.children + 1] = process
            else
                roots[#roots + 1] = process
            end
        end

        local function pid_less(a, b)
            return a.pid < b.pid
        end

        table.sort(roots, pid_less)
        for _, process in pairs(processes) do
            table.sort(process.children, pid_less)
        end

        local ordered = {}
        local total = 0

        local function visit(process, parent_color, parent_path)
            local color = child_color(process.pid, parent_color)
            local low = total
            total = total + process.rss
            local path = {}
            for index = 1, #parent_path do
                path[index] = parent_path[index]
            end
            path[#path + 1] = process.pid

            local item = {
                pid = process.pid,
                name = process.name,
                low = low,
                high = total,
                color = color,
                path = path,
            }
            ordered[#ordered + 1] = item

            for _, child in ipairs(process.children) do
                visit(child, color, path)
            end
        end

        for _, root in ipairs(roots) do
            visit(root, nil, {})
        end

        local by_pid = {}
        for _, item in ipairs(ordered) do
            by_pid[item.pid] = item
        end

        return {
            ordered = ordered,
            by_pid = by_pid,
            total = total,
        }
    end

    local function make_transition(old, current)
        local segments = {}

        local function compare_path(a, b)
            local length = math.min(#a, #b)
            for index = 1, length do
                if a[index] < b[index] then
                    return -1
                elseif a[index] > b[index] then
                    return 1
                end
            end
            if #a < #b then
                return -1
            elseif #a > #b then
                return 1
            end
            return 0
        end

        local old_ordered = old and old.ordered or {}
        local old_index = 1
        local current_index = 1

        while old_index <= #old_ordered or current_index <= #current.ordered do
            local prior = old_ordered[old_index]
            local item = current.ordered[current_index]
            local ordering

            if not prior then
                ordering = -1
            elseif not item then
                ordering = 1
            else
                ordering = compare_path(item.path, prior.path)
            end

            if ordering == 0 then
                segments[#segments + 1] = {
                    old_low = prior.low,
                    old_high = prior.high,
                    new_low = item.low,
                    new_high = item.high,
                    color = prior.color,
                }
                old_index = old_index + 1
                current_index = current_index + 1
            elseif ordering < 0 then
                -- New process: grow it from the previous old boundary.
                local previous_old = old_ordered[old_index - 1]
                local anchor = previous_old and previous_old.high or 0
                segments[#segments + 1] = {
                    old_low = anchor,
                    old_high = anchor,
                    new_low = item.low,
                    new_high = item.high,
                    color = item.color,
                }
                current_index = current_index + 1
            else
                -- Terminated process: collapse it onto the previous current
                -- boundary, matching proc.rs's cur.get(cur_idx - 1).
                local previous_current = current.ordered[current_index - 1]
                local anchor = previous_current and previous_current.high or 0
                segments[#segments + 1] = {
                    old_low = prior.low,
                    old_high = prior.high,
                    new_low = anchor,
                    new_high = anchor,
                    color = prior.color,
                }
                old_index = old_index + 1
            end
        end

        return {
            segments = segments,
            total = current.total,
        }
    end

    local function history_get(index)
        if index < 1 or index > history.len then
            return nil
        end
        local slot = ((history.head + index - 2) % history.capacity) + 1
        return history.data[slot]
    end

    local function resize_history(area_width)
        local sample_width = math.max(1, config.sample_width)
        local capacity = math.max(1, math.floor(area_width / sample_width))
        if capacity == history.capacity then
            return
        end

        local keep = math.min(history.len, capacity)
        local first = history.len - keep + 1
        local data = {}
        for index = 1, keep do
            data[index] = history_get(first + index - 1)
        end

        history.data = data
        history.head = 1
        history.len = keep
        history.capacity = capacity
    end

    local function history_push(frame)
        if history.len < history.capacity then
            local slot = ((history.head + history.len - 1) % history.capacity) + 1
            history.data[slot] = frame
            history.len = history.len + 1
            return
        end

        history.data[history.head] = frame
        history.head = (history.head % history.capacity) + 1
    end

    local function sample_if_due(area_width)
        resize_history(area_width)

        local now = GLib.get_monotonic_time()
        local interval_us = math.max(50, config.sample_interval_ms) * 1000

        if last_sample_us and now - last_sample_us < interval_us then
            return
        end

        local current = collect_snapshot()
        history_push(make_transition(previous, current))
        previous = current
        last_sample_us = now
    end

    local function scale_max()
        if config.scale_mode ~= "auto" then
            return math.max(1, mem_total_kib)
        end

        local largest = 1
        for index = 1, history.len do
            local frame = history_get(index)
            largest = math.max(largest, frame.total)
        end
        return largest * math.max(1, config.auto_scale_headroom)
    end

    local function set_rgba(cr, color)
        cr:set_source_rgba(color[1], color[2], color[3], color[4] or 1)
    end

    local function draw_background(cr, width, height)
        set_rgba(cr, config.background)
        cr:rectangle(0, 0, width, height)
        cr:fill()

        if not config.grid or config.grid_divisions < 2 then
            return
        end

        set_rgba(cr, config.grid_color)
        cr:set_line_width(1)
        for i = 1, config.grid_divisions - 1 do
            local y = math.floor(height * i / config.grid_divisions) + 0.5
            cr:move_to(0, y)
            cr:line_to(width, y)
        end
        cr:stroke()
    end

    local function draw_graph(cr, width, height)
        if history.len == 0 then
            return
        end

        local maximum = scale_max()
        local sample_width = math.max(1, config.sample_width)

        local function y(value)
            local clipped = math.min(maximum, math.max(0, value))
            return height - clipped * height / maximum
        end

        for index = 1, history.len do
            local frame = history_get(index)
            local left = (index - 1) * sample_width
            local right = left + sample_width

            for _, segment in ipairs(frame.segments) do
                cr:set_source_rgba(
                    segment.color[1],
                    segment.color[2],
                    segment.color[3],
                    0.92
                )
                cr:move_to(left, y(segment.old_low))
                cr:line_to(left, y(segment.old_high))
                cr:line_to(right, y(segment.new_high))
                cr:line_to(right, y(segment.new_low))
                cr:close_path()
                cr:fill()
            end

            if config.separator_alpha > 0 then
                cr:set_source_rgba(0, 0, 0, config.separator_alpha)
                cr:set_line_width(1)
                cr:move_to(right - 0.5, 0)
                cr:line_to(right - 0.5, height)
                cr:stroke()
            end
        end
    end

    local function draw(cr, area_width, area_height)
        local width = math.max(1, area_width or 300)
        local height = math.max(1, area_height or 120)

        sample_if_due(width)
        draw_background(cr, width, height)
        draw_graph(cr, width, height)
    end

    return draw
  '';
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
