local ls = require"luasnip"

ls.config.set_config({
    -- ensure tab behaves normally outside snips
    region_check_events = 'InsertEnter',
    delete_check_events = 'InsertLeave',
})

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

--------------------------------------------------------------------------------
--                           utility functions                                --
--------------------------------------------------------------------------------
local function charline(args)
    args = _G.default_args(args, { char = '-', len = 80, start = '' })
    local str = args.start
    while str:len() < args.len do
        str = str .. args.char
    end
    return str
end

local inline_header_args = {
    line_start = '',
    pre_text = '[ ',
    post_text = ' ]',
    fill_char = '-',
    min_fill_left = 2,
}

local function header_line(text, args)
    args = _G.default_args(args, {
        line_start = '--',
        line_end = '--',
        pre_text = '',
        post_text = '',
        fill_char = ' ',
        min_fill_left = 0,
        min_fill_right = 0,
        len = 80,
    })

    local space_to_fill = args.len - text:len()
    local space_to_fill = space_to_fill - args.line_start:len() - args.line_end:len()
    local space_to_fill = space_to_fill - args.pre_text:len() - args.post_text:len()

    local left_space = math.max(math.floor(space_to_fill / 2) - args.line_start:len(), args.min_fill_left)
    local right_space = math.max(space_to_fill - left_space, args.min_fill_right)

    local left_fill = string.rep(args.fill_char, left_space)
    local right_fill = string.rep(args.fill_char, right_space)

    return {
        left = args.line_start .. left_fill .. args.pre_text,
        right = args.post_text .. right_fill .. args.line_end,
    }
end

local function header_line_left(args, snip, user_args)
    if type(user_args) == 'table' and table.getn(user_args) > 0 then
        user_args = user_args[1]
    end

    return header_line(args[1][1], user_args).left
end

local function header_line_right(args, snip, user_args)
    if type(user_args) == 'table' and table.getn(user_args) > 0 then
        user_args = user_args[1]
    end

    return header_line(args[1][1], user_args).right
end

--------------------------------------------------------------------------------
--                                 snips                                      --
--------------------------------------------------------------------------------
ls.add_snippets("all", {
    s("quote", {
        t{"-----",
        ""}, i(1, ""), t{":",
        "",
        ""}, i(2, "quote"),
        t{"",
        "",
        "quote"}
    }),
    s("td", { f(function() return vim.fn.strftime("%Y%m%d") end) }),
    s("tw", {
        f(function()
            local today = vim.fn.strftime("%Y%m%d")
            local today_plus_six_days = vim.fn.strftime("%Y%m%d", vim.fn.localtime() + 518400)
            return today .. "-" .. today_plus_six_days
        end)
    }),
    -- close things
    s("(", { t '(', i(1), t ')' }),
    s("[", { t '[', i(1), t ']' }),
    s("{", { t '{', i(1), t '}' }),
    s("<", { t '<', i(1), t '>' }),
    s("'", { t "'", i(1), t "'" }),
    s('"', { t '"', i(1), t '"' }),
    s('`', { t '`', i(1), t '`' }),
    s('_', { t '_', i(1), t '_' }),
    s('__', { t '__', i(1), t '__' }),
    s('*', { t '*', i(1), t '*' }),
    s('**', { t '**', i(1), t '**' }),
    s('$', { t '$', i(1), t '$' }),
})

--------------------------------------------------------------------------------
--                               javascript                                   --
--------------------------------------------------------------------------------
ls.add_snippets("javascript", {
    s("print", { t("console.log(JSON.stringify("), i(1, ""), t("))") }),
    s("p", { t("console.log("), i(1, ""), t(")") }),
    s("qp", { t("console.log('"), i(1, ""), t("')"), }),
    s("h1", {
        t{ charline{ char = '/' }, "// " },
        i(1, "name"),
        t{"", "//", "// "},
        i(2, "desc"),
        t{ "", charline{ char = '/' } },
    }),
})

ls.add_snippets("lua", {
    s("p", { t("vim.pretty_print("), i(1), t(")") }),
    s("qp", { t("vim.pretty_print('"), i(1), t("')"), }),
    s("h1", {
        t{ charline{ char = '-' }, "" },
        f(header_line_left, {1}, {}), i(1), f(header_line_right, {1}, {}), t{ "",
        charline{ char = '-' },
        "-- "}, i(2),
        t{ "", charline{ char = '-' } }
    }),
    s("h2", {
        t{ charline{ char = '-' }, "" },
        f(header_line_left, {1}, {}), i(1), f(header_line_right, {1}, {}), t{ "",
        charline{ char = '-' } },
    }),
    s("h3", {
        f(header_line_left, {1}, { user_args = { {inline_header_args} }}),
        i(1),
        f(header_line_right, {1}, { user_args = { {inline_header_args} }}),
    }),
})

--------------------------------------------------------------------------------
--                                markdown                                    --
--------------------------------------------------------------------------------
local big_line = charline{ char = '-', start = '#' }
local small_line = charline{ char = '-', len = 40 }

ls.add_snippets("markdown", {
    s("mc", { t{"["}, i(1), t "]()" }),
    s("bh", {
        t{ big_line,
        "# " }, i(1), t{ "",
        big_line}
    }),
    s("h", {
        t{ small_line,
        "> " }, i(1), t{ "",
        small_line }
    }),
    s("mbh", {
        t{ big_line,
        "# [" }, i(1), t{ "]()",
        big_line}
    }),
    s("mh", {
        t{ small_line,
        "> [" }, i(1), t{ "]()",
        small_line }
    }),
    s("bl", { t(big_line) }),
    s("l", { t(small_line) }),
    s("journal", {
        t("["),
        f(function() return vim.fn.strftime("%Y%m%d") end), t{"]():",
        "",
        ""}, i(1),
        t{"",
        "",
        charline{ char = '-' }}
    })
})

--------------------------------------------------------------------------------
--                                 python                                     --
--------------------------------------------------------------------------------
ls.add_snippets("python", {
    -- printing
    s("p", { t("print("), i(1), t(")") }),
    s("qp", { t("print('"), i(1), t("')"), }),
    -- imports
    s("die", { t("import sys; sys.exit()") }),
    s("idefd", { t("from collections import defaultdict") }),
    s("ipath", { t("from pathlib import path") }),
    s("ipd", { t("import pandas as pd") }),
    s("inp", { t("import numpy as np") }),
    s("iplt", { t("import matplotlib.pyplot as plt") }),
    s("ism", { t("import statsmodels.api as sm") }),
    s("pp", { t("import pprint; pp = pprint.PrettyPrinter(); pp.pprint("), i(1), t(")") }),
    -- other
    s("main", {
        t{"if __name__ == '__main__':",
        "    "}, i(1),
    }),
    s("init", { t("def __init__(self, "), i(1), t("):") }),
})

--------------------------------------------------------------------------------
--                                  vim                                       --
--------------------------------------------------------------------------------
local header_args = {
    line_start = '"',
    line_end = '"',
}

local inline_header_args = {
    line_start = '"',
    pre_text = '[ ',
    post_text = ' ]',
    fill_char = '-',
    min_fill_left = 1,
}

ls.add_snippets("vim", {
    s("p", { t("echo "), i(1), t(")") }),
    s("qp", { t("echo '"), i(1), t("')"), }),
    s("h1", {
        t{ charline{ char = '-', start = '"' }, "" },
        f(header_line_left, {1}, { user_args = { {header_args} }}),
        i(1),
        f(header_line_right, {1}, { user_args = { {header_args} }}), t{ "",
        charline{ char = '-', start = '"' },
        '" '}, i(2),
        t{ "", charline{ char = '-', start = '"' } }
    }),
    s("h2", {
        t{ charline{ char = '-', start = '"' }, "" },
        f(header_line_left, {1}, { user_args = { {header_args} }}),
        i(1),
        f(header_line_right, {1}, { user_args = { {header_args} }}), t{ "",
        charline{ char = '-', start = '"' } },
    }),
    s("h3", {
        f(header_line_left, {1}, { user_args = { {inline_header_args} }}),
        i(1),
        f(header_line_right, {1}, { user_args = { {inline_header_args} }}),
    }),
})
