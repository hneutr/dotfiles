return function(zen_mode)
    return {
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
            position = '',
        },
        -- dash = {
        -- },
        quote = {
            icon = '▋',
            repeat_linebreak = true,
        },
        checkbox = {
            unchecked = {icon = '◻'},
            checked = {
                icon = '✓',
                scope_highlight = "RenderMarkdownChecked",
            },
            custom = {
                maybe = {
                    raw = '[~]',
                    rendered = '~',
                    highlight = 'Delimiter',
                    scope_highlight = "Delimiter",
                },
                reject = {
                    raw = '[!]',
                    rendered = '⨉',
                    highlight = 'rainbow1',
                    scope_highlight = "rainbow1",
                },
                important = {
                    raw = '[#]',
                    rendered = '!',
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
        bullet = {enabled = false},
        pipe_table = {enabled = false},
        link = {enabled = false},
        sign = {enabled = false},
    }
end
