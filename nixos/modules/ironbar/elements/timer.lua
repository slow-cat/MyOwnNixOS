local state = rawget(_G, "ironbar_stopwatch_state")
if not state then
	state = { running = false, elapsed = 0, started_at = 0, last_cmd = "" }
	rawset(_G, "ironbar_stopwatch_state", state)
end

local function now()
	local time = ironbar:unixtime()
	return time.secs
end

local function toggle()
	if state.running then
		state.elapsed = state.elapsed + now() - state.started_at
		state.running = false
	else
		state.started_at = now()
		state.running = true
	end
end

local function reset()
	state.running = false
	state.elapsed = 0.0
	state.started_at = 0.0
end

local function current()
	if state.running then
		return state.elapsed + now() - state.started_at
	end

	return state.elapsed
end

local function handle_command()
	local ok, cmd = pcall(function()
		return ironbar:var_get("stopwatch_cmd")
	end)
	if not ok then
		return
	end
	cmd = cmd or ""
	if cmd == state.last_cmd then
		return
	end

	state.last_cmd = cmd

	local action = cmd:match("^([^:]+)")
	if action == "toggle" then
		toggle()
	elseif action == "reset" then
		reset()
	end
end

local function format_time(t)
	local seconds = math.floor(t)
	local sec = seconds % 60
	local min = math.floor(seconds / 60) % 60
	local hour = math.floor(seconds / 3600)

	if hour > 0 then
		return string.format("%02d:%02d:%02d", hour, min, sec)
	end

	return string.format("%02d:%02d", min, sec)
end

local function draw_timer(cr, width, height)
	handle_command()

	local elapsed_now = current()
	local text = format_time(elapsed_now)

	if height > 100 then
		local cx, cy = width / 2, height / 2
		local radius = math.min(width, height) / 2 - 20
		local seconds = elapsed_now % 60
		local minutes = math.floor(elapsed_now / 60) % 60
		local hours = math.floor(elapsed_now / 3600) % 12
		local start_angle = -math.pi / 2

		cr:set_source_rgb(@base05DecR@, @base05DecG@, @base05DecB@)
		cr:set_line_width(radius / 8)
		cr:arc(cx, cy, radius, start_angle, start_angle + (hours + minutes / 60 + seconds / 3600) / 12 * math.pi * 2)
		cr:stroke()
		cr:arc(cx, cy, radius * 0.8, start_angle, start_angle + (minutes + seconds / 60) / 60 * math.pi * 2)
		cr:stroke()
		cr:arc(cx, cy, radius * 0.6, start_angle, start_angle + seconds / 60 * math.pi * 2)
		cr:stroke()

		local centiseconds = math.floor(elapsed_now * 100) % 100
		local clock_text = text .. string.format(".%02d", centiseconds)
		local font_size = radius / 5.5
		cr:select_font_face("monospace", 0, 0)
		cr:set_font_size(font_size)
		local cell = font_size * 0.62
		local left = cx - #clock_text * cell / 2
		cr:set_source_rgb(@base05DecR@, @base05DecG@, @base05DecB@)
		for i = 1, #clock_text do
			cr:move_to(left + (i - 1) * cell, cy + font_size / 2.5)
			cr:show_text(clock_text:sub(i, i))
		end

		return
	end

	cr:set_source_rgb(@base05DecR@, @base05DecG@, @base05DecB@)
	cr:select_font_face("monospace", 0, 0)
	cr:set_font_size(16)

	local initial_ext = cr:text_extents(text)
	if initial_ext.width > width - 8 then
		cr:set_font_size(16 * math.max(1, width - 8) / initial_ext.width)
	end

	local ext = cr:text_extents(text)

	cr:move_to((width - ext.width) / 2 - ext.x_bearing, (height - ext.height) / 2 - ext.y_bearing)

	cr:show_text(text)
end

return draw_timer
