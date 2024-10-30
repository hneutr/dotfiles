-- search: https://unicodeplus.com/search
-- wikipedia: https://en.wikipedia.org/wiki/Unicode_block
return Dict({
    ----------------------------------[ letters ]-----------------------------------
    l = require('mappings.symbols.logic'),
    m = require('mappings.symbols.math'),
    s = require('mappings.symbols.shapes'),

    ----------------------------------[ numbers ]-----------------------------------
    -- ["0"] = "°",

    ----------------------------------[ symbols ]-----------------------------------
    -- ['-'] = "—", -- em dash
    -- ["="] = "≠",
    -- ["<"] = "≤",
    -- [">"] = "≥",
    -- ["`"] = "≈",

    -----------------------------------[ arrows ]-----------------------------------
    -- Left = "←",
    -- Right = "→",
    -- Up = "↑",
    -- Down = "↓",
}):transformk(function(k)
    return string.format("<%s-%s>", vim.g.symbol_insert_modifier, k)
end)
