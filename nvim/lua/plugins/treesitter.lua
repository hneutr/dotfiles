require('nvim-treesitter.configs').setup {
    ensure_installed = {
        "lua",
        "python",
        "javascript",
        "markdown",
        "markdown_inline",
        "bash"
    },
    sync_install = false,
    auto_install = true,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
    },
    indent = {
        enable = true,
        disable = {'markdown', 'markdown_inline'},
    }
}

vim.api.nvim_set_hl(0, "@markup.strong", {link = "@spell"})
vim.api.nvim_set_hl(0, "@markup.italic", {link = "@spell"})
