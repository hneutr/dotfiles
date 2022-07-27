local M = {}
local api = vim.api

local toggle_chars = {'-', '✓', '?', '~'}
local default_char = '-'

function toggle_item(toggle_char, mode)
  local start_line = api.nvim_win_get_cursor(0)[1] - 1
  local end_line = start_line + 1

  if mode == 'v' then
    start_line = api.nvim_buf_get_mark(0, '<')[1] - 1
    end_line = api.nvim_buf_get_mark(0, '>')[1]
  end

  local lines = api.nvim_buf_get_lines(0, start_line, end_line, false)

  local outermost_toggle_char = M.find_outermost_toggle_char(lines)

  if outermost_toggle_char then
    local new_toggle_char = toggle_char

    if outermost_toggle_char == toggle_char then
      new_toggle_char = default_char
    end

    local newLines = {}
    for k, line in ipairs(lines) do
      table.insert(newLines, M.change_toggle_char(line, new_toggle_char))
    end

    api.nvim_buf_set_lines(0, start_line, end_line, false, newLines)
  end
end

function M.change_toggle_char(line, new_toggle_char)
  local whitespace = string.len(line) - string.len(vim.trim(line))

  local char = M.get_toggle_char(line)

  local newLine = line
  if char ~= new_toggle_char then
    local parts = vim.split(line, char)

    for i, part in ipairs(parts) do
      if i == 1 then
        if string.len(vim.trim(part)) == 0 then
          newLine = part .. new_toggle_char
        else
          newLine = new_toggle_char .. part
        end
      else
        newLine = newLine .. part
      end
    end
  end

  return newLine
end

function M.find_outermost_toggle_char(lines)
  local smallestIndent = 1000
  local outermostToggleChar = ''

  for ln, line in ipairs(lines) do
    local char = M.get_toggle_char(line)

    if char ~= -1 then
      local indent = string.len(line) - string.len(vim.trim(line))

      if indent < smallestIndent then
        smallestIndent = indent
        outermostToggleChar = char
      end
    end
  end

  return outermostToggleChar
end

function M.get_toggle_char(line)
  line = vim.trim(line)
  for i, char in ipairs(toggle_chars) do
    if vim.startswith(line, char) then
      return char
    end
  end
end
