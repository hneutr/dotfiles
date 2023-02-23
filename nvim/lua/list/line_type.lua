local Object = require("util.object")
require('util.tbl')

local line_utils = require("util.lines")


local list_type_settings = {
    bullet = {
        sigil = '-',
        nohl = true,
        -- nohl = true,
    },
    dot = {
        sigil = '*',
        map_lhs_suffix = 'o',
        -- regex_sigil = [[\*]],
    },
    numbered = {
        ListClass = NumberedListLine,
        map_lhs_suffix = 'n',
    },
    item = {
        sigil = '◻',
        map_lhs_suffix = 'i',
        -- hl_args = {
        --     sigil = {link = "mkdListItem"},
        --     text = {link = "Normal"},
        -- },
    },
    done = {
        sigil = '✓',
        map_lhs_suffix = 'd',
    },
    rejected = {
        sigil = '⨉',
        map_lhs_suffix = 'x',
        -- hl_args = {
        --     sigil = {link = "Tag"},
        -- },
    },
    maybe = {
        sigil = '~',
        map_lhs_suffix = 'm',
        regex_sigil = [[\~]],
    },
    question = {
        sigil = '?',
        map_lhs_suffix = 'q',
        -- hl_args = {
        --     sigil = {link = "mkdListItem"},
        --     text = {link = "Statement"},
        -- },
    },
    tag = {
        sigil = '@',
        map_lhs_suffix = 'a',
        -- hl_args = {
        --     sigil = {link = "Tag"},
        --     text = {link = "Normal"},
        -- },
    },
}


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
    -- for key, val in pairs(_G.default_args(args, self.defaults)) do
    for key, val in pairs(table.default(args, self.defaults)) do
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
    sigil = '-',
    name = 'bullet',
    highlights = {
        set = true,
        sigil = {
            color = "mkdListItem",
            pattern = [[^\s*STR\s]],
            cmd = [[syn match KEY /PATTERN/ contained]],
            key = nil,
        },
        text = {
            color = 'Normal',
            pattern = [[start="SIGIL_PATTERN\+" end="$"]],
            cmd = [[syn region KEY PATTERN containedin=ALL contains=SIGIL_KEY,mkdLink]],
            key = nil,
        },
    },
    mapping = {
        lhs_suffix = nil,
        rhs = [[:lua require('list.line_type').toggle('MODE', 'NAME')<cr>]],
    },
}


function ListLine:new(args)
    ListLine.super.new(self, args)

    -- self.set_highlighting()
end

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
    local indent, text = str:match(ListLineClass.get_sigil_pattern(ListLineClass.defaults.sigil))
    if indent and text then
        return ListLineClass({text = text, indent = indent, line_number = line_number})
    end
end

function ListLine.get_sigil_class(sigil)
    local SigilClass = ListLine:extend()
    SigilClass.sigil = sigil

    SigilClass.get_if_str_is_a = function(str, line_number)
        return ListLine._get_if_str_is_a(str, line_number, SigilClass)
    end

    return SigilClass
end




----------------------------[ testing highlighting ]----------------------------
function ListLine:set_highlighting()
    if not self.highlights.set then return end
    hl = self.highlights

    -- sigils
    hl.sigil.key = hl.sigil.key or self.name .. "ListLineSigil"

    hl.sigil.pattern = hl.sigil.pattern:gsub("STR", self.sigil_regex or self.sigil)
    hl.sigil.cmd = hl.sigil.cmd:gsub("KEY", hl.sigil.key)
    hl.sigil.cmd = hl.sigil.cmd:gsub("PATTERN", hl.sigil.pattern)

    vim.cmd(hl.sigil.cmd)
    vim.api.nvim_set_hl(0, hl.sigil.key, {link = hl.sigil.color})

    -- sigils
    hl.text.key = hl.text.key or self.name .. "ListLineText"

    hl.text.pattern = hl.text.pattern:gsub("SIGIL_PATTERN", hl.sigil.pattern)
    hl.text.cmd = hl.text.cmd:gsub("KEY", hl.text.key)
    hl.text.cmd = hl.text.cmd:gsub("PATTERN", hl.text.pattern)
    hl.text.cmd = hl.text.cmd:gsub("SIGIL_KEY", hl.sigil.key)

    vim.cmd(hl.text.cmd)
    vim.api.nvim_set_hl(0, hl.text.key, {link = hl.text.color})

    self.highlights = hl
end

--------------------------[ end testing highlighting ]--------------------------

---------------------------[ start testing mappings ]---------------------------

-- function ListLine:map_toggle(lhs_prefix, item_type)
--     local lhs_suffix = vim.tbl_get(Item.types[item_type], 'map_lhs_suffix')

--     if not lhs_suffix then
--         return
--     end

--     local opts = {silent = true, buffer = true}

--     local lhs = lhs_prefix .. lhs_suffix
--     for i, mode in ipairs({'n', 'v'}) do
--         vim.keymap.set(mode, lhs, Item.map_rhs:gsub("MODE", mode):gsub("SIGIL", item_type), buffer)
--     end
-- end

-- function M.lines.set(args)
--     args = _G.default_args(args, {mode = 'n', lines = {}, sigil = nil})

--     local new_lines = {}
--     for i, line in ipairs(args.lines) do
--         if args.sigil then
--             line.sigil = args.sigil
--         end

--         table.insert(new_lines, line:str())
--     end

--     return ulines.selection.set({mode = args.mode, replacement = new_lines})
-- end

-- function M.toggle_sigil(mode, sigil)
--     local lines = M.lines.get(mode)

--     local new_sigil = M.get_new_sigil(lines, sigil)

--     if new_sigil then
--         M.lines.set({mode = mode, lines = lines, sigil = new_sigil})
--     end
-- end

-- function M.get_new_sigil(lines, toggle_sigil)
--     local min_indent_sigil = M.get_min_indent_sigil(lines)

--     if min_indent_sigil then
--         if min_indent_sigil == toggle_sigil then
--             return Item.default_type
--         else
--             return toggle_sigil
--         end
--     end
-- end

-- function M.get_min_indent_sigil(lines)
--     local min_indent, sigil = 1000, nil
--     for i, line in ipairs(lines) do
--         if line.indent < min_indent then
--             min_indent = line.indent
--             sigil = line.sigil
--         end
--     end

--     return sigil
-- end

-- function M.highlight_items()
--     for i, item_type in ipairs(vim.tbl_keys(Item.types)) do
--         Item.highlight(item_type)
--     end
-- end

-- function M.map_item_toggles(lhs_prefix)
--     for i, item_type in ipairs(vim.tbl_keys(Item.types)) do
--         Item.map_toggle(lhs_prefix, item_type)
--     end
-- end

----------------------------[ end testing mappings ]----------------------------



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
--                            get_sigil_line_class                            --
--------------------------------------------------------------------------------
function get_sigil_line_class(sigil)
    local SigilClass = ListLine:extend()
    SigilClass.defaults = table.default({sigil = sigil}, SigilClass.defaults)

    SigilClass.get_if_str_is_a = function(str, line_number)
        return ListLine._get_if_str_is_a(str, line_number, SigilClass)
    end

    return SigilClass
end


return {
    Line = Line,
    ListLine = ListLine,
    NumberedListLine = NumberedListLine,
    get_sigil_line_class = get_sigil_line_class,
}
