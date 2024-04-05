local symbols_map = Dict({
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

function get_nested_mapping(key, val)
    local mappings = List()
    if type(val) == "string" then
        mappings:append({key, val})
    else
        for suffix, subval in pairs(val) do
            for _, submapping in ipairs(get_nested_mapping(key .. suffix, subval)) do
                table.insert(mappings, submapping)
            end
        end
    end

    return mappings
end

local symbols = List()
symbols_map:foreach(function(key, val)
    local lhs = string.format("<%s-%s>", vim.g.symbol_insert_modifier, key)
    symbols:extend(get_nested_mapping(lhs, val))
end)

return symbols
