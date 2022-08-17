local class = require'util.class'
local ulines = require'util.lines'

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

Item.types = {
    ['-'] = { name = 'default', nohl = true},
    ['✓'] = { name = 'done', map_lhs_suffix = 'd'},
    ['?'] = { name = 'question', map_lhs_suffix = 'q'},
    ['~'] = { name = 'maybe', map_lhs_suffix = 'm', regex_sigil = [[\~]]},
}
Item.default_type = '-'
Item.default_hl_args = {
    sigil = {link = "mkdListItem"},
    text = {link = "Comment"},
}

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
    for i, sigil in ipairs(vim.tbl_keys(Item.types)) do
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
    for i, _sigil in ipairs(vim.tbl_keys(Item.types)) do
        if vim.startswith(content_str, _sigil .. " ") then
            local len = _sigil:len()
            sigil = content_str:sub(1, len)
            text = content_str:sub(len + 2)
            break
        end
    end

    return Item({sigil = sigil, text = text, indent = indent})
end

--------------------------[ syntax and highlighting ]---------------------------
function Item.get_config(item_type)
    local config = Item.types[item_type]
    config.regex_sigil = vim.tbl_get(config, 'regex_sigil') or item_type
    config.hl_args = _G.default_args(vim.tbl_get(config, 'hl_args') or {}, Item.default_hl_args)
    config.hl_keys = {
        sigil = config.name .. "ItemSigil",
        text = config.name .. "ItemText",
    }

    return config
end

Item.syntax = {
    regex = [[^\s*STR\s]],
    sigil_cmd = [[syn match SIGIL /REGEX/ contained]],
    text_cmd = [[syn region TEXT start="REGEX\+" end="$" containedin=ALL contains=SIGIL,mkdLink]],
}

function Item.highlight(item_type)
    local config = Item.get_config(item_type)
    if config.nohl then
        return
    end

    local sigil_hl_key = config.hl_keys.sigil
    local text_hl_key = config.hl_keys.text

    local regex = Item.syntax.regex:gsub("STR", config.regex_sigil)

    vim.cmd(Item.syntax.sigil_cmd:gsub('SIGIL', sigil_hl_key):gsub('REGEX', regex))
    vim.cmd(Item.syntax.text_cmd:gsub('TEXT', text_hl_key):gsub('REGEX', regex):gsub('SIGIL', sigil_hl_key))

    vim.api.nvim_set_hl(0, sigil_hl_key, config.hl_args.sigil)
    vim.api.nvim_set_hl(0, text_hl_key, config.hl_args.text)
end

----------------------------------[ mapping ]-----------------------------------
Item.map_rhs = [[:lua require'lex.list'.toggle_sigil('MODE', 'SIGIL')<cr>]]

function Item.map_toggle(lhs_prefix, item_type)
    local lhs_suffix = vim.tbl_get(Item.types[item_type], 'map_lhs_suffix')

    if not lhs_suffix then
        return
    end

    local opts = {silent = true, buffer = true}

    local lhs = lhs_prefix .. lhs_suffix
    for i, mode in ipairs({'n', 'v'}) do
        vim.keymap.set(mode, lhs, Item.map_rhs:gsub("MODE", mode):gsub("SIGIL", item_type), buffer)
    end
end


--------------------------[ syntax and highlighting ]---------------------------

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
    for i, raw_line in ipairs(ulines.selection.get{ mode = mode }) do
        if M.Item.str_is_a(raw_line) then
            line = Item.from_str(raw_line)
        else
            line = NonItem.from_str(raw_line)
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

    return ulines.selection.set{ mode = args.mode, replacement = new_lines}
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
            return Item.default_type
        else
            return toggle_sigil
        end
    end
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

function M.highlight_items()
    for i, item_type in ipairs(vim.tbl_keys(Item.types)) do
        Item.highlight(item_type)
    end
end

function M.map_item_toggles(lhs_prefix)
    for i, item_type in ipairs(vim.tbl_keys(Item.types)) do
        Item.map_toggle(lhs_prefix, item_type)
    end

    vim.b.autolist_chars = vim.tbl_keys(Item.types)
    vim.cmd("iunmap <cr>")
    vim.keymap.set("i", "<cr>", [[<cr><cmd>lua require'util.list'.autolist()<cr>]], {buffer = true})
    vim.keymap.set("n", "o", [[o<cmd>lua require'util.list'.autolist()<cr>]], {buffer = true})
end

return M
