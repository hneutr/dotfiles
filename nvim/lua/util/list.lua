local Object = require("util.object")
local line_utils = require("util.lines")

local M = {}

function M.autolist()
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

--------------------------------------------------------------------------------
--                                  ListItem                                  --
--------------------------------------------------------------------------------
ListItem = Object:extend()

ListItem.pattern = "^(%s*)%-%s(.*)$"

function ListItem:new(args)
    self = vim.tbl_extend("force", self, {text = '', indent = '', line_number = 0}, args)
end

function ListItem:str()
    return self.indent .. self:sigil_str() .. self.text
end

function ListItem:write()
    line_utils.set({start_line = self.line_number, replacement = {self:str()}})
end

function ListItem:sigil_str()
    return "- "
end

function ListItem.get_if_str_is_a(str, line_number)
    local indent, text = str:match(ListItem.pattern)
    if indent and text then
        return ListItem({text = text, indent = indent, line_number = line_number})
    end
end

--------------------------------------------------------------------------------
--                              NumberedListItem                              --
--------------------------------------------------------------------------------
NumberedListItem = ListItem:extend()

NumberedListItem.pattern = "^(%s*)(%d+)%.%s(.*)$"

function NumberedListItem:sigil_str()
    return self.number .. ". "
end

function NumberedListItem.get_if_str_is_a(str, line_number)
    local indent, number, text = str:match(NumberedListItem.pattern)
    if indent and number and text then
        return NumberedListItem({number = number, text = text, indent = indent, line_number = line_number})
    end
end

--------------------------------------------------------------------------------
--                               renumber_list                                --
--------------------------------------------------------------------------------
-- looks within current indent-scope
-- if things are numbered-list like and need to be renumbered:
--      - renumbers them
--------------------------------------------------------------------------------
function M.renumber_list()
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
    local lines = require('util.lines').get()
    for i, line in ipairs(lines) do
    end
end

-- function get_indent_groups_by_scope()
--     local indent_level_group_counters = {}
--
--     local lines = require('util.lines').get()
--     for i, line in ipairs(lines) do
--     end
--
-- end

return M
