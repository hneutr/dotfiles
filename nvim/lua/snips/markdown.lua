local Object = require("util.object")

local color = require('color')
local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local size_info = {
    big = {
        header = { content_start = '#' },
        divider = {
            width = 80,
            start_string = '#',
            color = 'orange',
        }
    },
    medium = {
        header = { content_start = '=' },
        divider = {
            width = 60,
            start_string = '=',
            color = 'yellow',
        },
    },
    small = {
        header = { content_start = '>' },
        divider = {
            width = 40,
            color = 'blue',
        },
    },
}

local width_to_size = {
    [40] = 'small',
    [60] = 'medium',
    [80] = 'big',
}


local function get_today() return vim.fn.strftime("%Y%m%d %X") end

--------------------------------------------------------------------------------
--                                TextOrInput                                 --
--------------------------------------------------------------------------------
local TextOrInput = Object:extend()
function TextOrInput:new(args)
    args = _G.default_args(args, {inner=''})
    self.inner = args.inner
    self.inner_type = type(self.inner)
    self.has_input = self.inner_type == 'string' and self.inner:len() == 0

    if self.inner_type == 'string' then
        self.inner_value = self.inner
    elseif self.inner_type == 'function' then
        self.inner_value = self.inner()
    else
        self.inner_value = ''
    end
end

function TextOrInput:snippet(args)
    args = _G.default_args(args, {pre={''}, post={''}})

    local pre = vim.list_extend({}, args.pre)
    local post = vim.list_extend({}, args.post)

    pre[#pre] = pre[#pre] .. (self.pre_text or '')
    post[1] = (self.post_text or '') .. post[1]

    if self.has_input then
        return {t(pre), i(1), t(post)}
    else
        if self.inner_type == 'string' then
            local content = pre
            content[#content] = content[#content] .. self.inner .. table.removekey(post, 1)
            content = vim.list_extend(content, post)
            return t(content)
        elseif self.inner_type == 'function' then
            return {t(pre), f(self.inner), t(post)}
        end
    end
end

function TextOrInput:str(args)
    args = _G.default_args(args, {pre={''}, post={''}})

    local content = {self.inner_value}

    if type(args.pre) == "string" then
        content[#content] = args.pre .. content[#content]
    else
        pre = vim.list_extend({}, args.pre)
        content = vim.list_extend(pre, content)
    end

    if type(args.post) == "string" then
        content[#content] = content[#content] .. args.post
    else
        content = vim.list_extend(content, args.post)
    end

    if #content == 1 then
        return content[1]
    else
        return content
    end
end


--------------------------------------------------------------------------------
--                                   links                                    --
--------------------------------------------------------------------------------
local Link = TextOrInput:extend()
Link.pre_text = "["
Link.post_text = "]()"

function Link:str(args)
    args = _G.default_args(args, {pre='', post=''})
    return args.pre .. self.pre_text .. self.inner_value .. self.post_text .. args.post
end

--------------------------------------------------------------------------------
--                                  dividers                                  --
--------------------------------------------------------------------------------
local Divider = Object:extend()
Divider.defaults = {
    width = 40,
    fill_char = '-',
    start_string = '',
    color = 'blue',
}
Divider.highlight_cmd = [[syn region KEY start="^\s*DIVIDER$" end="$" containedin=ALL]]

function Divider:new(args)
    args = _G.default_args(args, Divider.defaults)
    for k, v in pairs(args) do
        self[k] = v
    end

    self.size = width_to_size[self.width]
    self.highlight_key = self.size .. "Line"
end

function Divider.from_size(size) return Divider(size_info[size].divider) end


function Divider:snippet() return {t({self:str(), ""})} end
function Divider:str()
    local str = self.start_string
    return str .. string.rep(self.fill_char, self.width - (str:len()))
end

function Divider:set_highlight()
    cmd = self.highlight_cmd:gsub("KEY", self.highlight_key)
    cmd = cmd:gsub("DIVIDER", self:str())
    vim.cmd(cmd)

    color.set_highlight({name = self.highlight_key, val = {fg = self.color}})
end

function Divider.set_highlights()
    for size, _ in pairs(size_info) do
        Divider.from_size(size):set_highlight()
    end
end

--------------------------------------------------------------------------------
--                                  headers                                   --
--------------------------------------------------------------------------------
local Header = Object:extend()
Header.defaults = {
    inner = '',
    content_start = '>',
    divider_args = size_info['small'],
}
Header.highlight_cmd = [[syn match KEY /^CONTENT_START\s/ contained]]

function Header:new(args)
    args = _G.default_args(args, Header.defaults)

    self.divider = Divider(args.divider_args)

    for k, v in pairs(args) do
        self[k] = v
    end

    self.inner_type = type(self.inner)
    self.has_input = self.inner_type == 'string' and self.inner:len() == 0

    if self.inner_type == 'string' then
        self.inner_value = self.inner
    elseif self.inner_type == 'function' then
        self.inner_value = self.inner()
    else
        self.inner_value = ''
    end

    self.highlight_key = self.divider.size .. "HeaderStart" 
end

function Header.from_size(args)
    args = _G.default_args(args, {size = 'small', inner = ''})
    return Header(_G.default_args(size_info[args.size].header, {
        inner = args.inner,
        divider_args = size_info[args.size].divider,
    }))
end

function Header:str()
    local content = self.content_start

    if self.inner_value:len() > 0 then
        content = content .. " " .. self.inner_value
    end

    lines = {
        self.divider:str(),
        content,
        self.divider:str(),
        "",
    }

    return lines
end

function Header:snippet()
    if self.inner_value:len() > 0 then
        return {t(self:str())}
    else
        return {
            t({
                self.divider:str(),
                self.content_start .. " ",
            }),
            i(1),
            t({
                "",
                self.divider:str(),
            }),
        }
    end
end

function Header:set_highlight()
    cmd = self.highlight_cmd:gsub("KEY", self.highlight_key)
    cmd = cmd:gsub("CONTENT_START", self.content_start)
    vim.pretty_print(cmd)
    vim.cmd(cmd)

    color.set_highlight({name = self.highlight_key, val = {fg = self.divider.color}})
end

function Header.set_highlights()
    for size, _ in pairs(size_info) do
        Header.from_size({size = size}):set_highlight()
    end
end


--------------------------------------------------------------------------------
--                                LinkHeaders                                 --
--------------------------------------------------------------------------------
local LinkHeader = Header:extend()
function LinkHeader:str()
    return {
        self.divider:str(),
        Link({inner=self.inner}):str({pre=self.content_start .. " "}),
        self.divider:str(),
    }
end

function LinkHeader:snippet()
    local pre = {
        self.divider:str(),
        self.content_start .. " ",
    }

    local post = {
        "",
        self.divider:str(),
    }

    if self.inner_value:len() > 0 then
        table.insert(post, "")
    end

    return Link({inner=self.inner}):snippet({pre=pre, post=post})
end

function LinkHeader.from_size(args)
    args = _G.default_args(args, {size = 'small', inner = ''})
    return LinkHeader(_G.default_args(size_info[args.size].header, {
        inner = args.inner,
        divider_args = size_info[args.size].divider,
    }))
end

--------------------------------------------------------------------------------
--                                  Journal                                   --
--------------------------------------------------------------------------------
local Journal = Object:extend()

function Journal:new(args)
    self.divider = Divider({size='big'})
end

function Journal:snippet()
    return {
        t("["), f(get_today), t({"]():", "", ""}),
        i(1),
        t{"", "", self.divider:str(), ""}
    }
end

function Journal:str()
    return {
        t({
            "[", get_today(), "]():", "",
            "",
            "",
            "",
            "",
            self.divider:str(),
            "",
        }),
    }
end

--------------------------------------------------------------------------------
--                                 access                                     --
--------------------------------------------------------------------------------
return {
    Link = Link,
    Divider = Divider,
    Header = Header,
    LinkHeader = LinkHeader,
    Journal = Journal,
}
