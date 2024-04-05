-- search: https://unicodeplus.com/search
-- wikipedia: https://en.wikipedia.org/wiki/Unicode_block
local mappings = Dict({
    ----------------------------------[ letters ]-----------------------------------
    ["A"] = require('mappings.unicode.accents'),
    ["a"] = require('mappings.unicode.arrows'),
    ["c"] = "✓",
    ["d"] = require('mappings.unicode.doublestruck'),
    ["g"] = require('mappings.unicode.greek'),
    ['j'] = require('mappings.unicode.subscripts'),
    ['k'] = require('mappings.unicode.superscripts'),
    ['l'] = require('mappings.unicode.logic'),
    ["m"] = require('mappings.unicode.math'),
    ["o"] = "◻",
    ["s"] = require('mappings.unicode.shapes'),
    ["x"] = "⨉",

    ----------------------------------[ numbers ]-----------------------------------
    ["0"] = "°",

    ----------------------------------[ symbols ]-----------------------------------
    ['-'] = "—", -- em dash
    ["="] = "≠",
    ["<"] = "≤",
    [">"] = "≥",

    -----------------------------------[ arrows ]-----------------------------------
    ["Left"] = "←",
    ["Right"] = "→",
    ["Up"] = "↑",
    ["Down"] = "↓",

})

mappings:transformk(function(key)
    return string.format("<%s-%s>", vim.g.symbol_insert_modifier, key)
end)

local to_flatten = List({mappings})

local flat_mappings = List()
while #to_flatten > 0 do
    to_flatten:pop():foreach(function(lhs, rhs)
        if type(rhs) == 'string' then
            flat_mappings:append({lhs, rhs})
        else
            to_flatten:append(Dict(rhs):transformk(function(_lhs) return lhs .. _lhs end))
        end
    end)
end

return flat_mappings
