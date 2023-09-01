string = require("hl.string")
local Object = require("util.object")
local List = require("hl.list")
local uuid = require("hd.uuid")

local snips = require("snips")

local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local function get_today() return vim.fn.strftime("%Y%m%d") end

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
--                                   Flags                                    --
--------------------------------------------------------------------------------
local Flags = Link:extend()
Flags.pre_text = "|"
Flags.post_text = "|"

--------------------------------------------------------------------------------
--                                  dividers                                  --
--------------------------------------------------------------------------------
local Divider = require('htn.text.divider'):extend()
function Divider:snippet() return {t({tostring(self), ""})} end

--------------------------------------------------------------------------------
--                                  headers                                   --
--------------------------------------------------------------------------------
local Header = require('htn.text.header'):extend()
function Header:snippet()
    if self.content_value:len() > 0 then
        return {t(tostring(self))}
    else
        return {
            t({
                tostring(self.divider),
                self.content_start .. " ",
            }),
            i(1),
            t({
                "",
                tostring(self.divider),
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
        tostring(self.divider),
        Link({inner=self.content}):str({pre=self.content_start .. " "}),
        tostring(self.divider),
    }
end

function LinkHeader:snippet()
    local pre = {
        tostring(self.divider),
        self.content_start .. " ",
    }

    local post = {
        "",
        tostring(self.divider),
    }

    if self.content_value:len() > 0 then
        table.insert(post, "")
    end

    return Link({inner=self.content}):snippet({pre=pre, post=post})
end

--------------------------------------------------------------------------------
--                                  Journal                                   --
--------------------------------------------------------------------------------
local Journal = Object:extend()

function Journal:new(args)
    self.divider = Divider('large')
end

function Journal:snippet()
    return {
        t("["), f(get_today), t({"]():", "", ""}),
        i(1),
        t{"", "", tostring(self.divider), ""}
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
            tostring(self.divider),
            "",
        }),
    }
end

--------------------------------------------------------------------------------
--                                  metadata                                  --
--------------------------------------------------------------------------------
local Metadata = require("hd.metadata")

function Metadata:snippet()
    return snips.to_snippet(self:components())
end

--------------------------------------------------------------------------------
--                                   access                                   --
--------------------------------------------------------------------------------
return {
    Link = Link,
    Flags = Flags,
    Divider = Divider,
    Header = Header,
    LinkHeader = LinkHeader,
    Metadata = Metadata,
    Journal = Journal,
}
