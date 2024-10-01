require('render-markdown').setup({
    render_modes = true,
    heading = {
        enabled = true,
        position = 'inline',
        icons = {''},
        width = {'full', 'block'},
        min_width = 60,
        min_width = {-1, 60, 40, 20},
        right_pad = {-1, 1},
        border = true,
        border_virtual = true,
        above = '▄',
        below = '▀',
    },
    code = {
        enabled = true,
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
        repeat_linebreak = true,
    },
    checkbox = {
        enabled = true,
        unchecked = {icon = '◻'},
        checked = {icon = '✓'},
    },
    callout = {
        todo = {raw = '[!TODO]', rendered = 'todo:', highlight = 'RenderMarkdownInfo'},
    },
    bullet = {enabled = false},
    pipe_table = {enabled = false},
    link = {enabled = false},
    sign = {enabled = false},
})
