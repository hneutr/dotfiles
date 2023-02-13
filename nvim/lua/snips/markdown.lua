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

--------------------------------------------------------------------------------
--                                TextOrInput                                 --
--------------------------------------------------------------------------------
local TextOrInput = Object:extend()
function TextOrInput:new(args)
    args = _G.default_args(args, {text=''})
    self.text = args.text
    self.has_input = self.text:len() == 0
end

function TextOrInput:snippet(args)
    args = _G.default_args(args, {pre={''}, post={''}})

    local pre = vim.list_extend({}, args.pre)
    local post = vim.list_extend({}, args.post)

    pre[#pre] = pre[#pre] .. (self.pre_text or '')
    post[1] = (self.post_text or '') .. post[1]

    if self.has_input then
        table.insert(post, "")
        return {t(pre), i(1), t(post)}
    else
        local content = pre
        content[#content] = content[#content] .. self.text .. table.remove(post, 1)
        content = vim.list_extend(content, post)
        return t(content)
    end
end

function TextOrInput:str(args)
    args = _G.default_args(args, {pre={''}, post={''}})

    local content = {self.text}

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
    return args.pre .. self.pre_text .. self.text .. self.post_text .. args.post
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

function Divider:snippet() return {t({self:str(), "", ""})} end
function Divider:str()
    local str = self.start_string
    return str .. string.rep(self.fill_char, self.width - (str:len()))
end

--------------------------------------------------------------------------------
--                                  headers                                   --
--------------------------------------------------------------------------------
local Header = Object:extend()
function Header:new(args)
    args = _G.default_args(args, {size='small', as_link=false, text=''})
    for k, v in pairs(args) do
        self[k] = v
    end

    self.size_info = size_to_info[args.size]
    self.divider = Divider({size=args.size, as_header=true})
end

function Header:str()
    local content = self.size_info.header.content_start or ''

    if self.text:len() > 0 then
        content = content .. " " .. self.text
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
    if self.text:len() > 0 then
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
        Link({text=self.text}):str({pre=self.size_info.header.content_start .. " "}),
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

    if self.text:len() > 0 then
        table.insert(post, "")
    end

    return Link({text=self.text}):snippet({pre=pre, post=post})
end

--------------------------------------------------------------------------------
--                                 access                                     --
--------------------------------------------------------------------------------
return {
    Link = Link,
    Divider = Divider,
    Header = Header,
    LinkHeader = LinkHeader,
}
