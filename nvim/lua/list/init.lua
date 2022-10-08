local Object = require("util.object")
local line_utils = require("util.lines")

local list_item_types = {
    default = {
        ListLineClass = ListLine,
        nohl = true,
    },
    done = {
        ListLineClass = ListLine.get_list_line_class_with_sigil('✓'),
        map_lhs_suffix = 'd',
    },
    question = {
        ListLineClass = ListLine.get_list_line_class_with_sigil('?'),
        map_lhs_suffix = 'q',
    },
    maybe = {
        ListLineClass = ListLine.get_list_line_class_with_sigil('~'),
        map_lhs_suffix = 'm',
        regex_sigil = [[\~]],
    },
}

function autolist()
    chars = vim.b.autolist_chars or {}

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
--                                      
--------------------------------------------------------------------------------
--                                                                            --
--                                    Line                                    --
--                                                                            --
--------------------------------------------------------------------------------
Line = Object:extend()
Line.defaults = {
    text = '',
    line_number = 0,
}

function Line:new(args)
    for key, val in pairs(_G.default_args(args, self.defaults)) do
        self[key] = val
    end
end

function Line:write()
    line_utils.set({start_line = self.line_number, replacement = {tostring(self)}})
end

function Line:__tostring() return self.text end

function Line:merge(other)
    self.text = _G.rstrip(self.text) .. " " .. _G.lstrip(other.text)
end

function Line.get_if_str_is_a(str, line_number)
    return Line({text = str, line_number = line_number})
end

--------------------------------------------------------------------------------
--                                  ListLine                                  --
--------------------------------------------------------------------------------
ListLine = Line:extend()
ListLine.defaults = {
    text = '',
    indent = '',
    line_number = 0,
}
ListLine.sigil = '-'

function ListLine:__tostring()
    return self.indent .. self.sigil .. " " .. self.text
end

function ListLine.get_sigil_pattern(sigil)
    return "^(%s*)" .. _G.escape(sigil) .. "%s(.*)$"
end

function ListLine.get_if_str_is_a(str, line_number)
    return ListLine._get_if_str_is_a(str, line_number, ListLine)
end

function ListLine._get_if_str_is_a(str, line_number, ListLineClass)
    local indent, text = str:match(ListLineClass.get_sigil_pattern(ListLineClass.sigil))
    if indent and text then
        return ListLineClass({text = text, indent = indent, line_number = line_number})
    end
end

function ListLine.get_list_line_class_with_sigil(sigil)
    local ListLineClass = ListLine:extend()
    ListLineClass.sigil = sigil

    ListLineClass.get_if_str_is_a = function(str, line_number)
        return ListLine._get_if_str_is_a(str, line_number, ListLineClass)
    end

    return ListLineClass
end

--------------------------------------------------------------------------------
--                              NumberedListLine                              --
--------------------------------------------------------------------------------
NumberedListLine = Line:extend()
NumberedListLine.defaults = {
    text = '',
    indent = '',
    line_number = 0,
    number = 1,
}
NumberedListLine.pattern = "^(%s*)(%d+)%.%s(.*)$"

function NumberedListLine:__tostring()
    return self.indent .. self.number .. '. ' .. self.text
end

function NumberedListLine.get_if_str_is_a(str, line_number)
    local indent, number, text = str:match(NumberedListLine.pattern)
    if indent and number and text then
        return NumberedListLine({
            number = tonumber(number),
            text = text,
            indent = indent,
            line_number = line_number,
        })
    end
end

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
    list_line_types = {
        ListLine,
        NumberedListLine,
    },
}

function Buffer:new(args)
    for key, val in pairs(_G.default_args(args, self.defaults)) do
        self[key] = val
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
    for i, ListLineClass in ipairs(self.list_line_types) do
        line = ListLineClass.get_if_str_is_a(str, line_number)
        if line then
            return line
        end
    end

    return Line({text=str, line_number=line_number})
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

return {
    autolist = autolist,
    Line = Line,
    ListLine = ListLine,
    NumberedListLine = NumberedListLine,
    Buffer = Buffer,
}
