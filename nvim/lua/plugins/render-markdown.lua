require('render-markdown').setup({
    render_modes = {'n', 'v', 'i', 'c'},
    heading = {
        enabled = true,
        sign = false,
        position = 'inline',
        icons = {''},
        width = {'full', 'block'},
        min_width = 60,
        border = true,
        above = '▄',
        below = '▀',
    },
    code = {
        enabled = true,
        sign = false,
        style = 'full',
        position = '',
    },
    dash = {
        enabled = true,
        icon = '─',
        width = 'full',
    },
    quote = {
        enabled = true,
        icon = '▋',
    },
    bullet = {enabled = false},
    checkbox = {enabled = false},
    pipe_table = {enabled = false},
    link = {enabled = false},
    sign = {enabled = false},
})
