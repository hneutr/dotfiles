local Object = require("util.object")

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local ps = ls.parser.parse_snippet

local M = {}

M.opts = {
    fill = '-',
}

local WIDTH = 80
local WIDTH_SMALL = 40
local DIVIDER_FILL_CHAR = '-'
local INPUT_FILL_CHAR = ' '
local COMMENT = '-'

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
--                                   Block                                    --
--------------------------------------------------------------------------------
local Block = Object:extend()
Block.arg_defaults = {
    comment = COMMENT,
    divider_fill_char = DIVIDER_FILL_CHAR,
    input_fill_char = INPUT_FILL_CHAR,
    width = WIDTH,
}

function Block:new(args)
    args = vim.tbl_extend("keep", {}, args or {}, Block.arg_defaults)

    for k, v in pairs(args) do
        self[k] = v
    end
end

function Block:divider()
    local str = self.comment
    str = str .. self.divider_fill_char:rep(self.width - (2 * #str))
    str = str .. self.comment
    return str
end

function Block:spacer()
    local str = self.comment
    str = str .. string.rep(' ', self.width - (2 * #str))
    str = str .. self.comment
    return str
end

function Block:set_text(text)
    self.text = text or ''
end

--------------------------------------------------------------------------------
--                                  Function                                  --
--------------------------------------------------------------------------------
local FunctionBlock = Block:extend()

function FunctionBlock.underline(args, _, user_args)
    local text = args[1][1]
    local obj = user_args[1]
    return obj.divider_fill_char:rep(#text)
end

function FunctionBlock:snippet()
    return {
        t({self:divider(), self.comment .. " "}),
        i(1),
        t({"", self.comment .. " "}),
        f(FunctionBlock.underline, {1}, {user_args = {{self}}}),
        t({"", self.comment .. " ", self:divider()}),
    }
end

--------------------------------------------------------------------------------
--                                   Header                                   --
--------------------------------------------------------------------------------
local Header = Block:extend()

function Header:before() return {} end
function Header:after()
    local before = self:before()

    local after = {}
    for i = #before, 1, -1 do
        table.insert(after, before[i])
    end

    return after
end

function Header:set_text(text)
    local total = self.width - #text
    self.to_fill = {}
    self.to_fill.left = math.max(math.floor(total / 2), #self.comment)
    self.to_fill.right = math.max(total - self.to_fill.left, #self.comment)
end

function Header:side_fill(side)
    local pad_fn = side == 'right' and string.lpad or string.rpad
    return pad_fn(self.comment, self.to_fill[side], self.input_fill_char)
end

function Header.side_fill_fn(args, _, user_args)
    local text = args[1][1]
    local obj, side = unpack(user_args)
    obj:set_text(text)
    return obj:side_fill(side)
end

function Header:get_text_snip(text)
    if text then
        return t(text)
    end
end

function Header:snippet()
    return {
        self:get_text_snip(self:before()),
        f(Header.side_fill_fn, {1}, {user_args = {{self, 'left'}}}),
        i(1),
        f(Header.side_fill_fn, {1}, {user_args = {{self, 'right'}}}),
        self:get_text_snip(self:after()),
    }
end

-------------------------------------[ H1 ]-------------------------------------
H1 = Header:extend()
function H1:before() return {self:divider(), self:spacer(), self:spacer(), ""} end

-------------------------------------[ H2 ]-------------------------------------
H2 = Header:extend()
function H2:before() return {self:divider(), self:spacer(), ""} end

-------------------------------------[ H3 ]-------------------------------------
H3 = Header:extend()
function H3:before() return {self:divider(), ""} end

-------------------------------------[ H4 ]-------------------------------------
H4 = Header:extend()
H4.beside_text = {left = '[ ', right = ' ]'}

function H4:side_fill(side)
    local beside_text = H4.beside_text[side]
    local to_fill = self.to_fill[side] - #self.comment - #beside_text

    local str = self.comment .. self.divider_fill_char:rep(to_fill)

    if side == 'right' then
        str = beside_text .. str:reverse()
    else
        str = str .. beside_text
    end

    return str
end

-----------------------------------[ Print ]------------------------------------
local function print_snippet(str, add_quotes)
    return string.format(str or 'print(%s)', add_quotes and '"$1"' or "$1")
end

----------------------------------[ BigLine ]-----------------------------------
local function big_line_snippet(str)
    return str:rpad(WIDTH, M.opts.fill) .. "\n$1"
end

---------------------------------[ SmallLine ]----------------------------------
local function small_line_snippet(str)
    return str:rpad(WIDTH_SMALL, M.opts.fill) .. "\n$1"
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

    local ft_strings = vim.tbl_get(vim.g.snip_ft_strings, filetype) or {}
    local comment_str = vim.bo.commentstring:gsub("%s?%%s$", '')

    local snips = List()

    pcall(function() snips:extend(require(string.format("snips.%s", filetype))) end)

    if filetype ~= 'all' then
        snips:extend({
            s("h1", H1({comment = comment_str}):snippet()),
            s("h2", H2({comment = comment_str}):snippet()),
            s("h3", H3({comment = comment_str}):snippet()),
            s("h4", H4({comment = comment_str}):snippet()),
            s("fnb", FunctionBlock({comment = comment_str}):snippet()),

            ps("bl", big_line_snippet(comment_str)),
            ps("l", small_line_snippet(comment_str)),
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
