local M = {}

local ls = require"luasnip"

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

--------------------------------------------------------------------------------
--                           utility functions                                --
--------------------------------------------------------------------------------
function M.charline(args)
    args = _G.default_args(args, { char = '-', len = 80, line_start = '', line_end = '' })
    local str = args.line_start
    while str:len() < args.len - args.line_end:len() do
        str = str .. args.char
    end

    return str .. args.line_end
end

--------------------------------------------------------------------------------
--                                headers                                     --
--------------------------------------------------------------------------------
local header = {
    line = {
        args = {
            defaults = {
                fill_char = ' ',
                line_start = '',
                line_end = '',
                pre_text = '',
                post_text = '',
                min_fill_left = 0,
                min_fill_right = 0,
                len = 80,
            },
            inline_defaults = {
                pre_text = '[ ',
                post_text = ' ]',
                fill_char = '-',
            },
        },
        side = { args = {}, },
    },
    h1 = {},
    h2 = {},
    h3 = {},
    divider = {}
}

function header.divider.get(comment_str)
    return M.charline{ line_start = comment_str, line_end = comment_str }
end

function header.line.side.args.get(args)
    args = _G.default_args(args, { side = 'left', comment_str = '', line_type = 'multiline' })

    header_args = header.line.args.get(args.line_type)
    header_args.side = args.side
    header_args.line_start = args.comment_str
    header_args.line_end = args.comment_str

    return header_args
end

function header.line.args.get(line_type)
    local args = {}
    if line_type == 'inline' then
        args = _G.default_args(args, header.line.args.inline_defaults)
    end

    return _G.default_args(args, header.line.args.defaults)
end

function header.line.side.get(text, args)
    local before_space = args.line_start:len() + args.pre_text:len()
    local after_space = args.line_end:len() + args.post_text:len()
    local available_space = args.len - text:len() - before_space - after_space

    local left_space = math.max(math.floor(available_space / 2), args.min_fill_left)
    local right_space = math.max(available_space - left_space, args.min_fill_right)

    local before, space, after
    if args.side == 'left' then
        before, space, after = args.line_start, left_space, args.pre_text
    else
        before, space, after = args.post_text, right_space, args.line_end
    end

    return before .. string.rep(args.fill_char, space) .. after
end

function header.line.side.get_ls(args, snip, user_args)
    if type(user_args) == 'table' and table.getn(user_args) > 0 then
        user_args = user_args[1]
    end

    return header.line.side.get(args[1][1], user_args)
end

function header.line.get(args)
    args = _G.default_args(args, { as_snippet = true, text = '', comment_str = '', line_type = 'multiline' })

    local l_args = header.line.side.args.get{
        side = 'left',
        comment_str = args.comment_str,
        line_type = args.line_type,
    }

    local r_args = header.line.side.args.get{
        side = 'right',
        comment_str = args.comment_str,
        line_type = args.line_type,
    }

    if args.as_snippet then
        return f(header.line.side.get_ls, {1}, { user_args = { l_args } }), i(1), f(header.line.side.get_ls, {1}, { user_args = { r_args }})
    else
        return header.line.side.get(args.text, l_args) .. args.text .. header.line.side.get(args.text, r_args)
    end
end

function header.h1.get(text, comment_str)
    local divider = header.divider.get(comment_str)
    local header_line = header.line.get{ text = text, as_snippet = false, comment_str = comment_str }

    return {
        divider,
        header_line,
        divider,
        comment_str .. " ",
        divider,
    }
end

function header.h1.get_ls(comment_str)
    local divider = header.divider.get(comment_str)
    local left, text, right = header.line.get{ comment_str = comment_str }

    return {
        t{ divider,
        "" }, left, text, right,
        t{ "", divider,
        comment_str .. " "}, i(2),
        t{ "", divider }
    }
end

function header.h2.get(text, comment_str)
    local divider = header.divider.get(comment_str)
    local header_line = header.line.get{ text = text, as_snippet = false, comment_str = comment_str }

    return {
        divider,
        header_line,
        divider,
    }
end

function header.h2.get_ls(comment_str)
    local divider = header.divider.get(comment_str)
    local left, text, right = header.line.get{ comment_str = comment_str }

    return {
        t{ divider,
        "" }, left, text, right,
        t{ "", divider }
    }
end

function header.h3.get(text, comment_str)
    return { header.line.get{ text = text, as_snippet = false, comment_str = comment_str, line_type = 'inline' } }
end

function header.h3.get_ls(comment_str)
    return { header.line.get{ comment_str = comment_str, line_type = 'inline' } }
end

function M.get_header_snippets(comment_str)
    return {
        s("h1", header.h1.get_ls(comment_str)),
        s("h2", header.h2.get_ls(comment_str)),
        s("h3", header.h3.get_ls(comment_str)),
    }
end

function M.get_print_snippets(args)
    args = _G.default_args(args, { print_fn = 'print', fn_open = '(', fn_close = ')'})

    return {
        s("p", { t(args.print_fn .. args.fn_open), i(1), t(args.fn_close) }),
        s("qp", { t(args.print_fn .. args.fn_open .. '"'), i(1), t('"' .. args.fn_close) }),
    }
end

return M
