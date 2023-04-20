-- move unit tests from test/spec/lex/list_spec.lua into test/spec/list/init_spec.lua
-- features to add:
--      - continuation type (eg, '✓' list items should continue with `-`, not '✓')
--      - coloring for Sigil, Line:
--          - background
--          - underline
--          - primary color
--      - renumber list things based on scope (hard)
--      - precontinue list when new line is inserted above a list item
--      - insert list item on `r<cr>`
--      - put cursor at start of list item when there's text beyond the element
--      - BUG: don't delete subsequent text when breaking a numbered list item
require("util")
require("util.tbl")
local Object = require("util.object")
local line_utils = require("util.lines")
local line_type = require("list.line_type")

--------------------------------------------------------------------------------
--                                                                            --
--                                                                            --
--                                   Buffer                                   --
--                                                                            --
--                                                                            --
--------------------------------------------------------------------------------
Buffer = Object:extend()
Buffer.defaults = {
    buffer_id = 0,
    list_types = {"bullet", "dot", "number", "todo", "done", "reject"},
}

function Buffer:new(args)
    for key, val in pairs(_G.default_args(args, self.defaults)) do
        self[key] = val
    end

    self:set_list_classes()
end

function Buffer:set_list_classes()
    self.list_types = table.concatenate(self.list_types, vim.b.list_types)

    self.list_classes = {}
    for _, list_type in ipairs(self.list_types) do
        local settings = line_type.list_types[list_type]
        local class = line_type.ListLine.get_class(list_type)
        self.list_classes[list_type] = class
    end
end

function Buffer:parse(raw_lines)
    self.lines = {}
    for i, line in ipairs(raw_lines) do
        table.insert(self.lines, self:parse_line(line, i))
    end

    return self.lines
end

function Buffer:parse_line(str, line_number)
    local line

    for _, ListClass in pairs(self.list_classes) do
        line = ListClass.get_if_str_is_a(str, line_number)
        if line then
            return line
        end
    end

    return line_type.Line({text=str, line_number=line_number})
end

--------------------------------------------------------------------------------
-- join_lines
-- ----------
-- Joins two lines.
-- 
-- if the second line is a list item, removes the "list front matter" from it
--------------------------------------------------------------------------------
function Buffer:join_lines()
    local cursor_pos  = vim.api.nvim_win_get_cursor(self.buffer_id)
    local first_line_number = cursor_pos[1] - 1
    local second_line_number = first_line_number + 1

    local lines = line_utils.get({
        buffer = self.buffer_id,
        start_line = first_line_number,
        end_line = second_line_number + 1,
    })

    if vim.tbl_count(lines) ~= 2 then
        return
    end

    local first = self:parse_line(lines[1], first_line_number)
    local second = self:parse_line(lines[2], second_line_number)

    first:merge(second)

    line_utils.set({
        buffer = self.buffer_id,
        start_line = first_line_number,
        end_line = second_line_number + 1,
        replacement = {tostring(first)}
    })
end

function Buffer:map_toggles(lhs_prefix)
    for name, list_class in pairs(self.list_classes) do
        list_class():map_toggle(lhs_prefix)
    end
end

function Buffer:toggle(mode, toggle_line_class_name)
    self.lines = self:parse(line_utils.selection.get({mode = mode}))

    local new_line_class = Buffer:get_new_line_class(self.lines, toggle_line_class_name)

    if new_line_class then
        Buffer.set_selected_lines({mode = mode, lines = self.lines, new_line_class = new_line_class})
    end
end

function Buffer.set_selected_lines(args)
    args = _G.default_args(args, {mode = 'n', lines = {}, new_line_class = nil})

    local new_lines = {}
    for i, line in ipairs(args.lines) do
        line = args.new_line_class({text = line.text, indent = line.indent, line_number = line.line_number})
        table.insert(new_lines, tostring(line))
    end

    return line_utils.selection.set({mode = args.mode, replacement = new_lines})
end

function Buffer.get_min_indent_line(lines)
    local min_indent, min_indent_line = 1000, nil
    for _, line in ipairs(lines) do
        if line.indent:len() < min_indent then
            min_indent = line.indent:len()
            min_indent_line = line
        end
    end

    return min_indent_line
end

function Buffer:get_new_line_class(lines, toggle_line_type_name)
    local min_indent_line = Buffer.get_min_indent_line(lines)

    if min_indent_line then
        if min_indent_line.name == toggle_line_type_name then
            return ListLine.get_class(min_indent_line.toggle.to)
        else
            return ListLine.get_class(toggle_line_type_name)
        end
    end
end

function Buffer:set_highlights()
    for name, item_class in pairs(self.list_classes) do
        item_class():set_highlights()
    end
end

function autolist()
    local chars = {}
    for _, list_type in ipairs(Buffer().list_types) do
        table.insert(chars, line_type.list_types[list_type].sigil)
    end

	local current_line = vim.fn.getline(vim.fn.line("."))
    current_line = current_line:match("%s*(.*)")

	local preceding_line = vim.fn.getline(vim.fn.line(".") - 1)

    if preceding_line:match("^%s*%d+%.%s") then
		local next_list_index = preceding_line:match("%d+") + 1
		vim.fn.setline(".", preceding_line:match("^%s*") .. next_list_index .. ". ")
        vim.api.nvim_input("<esc>A")
    elseif vim.tbl_count(chars) > 0 then
        for _, char in ipairs(chars) do
            local pattern = "^%s*" .. _G.escape(char) .. "%s"
            local matched_content = preceding_line:match(pattern)
            if matched_content then
                vim.fn.setline(".", matched_content .. current_line)
                vim.api.nvim_input("<esc>A")
                return
            end
        end
	end
end

return {
    autolist = autolist,
    Buffer = Buffer,
    continue_list_command = [[<cr><cmd>lua require('list').autolist()<cr>]],
}
