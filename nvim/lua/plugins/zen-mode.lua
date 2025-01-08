return {
    window = {
        backdrop = 1,
        height = 0.9,
        width = 80,
        options = {
            signcolumn = "no",
            number = false,
            relativenumber = false,
            cursorline = false,
            cursorcolumn = false,
            foldcolumn = "0",
            list = false,
        },
    },
    on_open = function()
        vim.opt.showmode = false
        vim.opt.showcmd = false
        vim.opt_local.spell = true

        vim.keymap.set("n", "<leader>q", "<cmd>ZenMode | quit<cr>", {silent = true})

        if vim.opt.ft:get() == 'markdown' then
            require("plugins.render-markdown")(true)
        end
    end,
    on_close = function()
        vim.opt.showmode = true
        vim.opt.showcmd = true
        vim.opt_local.spell = false

        vim.keymap.set("n", " q", ":q<cr>", {silent = true})

        if vim.opt.ft:get() == 'markdown' then
            require("plugins.render-markdown")()
        end
    end,
}
