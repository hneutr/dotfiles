local M = {}

local ls = require"luasnip"
local su = require"snips"

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local big_divider = su.charline{ char = '-', line_start = '#' }
local small_divider = su.charline{ char = '-', len = 40 }

function get_header_ls(text_start, divider)
    return {
        t{ divider,
        text_start .. " " }, i(1), t{ "",
        divider }
    }
end

function get_link_header_ls(text_start, divider)
    return {
        t{ divider,
        text_start .. " [" }, i(1), t{ "]()",
        divider }
    }
end

--------------------------------------------------------------------------------
--                                 access                                     --
--------------------------------------------------------------------------------
local M = {
    divider = {
        big = {
            str = function() return big_divider end,
            ls = t(big_divider),
        },
        small = {
            str = function() return small_divider end,
            ls = t(small_divider),
        },
    },
    link = {
        str = function(text) return '[' .. text or '' .. ']()' end,
        ls = { t("["), i(1), t("]()") },
    },
    header = {
        big = {
            str = function(text) return { big_divider, "# " .. text, big_divider } end,
            ls = get_header_ls("#", big_divider),
        },
        small = {
            str = function(text) return { small_divider, "> " .. text, small_divider } end,
            ls = get_header_ls(">", small_divider),
        },
    },
    link_header = {
        big = {
            str = function(text) return { big_divider, "# [" .. text .. "]()", big_divider } end,
            ls = get_link_header_ls("#", big_divider),
        },
        small = {
            str = function(text) return { small_divider, "> [" .. text .. "]()", small_divider } end,
            ls = get_link_header_ls(">", small_divider),
        },
    },
}

return M
