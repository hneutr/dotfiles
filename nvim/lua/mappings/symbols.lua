local symbols_map = {
    -----------------------------[ lowercase letters ]------------------------------
    ["a"] = require('mappings.unicode.arrows'),
    ["d"] = require('mappings.unicode.doublestruck'),
    ["g"] = require('mappings.unicode.greek'),
    ['l'] = require('mappings.unicode.logic'),
    ["m"] = require('mappings.unicode.math'),
    ["s"] = require('mappings.unicode.shapes'),

    -----------------------------[ uppercase letters ]------------------------------
    ["M"] = "ꟽ",
    ["P"] = "ꟼ",

    ----------------------------------[ numbers ]-----------------------------------
    ["0"] = "°",

    ----------------------------------[ symbols ]-----------------------------------
    ['-'] = "—",
    ["="] = "≠",
    ["<"] = "≤",
    [">"] = "≥",
    ['^'] = require('mappings.unicode.superscripts'),
    ['_'] = require('mappings.unicode.subscripts'),

    -----------------------------------[ arrows ]-----------------------------------
    ["Left"] = "←",
    ["Right"] = "→",
    ["Up"] = "↑",
    ["Down"] = "↓",
}

function get_nested_mapping(key, val)
    prefix = prefix or ""

    local mappings = {}
    if type(val) == "string" then
        table.insert(mappings, {key, val})
        mappings[key] = val
    else
        for suffix, subval in pairs(val) do
            for _, submapping in ipairs(get_nested_mapping(key .. suffix, subval)) do
                table.insert(mappings, submapping)
            end
        end
    end

    return mappings
end

local symbols = {}
for key, val in pairs(symbols_map) do
    local lhs = "<" .. vim.g.symbol_insert_modifier .. "-" .. key .. ">"

    for _, mapping in ipairs(get_nested_mapping(lhs, val)) do
        table.insert(symbols, mapping)
    end
end

return symbols
