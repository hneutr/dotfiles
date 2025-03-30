local conf = {
    render_modes = true,
    anti_conceal = {
        ignore = {
            dash = true,
            callout = true,
            check_scope = true,
        },
    },
    heading = {
        position = 'inline',
        icons = {' '},
        width = {'full', 'block'},
        min_width = 60,
        min_width = {-1, 60, 40, 20},
        right_pad = {-1, 1},
        border = true,
        border_virtual = true,
    },
    code = {
        position = 'left',
        sign = false,
        style = 'normal',
    },
    quote = {
        icon = '▋',
        repeat_linebreak = true,
    },
    checkbox = {
        unchecked = {icon = ' '},
        checked = {
            icon = ' ',
            scope_highlight = "RenderMarkdownChecked",
        },
        custom = {
            maybe = {
                raw = '[~]',
                -- rendered = '󰾟 ',
                rendered = '~',
                highlight = 'Delimiter',
                scope_highlight = "Delimiter",
            },
            reject = {
                raw = '[!]',
                rendered = '󰅗 ',
                highlight = 'rainbow1',
                scope_highlight = "rainbow1",
            },
            important = {
                raw = '[#]',
                rendered = '󰀧 ',
                highlight = 'Keyword',
                scope_highlight = "Keyword",
            },
        },
    },
    callout = {
        todo = {
            raw = '[!todo]',
            rendered = 'todo:  ',
            highlight = 'RenderMarkdownInfo',
        },
        change = {
            raw = '[!change]',
            rendered = 'change:  ',
            highlight = 'Character',
        },
        note = {
            raw = '[!note]',
            rendered = 'note:  ',
            highlight = 'Special',
        },
        prose_end = {
            raw = '[!end]',
            quote_icon = "◇",
            rendered = string.rep("◇", 79),
            highlight = 'Statement',
        },
    },
    link = {
        enabled = true,
        image = '',
        email = '',
        hyperlink = '',
        footnote = {
            superscript = false,
            prefix = '^',
            suffix = '',
        },
    },
    bullet = {enabled = false},
    pipe_table = {enabled = false},
    sign = {enabled = false},
}

local zen_conf = vim.tbl_extend("force", conf, {
    dash = {
        width = 20,
        left_margin = 30,
    },
})

return function(zen)
    require("render-markdown").setup(zen == true and zen_conf or conf)
end
