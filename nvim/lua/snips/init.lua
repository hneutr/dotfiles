local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local ps = ls.parser.parse_snippet

local M = {}

M.opts = {
    fill = '-',
    width = 80,
}

local function f(fn, input_index)
    input_index = input_index or 1
    return ls.function_node(function(args) return fn(#args[1][input_index]) end, {input_index})
end

--------------------------------------------------------------------------------
--                                                                            --
--                                                                            --
--                                     h1                                     --
--                                                                            --
--                                                                            --
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--                                                                            --
--                                     h2                                     --
--                                                                            --
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--                                     h3                                     --
--------------------------------------------------------------------------------

-------------------------------------[ h4 ]-------------------------------------

--------------------------------------------------------------------------------
-- fnb (function block)
-- --------------------
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--                                   Header                                   --
--------------------------------------------------------------------------------
local Header = class()
Header.before = {}
Header.beside = {}

function Header:_init(comment)
    self:set(comment)

    local parts = List({
        f(self:side_fill('left')),
        i(1),
        f(self:side_fill('right')),
    })

    if #self.before > 0 then
        local before = List(self.before):map(function(key) return self[key] end):append("")
        parts:put(t(before))
        parts:append(t(List(before):clone():reverse()))
    end

    return parts
end

function Header:set(comment)
    self.width = M.opts.width
    self.fill = M.opts.fill

    self.comment = comment
    self.divider = comment .. self.fill:rep(self.width - (2 * #comment)) .. comment
    self.spacer = comment .. (' '):rep(self.width - (2 * #comment)) .. comment
    self.field = comment .. " "
end

function Header:side_fill(side)
    local s = self

    return function(len)
        local after = s.beside[side] or ""
        local before = s.comment
        local rounder = math.ceil

        if side == 'right' then
            rounder = math.floor
            after, before = before, after
        end

        local width = rounder((s.width - len) / 2) - #before - #after
        width = math.max(0, width)

        return before .. (s.beside.fill or " "):rep(width) .. after
    end
end

-------------------------------------[ H1 ]-------------------------------------
local H1 = class(Header)
H1.before = {"divider", "spacer", "spacer"}

-------------------------------------[ H2 ]-------------------------------------
local H2 = class(Header)
H2.before = {"divider", "spacer"}

-------------------------------------[ H3 ]-------------------------------------
local H3 = class(Header)
H3.before = {"divider"}

-------------------------------------[ H4 ]-------------------------------------
local H4 = class(Header)
H4.beside = {left = '[ ', right = ' ]', fill = '-'}

--------------------------------------------------------------------------------
--                                  Function                                  --
--------------------------------------------------------------------------------
local FunctionBlock = class(Header)

function FunctionBlock:_init(comment)
    self:set(comment)
    return {
        t({self.divider, self.field}),
        i(1),
        t({"", self.field}),
        f(function(len) return self.fill:rep(len) end),
        t({"", self.field, self.divider}),
    }
end

-----------------------------------[ Print ]------------------------------------
local function print_snippet(str, add_quotes)
    return string.format(str or 'print(%s)', add_quotes and '"$1"' or "$1")
end

----------------------------------[ BigLine ]-----------------------------------
local function big_line_snippet(str)
    return str:rpad(M.opts.width, M.opts.fill) .. "\n$1"
end

---------------------------------[ SmallLine ]----------------------------------
local function small_line_snippet(str)
    return str:rpad(M.opts.width / 2, M.opts.fill) .. "\n$1"
end

--------------------------------------------------------------------------------
--                                                                            --
--                                                                            --
--                                   Loader                                   --
--                                                                            --
--                                                                            --
--------------------------------------------------------------------------------
local FTLoader = {}

function FTLoader.key(filetype)
    return string.format("ls_%s_snips_loaded", filetype)
end

function FTLoader.is_loaded(filetype)
    return vim.g[FTLoader.key(filetype)] == true
end

function FTLoader.set_loaded(filetype)
    vim.g[FTLoader.key(filetype)] = true
end

function FTLoader.load(filetype)
    if FTLoader.is_loaded(filetype) then
        return
    end

    local snips = List()

    pcall(function() snips:extend(require(string.format("snips.%s", filetype))) end)

    if filetype ~= 'all' then
        local comment = vim.bo.commentstring:gsub("%s?%%s$", '')
        local ft_strings = vim.tbl_get(vim.g.snip_ft_strings, filetype) or {}

        snips:extend({
            s("h1", H1(comment)),
            s("h2", H2(comment)),
            s("h3", H3(comment)),
            s("h4", H4(comment)),
            s("fnb", FunctionBlock(comment)),
            ps("bl", big_line_snippet(comment)),
            ps("l", small_line_snippet(comment)),
            ps("p", print_snippet(ft_strings.print)),
            ps("qp", print_snippet(ft_strings.print, true)),
        })
    end

    ls.add_snippets(filetype, snips)

    FTLoader.set_loaded(filetype)
end

return function()
    FTLoader.load('all')
    FTLoader.load(vim.bo.filetype)
end
