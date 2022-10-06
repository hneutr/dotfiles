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

local Object = require("util.object")

local ls = require("luasnip")
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local WIDTH = 80
local WIDTH_SMALL = 40
local DIVIDER_FILL_CHAR = '-'
local INPUT_FILL_CHAR = ' '
local COMMENT = '-'

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
    args = _G.default_args(args, Block.arg_defaults)
    for k, v in pairs(args) do
        self[k] = v
    end
end

function Block:divider()
    local str = self.comment
    str = str .. string.rep(self.divider_fill_char, self.width - (2 * str:len()))
    str = str .. self.comment
    return str
end

function Block:spacer()
    local str = self.comment
    str = str .. string.rep(' ', self.width - (2 * str:len()))
    str = str .. self.comment
    return str
end

function Block:set_text(text)
    self.text = text or ''
end

function Block:snippet()
    return {
        t{self:divider(), self.comment .. " "},
        i(1),
        t{"", self:divider()},
    }
end

--------------------------------------------------------------------------------
--                                  Function                                  --
--------------------------------------------------------------------------------
local FunctionBlock = Block:extend()

function FunctionBlock:underline()
    return string.rep(self.divider_fill_char, self.text:len())
end

function FunctionBlock.fill_underline(args, _, user_args)
    local text = args[1][1]
    local obj = user_args[1]
    obj:set_text(text)
    return obj:underline()
end

function FunctionBlock:snippet()
    return {
        t({self:divider(), self.comment .. " "}),
        i(1),
        t({"", self.comment .. " "}),
        f(FunctionBlock.fill_underline, {1}, {user_args = {{self}}}),
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
    Header.super.set_text(self, text)

    self.to_fill = {total = self.width - self.text:len()}
    self.to_fill.left = math.max(math.floor(self.to_fill.total / 2), self.comment:len())
    self.to_fill.right = math.max(self.to_fill.total - self.to_fill.left, self.comment:len())
end

function Header:side_fill(side)
    local str = self.comment
    str = str .. string.rep(self.input_fill_char, self.to_fill[side] - str:len())

    if side == 'right' then
        str = str:reverse()
    end

    return str
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
H4.beside_text = { left = '[ ', right = ' ]'}

function H4:side_fill(side)
    local beside_text = H4.beside_text[side]
    local to_fill = self.to_fill[side] - self.comment:len() - beside_text:len()

    local str = self.comment .. string.rep(self.divider_fill_char, to_fill)

    if side == 'right' then
        str = beside_text .. str:reverse()
    else
        str = str .. beside_text
    end

    return str
end

-----------------------------------[ Print ]------------------------------------
local Print = Object:extend()

function Print:new(print_string)
    self.print_string = print_string or 'print(%s)'
    self.open, self.close = self.print_string:match("^(.*)%%s(.*)$")
end

function Print:snippet(add_quotes)
    local open = self.open
    local close = self.close

    if add_quotes then
        open = open .. '"'
        close = '"' .. close
    end

    return {t(open), i(1), t(close)}
end

----------------------------------[ BigLine ]-----------------------------------
local BigLine = Block:extend()

function BigLine:divider()
    local str = self.comment
    str = str .. string.rep(self.divider_fill_char, self.width - (str:len()))
    return str
end


function BigLine:snippet()
    return {
        t{self:divider(), ""},
        i(1),
    }
end

---------------------------------[ SmallLine ]----------------------------------
local SmallLine = BigLine:extend()

function SmallLine:new(args)
    SmallLine.super.new(self, args)
    self.width = WIDTH_SMALL
end


return {
    Block = Block,
    H1 = H1,
    H2 = H2,
    H3 = H3,
    H4 = H4,
    FunctionBlock = FunctionBlock,
    Print = Print,
    BigLine = BigLine,
    SmallLine = SmallLine,
}
