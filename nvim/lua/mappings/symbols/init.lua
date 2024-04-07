-- search: https://unicodeplus.com/search
-- wikipedia: https://en.wikipedia.org/wiki/Unicode_block
return Dict({
    ----------------------------------[ letters ]-----------------------------------
    ["A"] = require('mappings.symbols.accents'),
    ["a"] = require('mappings.symbols.arrows'),
    ["C"] = "⊂",
    ["c"] = "✓",
    ["d"] = require('mappings.symbols.doublestruck'),
    ["g"] = require('mappings.symbols.greek'),
    ['j'] = require('mappings.symbols.subscripts'),
    ['k'] = require('mappings.symbols.superscripts'),
    ['l'] = require('mappings.symbols.logic'),
    ["m"] = require('mappings.symbols.math'),
    ["o"] = "◻",
    ["s"] = require('mappings.symbols.shapes'),
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
