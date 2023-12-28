local actions = require("fzf-lua.actions")
require('fzf-lua').setup {
    winopts = {
        height = .4,
        width = .4,
        row = .5,
        col = .5,
        on_create = function()
            local map = vim.api.nvim_buf_set_keymap
            map(0, 't', "<c-l>", "<c-l>", {})
            map(0, 't', "<c-j>", "<c-j>", {})
            map(0, 't', "<c-n>", "<down>", {})
            map(0, 't', "<c-p>", "<up>", {})

            vim.o.laststatus = false
            vim.api.nvim_create_autocmd({"WinLeave"}, {buffer=0, callback=function() vim.o.laststatus = 2 end})
        end,
    },
    actions = {
        files = {
            ["default"]     = actions.file_edit_or_qf,
            ["ctrl-j"]      = actions.file_split,
            ["ctrl-l"]      = actions.file_vsplit,
            ["ctrl-t"]      = actions.file_tabedit,
        },
    },
    files = {
        fd_opts = "--color=never --type f --no-hidden --follow --exclude env",
    }
}
