string = require("hl.string")

local ls = require("luasnip")

local t = ls.text_node
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
--                                   access                                   --
--------------------------------------------------------------------------------
return {
    Divider = Divider,
    divider_s = divider_s,
}
