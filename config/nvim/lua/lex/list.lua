require'util'
require'class'

line_utils = require'lines'

local M = {}

--------------------------------------------------------------------------------
-- Item
--------------------------------------------------------------------------------
Item = class(function(self, args)
    args = _G.default_args(args, { sigil = '-', text = '', indent = 0 })
    self.sigil = args.sigil
    self.text = args.text
    self.indent = args.indent
end)

Item.sigils = {'-', '✓', '?', '~'}

function Item:str()
    local str = string.rep(" ", self.indent)

    if self.sigil:len() then
        str = str .. self.sigil .. " "
    end

    return str .. self.text
end

Item.indent_pattern = "^(%s*)(.*)$"

function Item.str_is_a(str)
    local indent_str, content_str = str:match(Item.indent_pattern)
    for i, sigil in ipairs(Item.sigils) do
        if vim.startswith(content_str, sigil .. " ") then
            return true
        end
    end

    return false
end

function Item.from_str(str)
    local indent_str, content_str = str:match(Item.indent_pattern)
    local indent = indent_str:len()

    local sigil, text
    for i, _sigil in ipairs(Item.sigils) do
        if vim.startswith(content_str, _sigil .. " ") then
            local len = _sigil:len()
            sigil = content_str:sub(1, len)
            text = content_str:sub(len + 2)
            break
        end
    end

    return Item({sigil = sigil, text = text, indent = indent})
end

M.Item = Item

--------------------------------------------------------------------------------
-- NonItem
--------------------------------------------------------------------------------
NonItem = class(Item, function(self, args)
    Item.init(self, args)

    self.sigil = ''
    self.indent = 1000
end)

function NonItem:str()
    return self.text
end

function NonItem.from_str(str)
    return NonItem{ text = str }
end

M.NonItem = NonItem

--------------------------------------------------------------------------------
-- Lines
--------------------------------------------------------------------------------

M.lines = {}
function M.lines.get(mode)
    local lines = {}
    for i, raw_line in ipairs(line_utils.selection.get{ mode = mode }) do
        if M.Item.str_is_a(raw_line) then
            line = M.Item.from_str(raw_line)
        else
            line = M.NonItem.from_str(raw_line)
        end

        table.insert(lines, line)
    end

    return lines
end

function M.lines.set(args)
    args = _G.default_args(args, { mode = 'n', lines = {}, sigil = nil })

    local new_lines = {}
    for i, line in ipairs(args.lines) do
        if args.sigil then
            line.sigil = args.sigil
        end

        table.insert(new_lines, line:str())
    end

    return line_utils.selection.set{ mode = args.mode, replacement = new_lines}
end

function M.toggle_sigil(mode, sigil)
    local lines = M.lines.get(mode)

    local new_sigil = M.get_new_sigil(lines, sigil)

    if new_sigil then
        M.lines.set{ mode = mode, lines = lines, sigil = new_sigil }
    end
end

function M.get_new_sigil(lines, toggle_sigil)
    local min_indent_sigil = M.get_min_indent_sigil(lines)

    if min_indent_sigil then
        if min_indent_sigil == toggle_sigil then
            return M.Item.sigils[1]
        else
            return toggle_sigil
        end
    end

    return
end

function M.get_min_indent_sigil(lines)
    local min_indent, sigil = 1000, nil
    for i, line in ipairs(lines) do
        if line.indent < min_indent then
            min_indent = line.indent
            sigil = line.sigil
        end
    end

    return sigil
end

return M
