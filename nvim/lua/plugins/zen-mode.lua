local function change_markdown_render_config(opening)
    if vim.opt.ft:get() ~= 'markdown' then
        return
    end

    local conf = require("plugins.render-markdown")()

    if opening then
        conf.dash = {
            width = 20,
            left_margin = 30,
        }
    end

    require("render-markdown").setup(conf)
end

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
        change_markdown_render_config(true)
    end,
    on_close = function()
        vim.opt.showmode = true
        vim.opt.showcmd = true
        vim.opt_local.spell = false

        vim.keymap.set("n", " q", ":q<cr>", {silent = true})
        change_markdown_render_config(false)
    end,
}
