local M = {
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
}

M.on_open = function(win)
    vim.opt.showmode = false
    vim.opt.showcmd = false
    vim.opt_local.spell = true

    function quit_zen()
        vim.cmd("ZenMode")
        vim.cmd("quit")
    end

    vim.keymap.set("n", " q", quit_zen, {silent = true})
end

M.on_close = function()
    vim.opt.showmode = true
    vim.opt.showcmd = true
    vim.opt_local.spell = false

    vim.keymap.set("n", " q", ":q<cr>", {silent = true})
end

return M
