return function(cr, width, height)
  local state = rawget(_G, "ironbar_stopwatch_state")
  local cx, cy = width / 2, height / 2
  cr:set_source_rgb(@base05DecR@, @base05DecG@, @base05DecB@)

  if state and state.running then
    cr:rectangle(cx - 6, cy - 9, 4, 18)
    cr:rectangle(cx + 2, cy - 9, 4, 18)
  else
    cr:move_to(cx - 5, cy - 10)
    cr:line_to(cx + 9, cy)
    cr:line_to(cx - 5, cy + 10)
    cr:close_path()
  end
  cr:fill()
end
