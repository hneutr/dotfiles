require("util")
require("util.tbl")
local Object = require("util.object")
local line_utils = require("util.lines")
local line_type = require("list.line_type")

local list_type_settings = {
    bullet = {
        sigil = '-',
        nohl = true,
    },
    dot = {
        sigil = '*',
        nohl = true,
        map_lhs_suffix = 'o',
    },
    numbered = {
        ListClass = line_type.NumberedListLine,
        map_lhs_suffix = 'n',
    },
    item = {
        sigil = '◻',
        map_lhs_suffix = 'i',
    },
    done = {
        sigil = '✓',
        map_lhs_suffix = 'd',
    },
    rejected = {
        sigil = '⨉',
        map_lhs_suffix = 'x',
    },
    maybe = {
        sigil = '~',
        map_lhs_suffix = 'm',
        regex_sigil = [[\~]],
    },
    question = {
        sigil = '?',
        map_lhs_suffix = 'q',
    },
    tag = {
        sigil = '@',
        map_lhs_suffix = 'a',
    },
}

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
    list_types = {"done"},
}
Buffer.default_list_types = {"bullet", "dot", "numbered"}

function Buffer:new(args)
    for key, val in pairs(_G.default_args(args, self.defaults)) do
        self[key] = val
    end

    self:set_list_classes()
end

function Buffer:set_list_classes()
    self.list_types = table.concatenate(self.default_list_types, self.list_types, vim.b.list_types)

    self.list_classes = {}
    for _, list_type in ipairs(self.list_types) do
        local settings = list_type_settings[list_type]
        local class = vim.tbl_get(settings, 'ListClass') or line_type.get_sigil_line_class(settings.sigil)
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






--------------------------------------------------------------------------------
--                                                                            --
--                                  Parsing                                   --
--                                                                            --
--------------------------------------------------------------------------------
-- function group_items_by_indent(items)
--     table.sort(items, function(a, b) return a.line_number < b.line_number end)
--
--     local last_indent = 0
--     local groups = {}
--     local current_groups = {}
--
--     for i, item in ipairs(items) do
--         if item:str():len() == 0 then
--             for _, group in pairs(current_groups) do
--                 table.insert(groups, group)
--             end
--
--             current_groups = {}
--         else
--             local indent = item.indent:len()
--             if indent < last_indent then
--                 table.insert(groups, current_groups[last_indent])
--                 current_groups[last_indent] = {}
--             end
--
--             if not vim.tbl_get(current_groups, indent) then
--                 current_groups[indent] = {}
--             end
--
--             table.insert(current_groups[indent], item)
--         end
--
--         last_indent = indent
--     end
--
--     for _, group in pairs(current_groups) do
--         table.insert(groups, group)
--     end
--
--     local final_groups = {}
--     for _, group in ipairs(groups) do
--         if vim.tbl_count(group) > 0 then
--             table.insert(final_groups, group)
--         end
--     end
--
--     return final_groups
-- end
--
--------------------------------------------------------------------------------
--                               renumber_list                                --
--------------------------------------------------------------------------------
-- looks within current indent-scope
-- if things are numbered-list like and need to be renumbered:
--      - renumbers them
--------------------------------------------------------------------------------
-- function renumber_list()
    -- get lines between next/previous blank lines
    -- for each scope-group, renumber if necessary:
    --      - find numbered-list like lines
    --      - renumber if necessary
    --
    -- a scope-group is the set of lines at the current indent level between lines of the next-lower
    -- indent level

    -- find the indent-type-index of each line
    -- eg:
    --
    -- ```
    -- 1. a ← indent 0, index 0
    --  - z ← indent 1, index 1
    -- 2. b ← indent 0, index 0
    --  - y ← indent 1, index 2
    --
    -- 1. w ← indent 0, index 1
    -- ```
    -- {
    --      0 = {
    --          {
    --              "1. a" = {
    --                  1 = {
    --                      "- z": {},
    --                  },
    --              },
    --              "2. a" = {
    --                  1 = {
    --                      "- y": {},
    --                  },
    --              }
    --          },
    --          {
    --              "1. w" = {}
    --          }
    --      },
    -- }
    --
    -- line number, indent
    --
    -- record the indent 0 index for the current line, only operate on that one
-- end

function autolist()
    local chars = {}
    for _, list_type in ipairs(Buffer().list_types) do
        table.insert(chars, list_type_settings[list_type].sigil)
    end

	local current_line = vim.fn.getline(vim.fn.line("."))
    current_line = current_line:match("%s*(.*)")

	local preceding_line = vim.fn.getline(vim.fn.line(".") - 1)
    vim.g.testing = preceding_line

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
