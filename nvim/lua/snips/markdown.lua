local Object = require("util.object")

local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local size_to_info = {
    big = {
        width = 80,
        header = {
            divider_start = '#',
            content_start = '#',
        },
    },
    medium = {
        width = 60,
        header = {
            divider_start = '=',
            content_start = '=',
        },
    },
    small = {
        width = 40,
        header = {
            content_start = '>',
        },
    },
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
            content[#content] = content[#content] .. self.inner .. table.remove(post, 1)
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

function Divider:new(args)
    args = _G.default_args(args, {size='small', as_header=false, fill_char='-', start_string=''})
    for k, v in pairs(args) do
        self[k] = v
    end

    self.size_info = size_to_info[args.size]

    self.width = self.size_info.width

    if self.as_header then
        self.start_string = self.size_info.header.divider_start or ''
    end
end

function Divider:snippet() return {t({self:str(), ""})} end
function Divider:str()
    local str = self.start_string
    return str .. string.rep(self.fill_char, self.width - (str:len()))
end

--------------------------------------------------------------------------------
--                                  headers                                   --
--------------------------------------------------------------------------------
local Header = Object:extend()
function Header:new(args)
    args = _G.default_args(args, {size='small', inner=''})
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

    self.size_info = size_to_info[args.size]
    self.divider = Divider({size=args.size, as_header=true})
end

function Header:str()
    local content = self.size_info.header.content_start or ''

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
                self.size_info.header.content_start .. " ",
            }),
            i(1),
            t({
                "",
                self.divider:str(),
            }),
        }
    end
end

--------------------------------------------------------------------------------
--                                LinkHeaders                                 --
--------------------------------------------------------------------------------
local LinkHeader = Header:extend()
function LinkHeader:str()
    return {
        self.divider:str(),
        Link({inner=self.inner}):str({pre=self.size_info.header.content_start .. " "}),
        self.divider:str(),
    }
end

function LinkHeader:snippet()
    local pre = {
        self.divider:str(),
        self.size_info.header.content_start .. " ",
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
