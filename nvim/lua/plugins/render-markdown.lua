local M = require('render-markdown')

M.setup({
    render_modes = true,
    heading = {
        enabled = true,
        sign = false,
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

vim.keymap.set(
    "n",
    "<leader>r",
    function()
        M.disable()
        M.enable()
    end,
    {}
)
