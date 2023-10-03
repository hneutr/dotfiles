string = require("hl.string")
local Object = require("util.object")
local List = require("hl.list")

local snips = require("snips")

local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local ps = ls.parser.parse_snippet

--------------------------------------------------------------------------------
--                                  dividers                                  --
--------------------------------------------------------------------------------
local Divider = require('htn.text.divider'):extend()
function Divider:snippet() return {t({tostring(self), ""})} end

local divider_s = function(key, size)
    return ps(key, string.format([[
        %s
        $1
    ]], (tostring(Divider(size)))))
end

--------------------------------------------------------------------------------
--                                  headers                                   --
--------------------------------------------------------------------------------
local TestHeader = require("htl.text.neoheader")

function header(size, content)
    content = content or "$1"
    return tostring(TestHeader({size = size, content = content})) .. "\n$2"
end

function link_header(size, content)
    content = content or "[$1]($2)"
    return tostring(TestHeader({size = size, content = content})) .. "\n$3"
end


--------------------------------------------------------------------------------
--                                   access                                   --
--------------------------------------------------------------------------------
return {
    Divider = Divider,
    Header = Header,
    divider_s = divider_s,
    header = header,
    link_header = link_header,
}
